// deno-lint-ignore-file ban-unused-ignore
import { DNSRecord } from "./classes/dns.ts";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { corsHeaders } from "../../../shared/cors.ts";
import { validateSubDomain } from "../../../shared/validators/subdomain.ts";
import { validateCloudflareId } from "../../../shared/validators/cloudflareId.ts";
import { authenticate } from "../../../shared/util/auth.ts";
import { deleteDomain } from "../../../shared/functions/delete.ts";
import { streamToString } from "../../../shared/functions/string.ts";

const CREATE_DOMAIN_ROUTE = new URLPattern({ pathname: "/create-sub-domain" });

// TODO: -> comprar outro domínio?

export async function createDomain(req: Request): Promise<Response> {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  } else if (
    req.method === "POST" || req.method === "PUT" || req.method === "DELETE"
  ) {
    const url = new URL(req.url);
    const match = CREATE_DOMAIN_ROUTE.exec({ pathname: url.pathname });

    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      {
        global: {
          // Desabilita qualquer dependência no ambiente do navegador
          fetch: fetch, // Usa o fetch do runtime (Deno ou outro)
        },
        auth: {
          autoRefreshToken: false,
          persistSession: false,
          detectSessionInUrl: false,
        },
      },
    );

    const authHeader = req.headers.get("Authorization")!;
    const token = authHeader.replace("Bearer ", "");
    const json = await req.json();
    const data = await authenticate(supabaseClient, token, json["token"]).catch(
      (error) => {
        console.log(error);
        return new Response();
      },
    );
    const subdomain = (json["sub"] as string || "").trim();
    const pointsTo = (json["pointsTo"] as string || "").trim();
    const nameType = json["type"] || 0 as number;
    const cloudflareId = ((json["cloudflareId"] as string) || "").trim();
    const domain = ".e-um.dev.br"; // TODO: If planning to add more domains, this needs to be dynamic
    if (req.method != "DELETE") {
      const isValidSubdomain = await validateSubDomain(
        subdomain + domain,
        pointsTo,
        supabaseClient,
        nameType,
      );
      if (!isValidSubdomain) {
        return new Response(
          "Subdomain is invalid or already in use, incorrect or invalid name type, or domain points to invalid value (ip or url)",
          {
            status: 400,
            headers: corsHeaders,
          },
        );
      }
    }
    if (json["token"] == null) {
      return new Response("Not authenticated", {
        status: 403,
        headers: corsHeaders,
      });
    }

    if (!data || data.data.user?.id == null) {
      return new Response("Malformed authentication credentials", {
        headers: corsHeaders,
        status: 403,
      });
    }

    // deno-lint-ignore no-var
    // deno-lint-ignore no-inner-declarations
    const tempClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      {
        global: {
          // Desabilita qualquer dependência no ambiente do navegador
          fetch: fetch, // Usa o fetch do runtime (Deno ou outro)
        },
        auth: {
          autoRefreshToken: false,
          persistSession: false,
          detectSessionInUrl: false,
        },
      },
    );
    const secrets = await (tempClient.from("secrets").select("*"));

    if (secrets.data?.length == 0) {
      return new Response("Unable to obtain keys from database.", {
        status: 403,
        headers: corsHeaders,
        statusText: "Unable to obtain keys.",
      });
    }
    const ZONE_ID = secrets.data?.find((val) => val["name"] === "zone_id")
      ?.value;
    const LIMIT = secrets.data?.find((val) => val["name"] === "limit")
      ?.value;
    const AUTH_EMAIL = secrets.data?.find((val) => val["name"] === "auth_email")
      ?.value;
    const AUTH_KEY = secrets.data?.find((val) => val["name"] === "auth_key")
      .value;

    const { count, error } = await supabaseClient
      .from("records")
      .select("owner", { count: "exact", head: true })
      .eq("owner", data?.data?.user?.id);

    if (error) {
      console.error("Erro na consulta:", error);
      return new Response("Error verifying domains.", {
        status: 500,
        headers: corsHeaders,
      });
    }

    if ((count ?? 0) >= LIMIT && req.method === "POST") {
      return new Response("Error. You have reached the limit of domains.", {
        headers: corsHeaders,
        status: 400,
      });
    }
    if (match) {
      const dnsRecord = new DNSRecord({
        comment: JSON.stringify({ "owner": data?.data.user?.id }),
        content: pointsTo,
        name: `${subdomain}.e-um.dev.br`,
        proxied: json["proxied"] || false,
        type: nameType == 1 ? "CNAME" : "A",
      });
      // TODO: Verify if domain is already registered or find a way to register into the database before adding the record in cloudflare, maybe creating a help request channel would be a solution. So that if the domain is inserted in the database, but not in the dns, users can reach for help. Or maybe creating a periodic check for records in cloudflare
      if (req.method === "POST") {
        const resp = await fetch(
          `https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records`,
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "X-Auth-Email": AUTH_EMAIL,
              "X-Auth-Key": AUTH_KEY,
            },
            body: JSON.stringify(dnsRecord),
          },
        );

        const parsedBody = JSON.parse(
          await streamToString(resp.body || new ReadableStream()),
        );

        if (resp.status == 200) {
          const { error } = await supabaseClient.from("records").insert(
            {
              name: dnsRecord.name,
              type: nameType,
              proxied: dnsRecord.proxied,
              target: dnsRecord.content,
              cloudflareId: parsedBody.result.id,
            },
          );
          if (error) {
            return new Response("Error. Limited by database constraints", {
              headers: corsHeaders,
              status: 400,
            });
          }
        }
        return new Response(resp.statusText, {
          status: resp.status,
          headers: corsHeaders,
        });
      } else if (req.method === "PUT") {
        if (await validateCloudflareId(cloudflareId, supabaseClient)) {
          await supabaseClient.from("records")
            .update({
              proxied: dnsRecord.proxied,
              name: dnsRecord.name,
              type: nameType,
              target: dnsRecord.content,
            }).eq("cloudflareId", cloudflareId).select();
          const resp = await fetch(
            `https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${cloudflareId}`,
            {
              method: "PATCH",
              headers: {
                "Content-Type": "application/json",
                "X-Auth-Email": AUTH_EMAIL,
                "X-Auth-Key": AUTH_KEY,
              },
              body: JSON.stringify(dnsRecord),
            },
          );
          return new Response(resp.statusText, {
            status: resp.status,
            headers: corsHeaders,
          });
        }
      } else if (req.method === "DELETE") {
        console.log(supabaseClient);
        deleteDomain(
          cloudflareId,
          supabaseClient,
          AUTH_EMAIL,
          AUTH_KEY,
          ZONE_ID,
        );
      }
    }
    return new Response("Error. Record not found or malformed request", {
      headers: corsHeaders,
      status: 404,
    });
  } else {
    return new Response("Error. Can't serve this request method.", {
      headers: corsHeaders,
      status: 400,
    });
  }
}

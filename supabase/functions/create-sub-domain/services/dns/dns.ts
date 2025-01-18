import { DatabaseRecord, DNSRecord } from "./classes/dns.ts";
import { createClient, SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { corsHeaders } from "../../../shared/cors.ts";
import { validateSubDomain } from "../../validators/subdomain.ts";
import { resolveTxt } from "node:dns";
import { validateCloudflareId } from "../../validators/cloudflareId.ts";
const CREATE_DOMAIN_ROUTE = new URLPattern({ pathname: "/create-sub-domain/" });

// TODO: -> comprar outro domínio?
async function authenticate(
  supabaseClient: SupabaseClient,
  token: string,
  refresh_token: string,
) {
  try {
    return await supabaseClient.auth.setSession({
      access_token: token,
      refresh_token: refresh_token,
    });
  } catch (e) {
    console.log(e);
  }
}
async function streamToString(
  stream: ReadableStream<Uint8Array>,
): Promise<string> {
  const reader = stream.getReader();
  const decoder = new TextDecoder();
  let result = "";

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    result += decoder.decode(value, { stream: true });
  }

  // Decodificar qualquer parte pendente.
  result += decoder.decode();
  return result;
}
export async function createDomain(req: Request): Promise<Response> {
  const url = new URL(req.url);
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  } else if (
    req.method === "POST" || req.method === "PUT" || req.method === "DELETE"
  ) {
    const match = CREATE_DOMAIN_ROUTE.exec({ pathname: url.pathname });
    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    );

    //console.log(req.headers);
    const authHeader = req.headers.get("Authorization")!;
    const token = authHeader.replace("Bearer ", "");
    const json = await req.json();
    const data = await authenticate(supabaseClient, token, json["token"]);
    const subdomain = (json["sub"] as string).trim();
    const pointsTo = (json["pointsTo"] as string).trim();
    const nameType = json["type"] as number;
    const cloudflareId = (json["cloudflareId"] as string) || "".trim();
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
          },
        );
      }
    }
    if (json["token"] == null) {
      return new Response("Not authenticated", { status: 403 });
    }

    if (!data || data.data.user?.id == null) {
      return new Response("Malformed authentication credentials", {
        status: 403,
      });
    }
    const secrets = await (supabaseClient.from("secrets").select("*"));
    if (secrets.data?.length == 0) {
      return new Response("Unable to obtain auth keys from database.", {
        status: 403,
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
      return new Response("Error verifying domains.", { status: 500 });
    }

    console.log("Contagem de domínios:", count);

    if ((count ?? 0) >= LIMIT && req.method != "DELETE") {
      return new Response("Error. You have reached the limit of domains.", {
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

      console.log(req.method);
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
            console.log(error);
            return new Response("Error. Limited by database constraints", {
              status: 400,
            });
          }
        }
        return new Response(resp.statusText, { status: resp.status });
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
          return new Response(resp.statusText, { status: resp.status });
        }
      } else if (req.method === "DELETE") {
        if (await validateCloudflareId(cloudflareId, supabaseClient)) {
          const resp = await fetch(
            `https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${cloudflareId}`,
            {
              method: "DELETE",
              headers: {
                "Content-Type": "application/json",
                "X-Auth-Email": AUTH_EMAIL,
                "X-Auth-Key": AUTH_KEY,
              },
            },
          );
          const respBody = JSON.parse(
            await streamToString(resp.body || new ReadableStream()),
          );
          console.log(resp);

          if (respBody.result == null) {
            return new Response(resp.statusText, { status: resp.status });
          } else if (respBody.result.id == cloudflareId) {
            supabaseClient.from("records").delete().eq("id", cloudflareId);
            return new Response(resp.statusText, { status: resp.status });
          }
        }
      }
    }
    return new Response("Error. Record not found or malformed request", {
      status: 404,
    });
  } else {
    return new Response("Error. Can't serve this request method.", {
      status: 400,
    });
  }
}

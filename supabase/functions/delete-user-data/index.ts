// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { authenticate } from "../shared/util/auth.ts";
import { createClient } from "jsr:@supabase/supabase-js@2.47.14";
import { corsHeaders } from "../shared/cors.ts";
import { deleteDomain } from "../shared/functions/delete.ts";
import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.47.14/src/SupabaseClient.ts";
const CREATE_DOMAIN_ROUTE = new URLPattern({ pathname: "/delete-user-data" });
Deno.serve(async (req) => {
  const url = new URL(req.url);
  const match = CREATE_DOMAIN_ROUTE.exec({ pathname: url.pathname });
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }
  const authHeader = req.headers.get("Authorization")!;

  if (authHeader == null) {
    return new Response("Unable to obtain authorization key", {
      headers: corsHeaders,
      status: 400,
    });
  }
  const token = authHeader.replace("Bearer ", "");

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
  const { refreshToken } = await req.json();
  const data = await authenticate(supabaseClient, token, refreshToken);
  if (data?.error == null) {
    const adminClient = createClient(
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
    const secrets = await (adminClient.from("secrets").select("*"));

    if (secrets.data?.length == 0) {
      return new Response("Unable to obtain keys from database.", {
        status: 403,
        headers: corsHeaders,
        statusText: "Unable to obtain keys.",
      });
    }
    const ZONE_ID = secrets.data?.find((val) => val["name"] === "zone_id")
      ?.value;
    const AUTH_EMAIL = secrets.data?.find((val) => val["name"] === "auth_email")
      ?.value;
    const AUTH_KEY = secrets.data?.find((val) => val["name"] === "auth_key")
      .value;

    const userRecords = await supabaseClient.from("records").select("*");
    console.log("USER DATA:");
    console.log(data);
    for (const record in userRecords.data) {
      console.log(userRecords.data[Number.parseInt(record)]["cloudflareId"]);

      await deleteDomain(
        userRecords.data[Number.parseInt(record)]["cloudflareId"],
        supabaseClient,
        AUTH_EMAIL,
        AUTH_KEY,
        ZONE_ID,
      );
    }
    console.log("id:", data?.data.user?.id ?? "AAA");
    await adminClient.auth.admin.deleteUser(data?.data.user?.id ?? "");
    await adminClient.from("records").delete().eq(
      "owner",
      data?.data.user?.id ?? "",
    );
    if (data?.error) {
      return new Response(JSON.stringify(data?.error ?? "Error"), {
        status: 400,
        headers: corsHeaders,
      });
    } else {
      return new Response("ok", {
        status: 200,
        headers: corsHeaders,
      });
    }
  } else {
    return new Response(
      "Unable to authenticate",
      { headers: corsHeaders, status: 400 },
    );
  }
});

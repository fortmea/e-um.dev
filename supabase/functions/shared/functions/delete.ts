import { validateCloudflareId } from "../validators/cloudflareId.ts";
import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
import { streamToString } from "./string.ts";
import { corsHeaders } from "../cors.ts";
export async function deleteDomain(
    cloudflareId: string,
    supabaseClient: SupabaseClient,
    AUTH_EMAIL: string,
    AUTH_KEY: string,
    ZONE_ID: string,
) {
    if (await validateCloudflareId(cloudflareId, supabaseClient)) {
        console.log("ok");
        console.log(true);
        console.log(cloudflareId);
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
        console.log(respBody);
        if (respBody.result.id == cloudflareId) {
            await supabaseClient.from("records").delete().eq(
                "cloudflareId",
                cloudflareId,
            );
            return new Response(resp.statusText, {
                headers: corsHeaders,
                status: resp.status,
            });
        } else {return new Response(resp.statusText, {
                headers: corsHeaders,
                status: resp.status,
            });}
    }
}

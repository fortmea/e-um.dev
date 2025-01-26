import SupabaseClient from "https://jsr.io/@supabase/supabase-js/2.47.14/src/SupabaseClient.ts";

const md5RegExp = RegExp("^[a-fA-F0-9]{32}$");
export async function validateCloudflareId(
  id: string,
  supabaseClient: SupabaseClient,
): Promise<boolean> {
  //console.log(id);
  console.log("-----------------------------------");
  //console.log(supabaseClient.auth);
  const { data, error } = await supabaseClient.from(
    "records",
  ).select(
    "*",
  ).eq(
    "cloudflareId",
    id,
  ).limit(1);
  console.log(id.match(md5RegExp));
  console.log(data?.length);
  console.log(error);
  return id.match(md5RegExp) != null && (data?.length || 0) > 0 && !error;
}

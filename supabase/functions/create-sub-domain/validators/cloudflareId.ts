import { SupabaseClient } from "jsr:@supabase/supabase-js@2";
const md5RegExp = RegExp("^[a-fA-F0-9]{32}$");
export async function validateCloudflareId(
  id: string,
  supabaseClient: SupabaseClient,
): Promise<boolean> {
  const { data, error } = await supabaseClient.from(
    "records",
  ).select(
    "*",
  ).eq(
    "cloudflareId",
    id,
  ).limit(1);
  return id.match(md5RegExp) != null && (data?.length || 0) > 0 && !error; //id.match(md5RegExp) != null;
}

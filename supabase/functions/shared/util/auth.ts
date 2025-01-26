import {
  AuthResponse,
  SupabaseClient,
} from "jsr:@supabase/supabase-js@2.47.14";

export async function authenticate(
  supabaseClient: SupabaseClient,
  accessToken: string,
  refreshToken: string,
): Promise<AuthResponse> {
  try {
    const data = await supabaseClient.auth.setSession({
      access_token: accessToken,
      refresh_token: refreshToken,
    });
    if (data.error) {
      console.error("Error setting session:", data.error);
      throw new Error(data.error.message);
    }
    return data;
  } catch (e) {
    console.error("Unexpected error in authenticate:", e);
    throw e;
  }
}

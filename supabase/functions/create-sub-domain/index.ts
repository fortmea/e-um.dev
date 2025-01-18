// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createDomain } from "./services/dns/dns.ts";
console.log(`Function "create-sub-domain" running!`);

Deno.serve((req) => createDomain(req));

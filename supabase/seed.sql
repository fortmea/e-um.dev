

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."set_short_id"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  truncated_id TEXT;
BEGIN
  -- Gerar um UUID truncado para 15 caracteres
  truncated_id := LEFT(NEW.id::TEXT, 15);

  -- Verificar se já existe um ID com o mesmo valor na tabela
  WHILE EXISTS (SELECT 1 FROM notes WHERE short_id = truncated_id) LOOP
    -- Gerar outro UUID truncado caso haja colisão
    truncated_id := LEFT(gen_random_uuid()::TEXT, 15);
  END LOOP;

  -- Definir o valor único no campo short_id
  NEW.short_id := truncated_id;

  RETURN NEW;
END;
$$;


ALTER FUNCTION "public"."set_short_id"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."notes" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "title" "text" NOT NULL,
    "content" "text" NOT NULL,
    "author" "uuid" NOT NULL,
    "is_public" boolean DEFAULT false,
    "created_at" timestamp without time zone DEFAULT "now"(),
    "short_id" "text"
);


ALTER TABLE "public"."notes" OWNER TO "postgres";


ALTER TABLE ONLY "public"."notes"
    ADD CONSTRAINT "notes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."notes"
    ADD CONSTRAINT "notes_short_id_key" UNIQUE ("short_id");



CREATE OR REPLACE TRIGGER "generate_short_id" BEFORE INSERT ON "public"."notes" FOR EACH ROW EXECUTE FUNCTION "public"."set_short_id"();



ALTER TABLE ONLY "public"."notes"
    ADD CONSTRAINT "notes_author_fkey" FOREIGN KEY ("author") REFERENCES "auth"."users"("id");



CREATE POLICY "Allow access to own notes" ON "public"."notes" FOR SELECT USING (("author" = "auth"."uid"()));



CREATE POLICY "Allow access to public notes" ON "public"."notes" FOR SELECT USING (("is_public" = true));



CREATE POLICY "Allow delete own notes" ON "public"."notes" FOR DELETE USING (("author" = "auth"."uid"()));



ALTER TABLE "public"."notes" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."set_short_id"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_short_id"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_short_id"() TO "service_role";


















GRANT ALL ON TABLE "public"."notes" TO "anon";
GRANT ALL ON TABLE "public"."notes" TO "authenticated";
GRANT ALL ON TABLE "public"."notes" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;

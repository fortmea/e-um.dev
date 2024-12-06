-- Create the table
create table
  notes (
    id uuid primary key default uuid_generate_v4 (),
    title text not null,
    content text not null,
    author uuid references auth.users not null,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT now(),
    short_id text unique
  );

alter table notes enable row level security;

CREATE POLICY "Allow access to own notes" ON notes FOR
SELECT
  USING (author = auth.uid ());

CREATE POLICY "Allow access to public notes" ON notes FOR
SELECT
  USING (is_public = TRUE);

CREATE POLICY "Allow delete own notes" ON notes FOR DELETE USING (author = auth.uid ());

CREATE OR REPLACE FUNCTION set_short_id()
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_short_id
BEFORE INSERT ON notes
FOR EACH ROW
EXECUTE FUNCTION set_short_id();

-- Insert some sample data into the table
insert into
  notes (title, content, author)
values
  (
    'test1',
    'blah',
    '087a98f7-5e44-457e-a8a3-4457d03d5acb'
  ),
  (
    'test2',
    'blah',
    '087a98f7-5e44-457e-a8a3-4457d03d5acb'
  ),
  (
    'test3',
    'blah',
    '087a98f7-5e44-457e-a8a3-4457d03d5acb'
  );

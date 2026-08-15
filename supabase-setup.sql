-- My Dojo — struttura del database
-- Da eseguire UNA VOLTA sola nel pannello Supabase: SQL Editor > New query > incolla > Run

-- Tabella 1: le schede di allenamento (es. "Petto/Tricipiti")
create table workout_templates (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  created_at timestamptz not null default now()
);

-- Tabella 2: gli esercizi dentro ogni scheda (es. "Panca piana")
create table template_exercises (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  template_id uuid not null references workout_templates(id) on delete cascade,
  name text not null,
  order_index int not null default 0,
  created_at timestamptz not null default now()
);

-- Tabella 3: gli allenamenti svolti (una "sessione" = una volta che vai in palestra)
create table workout_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  template_id uuid references workout_templates(id) on delete set null,
  template_name text not null,
  started_at timestamptz not null default now(),
  finished_at timestamptz
);

-- Tabella 4: le singole serie registrate durante un allenamento
create table session_sets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  session_id uuid not null references workout_sessions(id) on delete cascade,
  template_exercise_id uuid references template_exercises(id) on delete set null,
  exercise_name text not null,
  set_number int not null,
  reps int not null,
  weight numeric not null,
  created_at timestamptz not null default now()
);

-- Sicurezza: ogni utente vede e modifica SOLO i propri dati (mai quelli degli altri)
alter table workout_templates enable row level security;
alter table template_exercises enable row level security;
alter table workout_sessions enable row level security;
alter table session_sets enable row level security;

create policy "own rows only" on workout_templates
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own rows only" on template_exercises
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own rows only" on workout_sessions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own rows only" on session_sets
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- My Dojo — aggiornamento 2: esercizi a tempo (circuiti) e schede pronte
-- Da eseguire UNA VOLTA sola nel pannello Supabase: SQL Editor > New query > incolla > Run
-- Non tocca i dati che hai già (schede, esercizi, allenamenti): aggiunge solo cose nuove.

-- Aggiunge alle schede esistenti la possibilità di avere esercizi "a tempo"
-- (durata in secondi + istruzioni su come farlo). Se non li usi, restano vuoti
-- e tutto continua a funzionare come prima (modo serie/ripetizioni/peso).
alter table template_exercises add column duration_seconds int;
alter table template_exercises add column instructions text;

-- Tabelle per le "schede pronte": un catalogo comune a tutti gli utenti,
-- che tu (e chiunque altro) potete copiare tra le vostre schede personali.
create table preset_templates (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  created_at timestamptz not null default now()
);

create table preset_template_exercises (
  id uuid primary key default gen_random_uuid(),
  preset_template_id uuid not null references preset_templates(id) on delete cascade,
  name text not null,
  instructions text,
  duration_seconds int not null,
  order_index int not null default 0,
  created_at timestamptz not null default now()
);

-- Tutti gli utenti loggati possono leggere il catalogo (ma non modificarlo:
-- i contenuti li aggiungiamo noi via SQL, come stiamo facendo ora).
alter table preset_templates enable row level security;
alter table preset_template_exercises enable row level security;

create policy "lettura per utenti loggati" on preset_templates
  for select using (auth.role() = 'authenticated');

create policy "lettura per utenti loggati" on preset_template_exercises
  for select using (auth.role() = 'authenticated');

-- Contenuto: 3 circuiti pronti a corpo libero (nessun attrezzo necessario)
insert into preset_templates (id, name, description) values
  ('11111111-1111-1111-1111-111111111111', 'Circuito Total Body', 'Allenamento a corpo libero per tutto il corpo, adatto a principianti e intermedi.'),
  ('22222222-2222-2222-2222-222222222222', 'Cardio HIIT Express', 'Circuito cardio ad alta intensità, breve e intenso.'),
  ('33333333-3333-3333-3333-333333333333', 'Core Express', 'Allenamento mirato per addominali e core, senza attrezzi.');

insert into preset_template_exercises (preset_template_id, name, instructions, duration_seconds, order_index) values
  ('11111111-1111-1111-1111-111111111111', 'Jumping Jacks', 'Salta divaricando le gambe e alzando le braccia sopra la testa, poi torna alla posizione di partenza. Mantieni un ritmo costante.', 30, 0),
  ('11111111-1111-1111-1111-111111111111', 'Squat a corpo libero', 'Piedi alla larghezza delle spalle, scendi piegando le ginocchia come per sederti su una sedia, schiena dritta e peso sui talloni, poi risali.', 30, 1),
  ('11111111-1111-1111-1111-111111111111', 'Push-up (piegamenti)', 'Mani leggermente più larghe delle spalle, corpo in linea retta, scendi piegando i gomiti quasi fino a toccare il pavimento, poi spingi su. Puoi appoggiare le ginocchia se serve.', 30, 2),
  ('11111111-1111-1111-1111-111111111111', 'Affondi alternati', 'Fai un passo avanti, piega entrambe le ginocchia a 90°, torna in piedi e alterna la gamba.', 30, 3),
  ('11111111-1111-1111-1111-111111111111', 'Plank', 'Appoggiati su avambracci e punte dei piedi, corpo in linea retta da testa a talloni, contrai addominali e glutei.', 30, 4),
  ('11111111-1111-1111-1111-111111111111', 'Mountain Climbers', 'In posizione di plank alta, porta alternativamente le ginocchia al petto a ritmo sostenuto.', 30, 5),
  ('11111111-1111-1111-1111-111111111111', 'Ponte glutei (Glute Bridge)', 'Sdraiato supino, ginocchia piegate, solleva il bacino contraendo i glutei, poi scendi controllando il movimento.', 30, 6),
  ('11111111-1111-1111-1111-111111111111', 'Superman', 'Sdraiato prono, solleva contemporaneamente braccia, petto e gambe da terra, mantieni due secondi e rilascia.', 30, 7),

  ('22222222-2222-2222-2222-222222222222', 'Ginocchia alte (High Knees)', 'Corri sul posto portando le ginocchia più in alto possibile, muovi le braccia come nella corsa.', 30, 0),
  ('22222222-2222-2222-2222-222222222222', 'Burpees', 'Accovacciati, porta i piedi indietro in posizione di plank, torna con i piedi avanti e salta in alto.', 30, 1),
  ('22222222-2222-2222-2222-222222222222', 'Jumping Jacks', 'Salta divaricando le gambe e alzando le braccia sopra la testa, poi torna alla posizione di partenza.', 30, 2),
  ('22222222-2222-2222-2222-222222222222', 'Squat Jump', 'Esegui uno squat e, in risalita, salta esplosivamente verso l''alto, atterra morbido e ripeti.', 30, 3),
  ('22222222-2222-2222-2222-222222222222', 'Plank Jacks', 'In posizione di plank, salta aprendo e chiudendo le gambe come in un jumping jack, mantenendo il bacino stabile.', 30, 4),
  ('22222222-2222-2222-2222-222222222222', 'Mountain Climbers', 'In posizione di plank alta, porta alternativamente le ginocchia al petto a ritmo sostenuto.', 30, 5),

  ('33333333-3333-3333-3333-333333333333', 'Plank', 'Appoggiati su avambracci e punte dei piedi, corpo in linea retta da testa a talloni, contrai addominali e glutei.', 30, 0),
  ('33333333-3333-3333-3333-333333333333', 'Crunch', 'Sdraiato supino, ginocchia piegate, solleva le spalle da terra contraendo gli addominali, senza tirare il collo con le mani.', 30, 1),
  ('33333333-3333-3333-3333-333333333333', 'Bicycle Crunch', 'Sdraiato supino, porta alternativamente il gomito verso il ginocchio opposto in un movimento a pedalata.', 30, 2),
  ('33333333-3333-3333-3333-333333333333', 'Plank laterale destro', 'Appoggiato sull''avambraccio destro, corpo in linea retta lateralmente, bacino sollevato.', 20, 3),
  ('33333333-3333-3333-3333-333333333333', 'Plank laterale sinistro', 'Appoggiato sull''avambraccio sinistro, corpo in linea retta lateralmente, bacino sollevato.', 20, 4),
  ('33333333-3333-3333-3333-333333333333', 'Leg Raises (sollevamento gambe)', 'Sdraiato supino, gambe tese, sollevale fino a 90° mantenendo la parte bassa della schiena a contatto con il pavimento, poi scendi lentamente.', 30, 5),
  ('33333333-3333-3333-3333-333333333333', 'Superman', 'Sdraiato prono, solleva contemporaneamente braccia, petto e gambe da terra, mantieni due secondi e rilascia.', 30, 6);

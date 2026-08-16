-- My Dojo — aggiornamento 3: Libreria Esercizi
-- Da eseguire UNA VOLTA sola nel pannello Supabase: SQL Editor > New query > incolla > Run
-- Non tocca i dati che hai già: aggiunge solo cose nuove.

-- Tabella della libreria esercizi. Le righe con user_id vuoto (NULL) sono il
-- catalogo comune scritto da noi via SQL (come le "Schede pronte"), visibile
-- a tutti gli utenti ma non modificabile da loro. Le righe con user_id
-- valorizzato sono esercizi personali: li vede e li modifica solo chi li ha creati.
create table exercises (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade,
  name text not null,
  muscle_primary text not null,
  muscles_secondary text[] not null default '{}',
  equipment text not null,
  difficulty text,
  instructions text,
  image_url text,
  created_at timestamptz not null default now()
);

alter table exercises enable row level security;

-- Tutti gli utenti loggati vedono il catalogo comune (user_id nullo) più i propri esercizi personali.
create policy "lettura catalogo e propri esercizi" on exercises
  for select using (user_id is null or auth.uid() = user_id);

-- Un utente può creare solo esercizi propri (mai righe di catalogo comune, che restano gestite da noi via SQL).
create policy "creazione solo esercizi propri" on exercises
  for insert with check (auth.uid() = user_id);

create policy "modifica solo esercizi propri" on exercises
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "cancellazione solo esercizi propri" on exercises
  for delete using (auth.uid() = user_id);

-- Collega gli esercizi di una scheda a un esercizio della libreria (facoltativo:
-- se un esercizio della scheda è stato scritto a mano, questo campo resta vuoto
-- e tutto continua a funzionare come prima).
alter table template_exercises add column library_exercise_id uuid references exercises(id) on delete set null;

-- Contenuto: catalogo di partenza, 30 esercizi classici per gruppo muscolare e attrezzatura.
insert into exercises (name, muscle_primary, muscles_secondary, equipment, difficulty, instructions) values
  ('Push-up (Piegamenti sul petto)', 'Petto', array['Tricipiti','Spalle'], 'Corpo libero', 'Principiante',
    'Mani leggermente più larghe delle spalle, corpo in linea retta dalla testa ai talloni. Scendi piegando i gomiti fino quasi a toccare il pavimento, poi spingi per tornare su. Se è troppo difficile, appoggia le ginocchia a terra.'),
  ('Panca piana con bilanciere', 'Petto', array['Tricipiti','Spalle'], 'Bilanciere', 'Intermedio',
    'Sdraiato su una panca, impugna il bilanciere leggermente più largo delle spalle. Scendi controllando fino a sfiorare il petto, poi spingi verso l''alto senza bloccare di scatto i gomiti. Tieni i piedi ben appoggiati a terra per stabilità.'),
  ('Croci con manubri', 'Petto', array['Spalle'], 'Manubri', 'Intermedio',
    'Sdraiato su una panca con un manubrio per mano, braccia leggermente piegate sopra il petto. Apri le braccia lateralmente in un ampio arco fino a sentire lo stiramento del petto, poi richiudile senza far toccare i manubri con forza.'),
  ('Dip alle parallele', 'Tricipiti', array['Petto','Spalle'], 'Corpo libero', 'Intermedio',
    'In appoggio sulle parallele, braccia tese. Scendi piegando i gomiti fino a circa 90°, tenendo il busto leggermente inclinato in avanti, poi risali spingendo con le braccia.'),
  ('Trazioni alla sbarra (Pull-up)', 'Schiena', array['Bicipiti','Avambracci'], 'Sbarra', 'Avanzato',
    'Impugna la sbarra a mani leggermente più larghe delle spalle, palmi in avanti. Tira il corpo verso l''alto fino a portare il mento sopra la sbarra, poi scendi controllando il movimento senza lasciarti cadere.'),
  ('Rematore con bilanciere', 'Schiena', array['Bicipiti'], 'Bilanciere', 'Intermedio',
    'Busto inclinato in avanti a circa 45°, schiena dritta, bilanciere impugnato a mani prone. Tira il bilanciere verso l''addome stringendo le scapole, poi riabbassa controllando il peso.'),
  ('Lat machine (tiro al petto)', 'Schiena', array['Bicipiti'], 'Macchina', 'Principiante',
    'Seduto con le cosce bloccate sotto i cuscinetti, impugna la barra più larga delle spalle. Tira la barra verso il petto stringendo le scapole, poi lascia risalire il peso in modo controllato.'),
  ('Curl bicipiti con manubri', 'Bicipiti', array['Avambracci'], 'Manubri', 'Principiante',
    'In piedi, un manubrio per mano, gomiti vicini ai fianchi. Piega i gomiti portando i manubri verso le spalle senza muovere i gomiti, poi riabbassa lentamente.'),
  ('Curl bicipiti con bilanciere', 'Bicipiti', array['Avambracci'], 'Bilanciere', 'Principiante',
    'In piedi, impugna il bilanciere a mani supine larghezza spalle. Piega i gomiti sollevando il bilanciere verso il petto senza dondolare il busto, poi riabbassa controllando.'),
  ('French press (Skull Crusher)', 'Tricipiti', array[]::text[], 'Manubri', 'Intermedio',
    'Sdraiato su una panca, un manubrio per mano tenuto sopra il petto a braccia tese. Piega solo i gomiti abbassando i pesi verso la fronte, poi distendi le braccia tornando alla posizione iniziale.'),
  ('Push down ai cavi', 'Tricipiti', array[]::text[], 'Cavi', 'Principiante',
    'In piedi davanti al cavo alto con presa alla barra, gomiti fermi vicino ai fianchi. Spingi la barra verso il basso fino a distendere le braccia, poi risali controllando il peso.'),
  ('Military press (spinte sopra la testa)', 'Spalle', array['Tricipiti'], 'Bilanciere', 'Intermedio',
    'In piedi, bilanciere all''altezza delle clavicole, mani appena più larghe delle spalle. Spingi il bilanciere sopra la testa fino a distendere le braccia, poi riabbassa controllando fino alla posizione di partenza.'),
  ('Alzate laterali con manubri', 'Spalle', array[]::text[], 'Manubri', 'Principiante',
    'In piedi, un manubrio per mano lungo i fianchi. Solleva le braccia lateralmente fino all''altezza delle spalle, gomiti leggermente piegati, poi riabbassa lentamente.'),
  ('Face pull ai cavi', 'Spalle', array['Schiena'], 'Cavi', 'Intermedio',
    'Cavo all''altezza del viso con corda, tira verso il viso separando le mani e portando i gomiti larghi e alti, stringendo le scapole, poi torna controllando alla posizione di partenza.'),
  ('Squat con bilanciere (Back Squat)', 'Quadricipiti', array['Glutei','Femorali'], 'Bilanciere', 'Intermedio',
    'Bilanciere appoggiato sulla parte alta della schiena, piedi larghezza spalle. Scendi piegando le ginocchia come per sederti, schiena dritta, fino a cosce parallele al pavimento, poi risali spingendo sui talloni.'),
  ('Squat a corpo libero', 'Quadricipiti', array['Glutei'], 'Corpo libero', 'Principiante',
    'Piedi alla larghezza delle spalle, scendi piegando le ginocchia come per sederti su una sedia, schiena dritta e peso sui talloni, poi risali.'),
  ('Affondi con manubri', 'Quadricipiti', array['Glutei'], 'Manubri', 'Principiante',
    'Un manubrio per mano lungo i fianchi, fai un passo avanti piegando entrambe le ginocchia a circa 90°, poi torna in piedi e ripeti alternando la gamba.'),
  ('Stacco da terra (Deadlift)', 'Femorali', array['Glutei','Schiena'], 'Bilanciere', 'Avanzato',
    'Bilanciere a terra davanti agli stinchi, piedi larghezza bacino. Con schiena dritta e petto in fuori, afferra il bilanciere e sollevalo estendendo anche e ginocchia insieme, poi riabbassa controllando facendo scorrere il bilanciere lungo le gambe.'),
  ('Leg press', 'Quadricipiti', array['Glutei'], 'Macchina', 'Principiante',
    'Seduto sulla macchina, piedi larghezza spalle sulla piattaforma. Piega le ginocchia portando la piattaforma verso il petto senza staccare i lombari dallo schienale, poi spingi per tornare alla posizione di partenza senza bloccare le ginocchia.'),
  ('Hip thrust con bilanciere', 'Glutei', array['Femorali'], 'Bilanciere', 'Intermedio',
    'Schiena appoggiata su una panca, bilanciere sopra il bacino, piedi a terra larghezza bacino. Spingi il bacino verso l''alto contraendo i glutei fino ad allineare tronco e cosce, poi scendi controllando.'),
  ('Leg curl (macchina femorali)', 'Femorali', array[]::text[], 'Macchina', 'Principiante',
    'Sdraiato prono sulla macchina, caviglie sotto il cuscinetto. Piega le ginocchia portando i talloni verso i glutei, poi riabbassa lentamente senza far toccare il peso.'),
  ('Calf raise in piedi', 'Polpacci', array[]::text[], 'Manubri', 'Principiante',
    'In piedi, un manubrio per mano, sali sulle punte dei piedi il più in alto possibile contraendo i polpacci, poi scendi lentamente fino ad allungare bene il tallone.'),
  ('Plank', 'Addominali', array['Spalle'], 'Corpo libero', 'Principiante',
    'Appoggiati su avambracci e punte dei piedi, corpo in linea retta da testa a talloni, contrai addominali e glutei mantenendo la posizione.'),
  ('Crunch', 'Addominali', array[]::text[], 'Corpo libero', 'Principiante',
    'Sdraiato supino, ginocchia piegate, solleva le spalle da terra contraendo gli addominali, senza tirare il collo con le mani, poi riabbassa controllando.'),
  ('Russian twist con kettlebell', 'Addominali', array['Schiena'], 'Kettlebell', 'Intermedio',
    'Seduto con ginocchia piegate e busto leggermente inclinato indietro, tieni il kettlebell con entrambe le mani e ruota il busto portandolo da un lato all''altro, mantenendo i piedi sollevati se vuoi aumentare la difficoltà.'),
  ('Kettlebell swing', 'Glutei', array['Femorali','Schiena'], 'Kettlebell', 'Intermedio',
    'Piedi larghezza spalle, kettlebell tenuto con entrambe le mani. Piegando leggermente le ginocchia e spingendo il bacino indietro, fai oscillare il kettlebell tra le gambe, poi estendi anche e ginocchia con forza per portarlo all''altezza del petto.'),
  ('Goblet squat con kettlebell', 'Quadricipiti', array['Glutei'], 'Kettlebell', 'Principiante',
    'Tieni il kettlebell con entrambe le mani vicino al petto, piedi larghezza spalle. Scendi in uno squat mantenendo il busto eretto e i gomiti dentro le ginocchia, poi risali.'),
  ('Curl bicipiti con elastico', 'Bicipiti', array['Avambracci'], 'Elastico', 'Principiante',
    'Fissa l''elastico sotto i piedi, impugna le maniglie con i gomiti vicini ai fianchi. Piega i gomiti portando le mani verso le spalle, poi riabbassa controllando la tensione dell''elastico.'),
  ('Rematore con elastico', 'Schiena', array['Bicipiti'], 'Elastico', 'Principiante',
    'Fissa l''elastico a un punto stabile davanti a te, tira le maniglie verso l''addome stringendo le scapole, poi torna in avanti controllando la tensione.'),
  ('Burpees', 'Corpo intero', array['Petto','Quadricipiti','Addominali'], 'Corpo libero', 'Intermedio',
    'Da in piedi, accovacciati e porta le mani a terra, salta con i piedi indietro in posizione di plank, esegui un piegamento se vuoi aumentare la difficoltà, poi porta i piedi avanti e salta in alto con le braccia sopra la testa.');

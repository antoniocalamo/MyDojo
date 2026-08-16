# My Dojo — contesto per Claude Code

## Cos'è
App personale di gestione allenamenti in palestra ("My Dojo"), single-file
HTML/CSS/JS, backend Supabase, pubblicata su GitHub Pages. Ispirata a Fitify:
schede di allenamento, esercizi, registrazione di serie/ripetizioni/peso,
storico e progressi nel tempo.

- File vero e unico: `index.html` (nella radice del repository) — HTML + `<style>`
  + `<script>` tutto nello stesso file. Nessun bundler, nessun build step, nessuna
  dipendenza npm installata: eventuali librerie esterne vanno caricate on-demand
  via `<script>` dinamico, solo quando servono.
- URL pubblico (una volta pubblicata): https://antoniocalamo.github.io/MyDojo/
- Backend Supabase multi-utente: più persone possono registrarsi e usare l'app.
  Non c'è (per ora) un ruolo "admin" come in My Ikigai — da decidere insieme se
  e quando servirà una distinzione tra utenti.
- Non sono uno sviluppatore: usa sempre un linguaggio chiaro e semplice.
  Ogni termine tecnico (git, pull request, branch, commit, deploy, ecc.) va
  spiegato con parole semplici/analogie la prima volta che lo usi in una
  conversazione, non solo "se utile" — per me non è mai scontato.

## Roadmap (per iterazioni successive, non tutto insieme)
1. Schede allenamento: crei una scheda (es. "Petto/Tricipiti") con gli esercizi;
   durante l'allenamento segni serie, ripetizioni e peso.
2. Libreria esercizi: catalogo consultabile (come farli, muscoli coinvolti).
3. Storico e grafici dei progressi (peso sollevato, volume totale nel tempo).
4. Integrazione Apple Watch: **fuori scope per ora** — richiede un'app nativa
   separata (Swift/Xcode, serve un Mac), non è realizzabile come pagina web.
   Da riprendere come progetto a sé quando/se avremo un Mac a disposizione.

## Regole di lavoro
- **Prima di ogni modifica**, scarica sempre l'ultima versione pubblicata su
  GitHub (`git fetch`) e riparti da quella, anche a metà di una conversazione
  già avviata — non fidarti della copia locale se è passato tempo dall'ultimo
  controllo.
- **Non alzare mai `APP_VERSION`** a meno che non venga chiesto esplicitamente
  (quando la introdurremo).
- Dopo ogni modifica, verifica la sintassi JS prima di finire (es. estrarre il
  contenuto tra i tag `<script>` e lanciare `node --check`, oppure eseguire
  l'app in locale se possibile).
- Mostra un mockup o una descrizione prima di modificare solo se lo chiedo io
  esplicitamente in anticipo ("fammi vedere prima come verrebbe..."). Se non lo
  chiedo, procedi direttamente.
- Per bug di CSS/layout che non si risolvono al primo tentativo, crea un file
  di test isolato con dati finti invece di continuare a tentare sull'app
  intera.
- Ho accesso a GitHub direttamente da qui — puoi quindi leggere, modificare e
  fare commit/push direttamente sul repo quando è chiaro cosa fare. Per
  modifiche rischiose o ambigue (es. permessi/segregazione dati tra utenti
  diversi), chiedi prima di procedere.
- **Pubblica sempre subito** (commit, merge sul branch principale e push) non
  appena una modifica è pronta e verificata, senza chiedermi conferma ogni
  volta — a meno che non sia io a chiederti esplicitamente in anticipo un
  mockup o un test preventivo prima di renderla definitiva.
- **Modifiche al database (SQL): niente file nel repository.** Quando serve
  una modifica allo schema Supabase, non creare/committare un file `.sql` —
  scrivimi il codice SQL direttamente nella chat, così lo copio e incollo io
  a mano nel pannello Supabase (SQL Editor).

## Come mi piace lavorare
- Spiegazioni chiare e dirette, senza fronzoli.
- Se una richiesta è ambigua o rischiosa da interpretare, chiedi piuttosto
  che tentare alla cieca.

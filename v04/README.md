🦸‍♂️ Superhero Manager

I detta projekt har varit en rejäl crash-course där jag i korta drag lärt mig mer om hur man:
* Hanterar JSON-data i Dart
* Använder abstrakta klasser och interfaces/class implements
* Strukturerar kod 
* Implementerar singletons (Något jag ännu inte är helt 100 på hur det fungerar)
* Använder async, await och futures
* Använder sig av debuggning vid felsökning

Nedan kommer vi 1 - gå igenom hur programmet körs och vilka alternativ man har, 2 - Mappstruktur, 3 - HeroModellen, 4 - Hjälpfunktioner helpers samt 5 - Managers.

För att köra programmet skriver man följande i terminalen:
dart run bin/main.dart -> Vilket drar igång CLI där en avskalad meny med följande alternativ visas:

Hej och välkommen till Superhjälte-appen!

Ange val (1–8):
1. Lägg till hjälte manuellt        //- Användaren får mata in name, ID (1000-2000 för att undvika konflikt med superhero.com-ID:n), powerstats samt alignment
2. Lägg till hjälte via API         //- Användare får ange sökterm och val att 1 spara första träff, 2 - alla träffar, 3 avbryt, 4 - söka igen
3. Visa alla hjältar                //- Visar alla hjältar som man sparat (manuellt och via API-anrop. Visar även medelvärde för powerstats)
4. Sök hjälte lokalt                //- Användare får ange sökterm för att söka bland lokalt lagrade hjältar
5. Sortera hjältar på Strength      //- Alla lokalt lagrade hjältar listas, med fallande Strength. Visar även medelvärde för powerstats
6. Skapa ASCII-porträtt av hjälte   //- Användare få ASCII-art-porträtt för vald lokalt lagrad hjälte
7. Spara och Avsluta                //- Sparar hjältar lokalt
8. Rensa ALL Data                   //- Tar bort alla hjältar lokalt.
Val: 

🧱 Mappstruktur:

data
├─ heroes.json          #Lokal lagring (json-fil)                     
lib/
├─ models/              # Filer för att generera heroModel-objekt. Samtliga innehåller toJson, fromJson
│  ├─ hero_model.dart   #HeroModel (id, name, powerstats o.s.v.)
│  ├─ powerstats.dart
│  ├─ biography.dart
│  ├─ appearance.dart
│  ├─ ...
│  └─ models.dart       # Barrel file – exporterar alla modeller för smidigare import
│
├─ managers/                      # Hantering av data och logik 
│  ├─ hero_data_manager.dart      # Lagrar hjältar i minne och genomför sök, sortering m.m.
│  ├─ file_storage_manager.dart   # Sparar/Läser JSON-fil
│  ├─ network_manager.dart        # API-anrop mot superheroaop.com
│  
│
├─ helpers/             # Återanvändbara hjälp/stödfunktioner 
│  ├─ input_helper.dart           # Säker inmatning (readString, readInt, readOptions)
│  ├─ show_menu.dart              # Enkel utskrift av huvudmenyn
│  ├─ manual_add_hero.dart        # Flöde för att lägga till hjälte manuellt
│  ├─ ascii_print.dart            # Rendera hjälte som ASCII
│  ├─ add_by_api.dart             # Flöde för att lägga till hjälte/hjältar via API
│  ├─ json_helper.dart            # För konvertering av värden

Denna struktur valdes för att få en känsla av kontroll och mer uppdelad ansvarsfördelning.
    - models/ Lade mycket tid på denna mapp, där skripten definierar data och bygger upp hero-modellen.
    - managers/ Här tog jag stöttning från AI för att förstå funktionalitet kring singletons, resulterade i att jag lyfte nätverksanrop, hantering av objekt i minnet samt ladda/spara till fil fick tre separata managers.
    - helpers/ Här låg till en början stödfunktioner för input, Json-hantering, menyer m.m. men till slut även flöden för att lägga till objekt manuellt/via API samt generering av ASCII-porträtt.

3 - 🧠 HeroModellen
HeroModel är vår klass som skapar hero-objekt. 
För att skapa en instans så sattes id och name som required - resterande sattes som optional och fick ligga som underklasser (Powerstats, Biography, Appearance m.m.)
för att spegla input-formatet från superheroapi.com.

Samtliga klasser/modeller har:
    - factory Class.fromJson(Map<String, Dynamic>) - där map med hero-data konverteras till hero-objekt (json decode tidigare gav map)
    - Map<String, dynamic> toJson()                - hero-objekt konverteras till Map<String, dynamic> (json encode senare ger json)

Hero-objekt/Map<String, dynamic> lagras i lista och konverteras vid sparning / laddning.

 4 - 🧰 Hjälpfunktioner helpers anges nedan med korta beskrivningar

input_helper.dart
    - readString(prompt) – läser icke-tom/null sträng
    - readInt(prompt, {min, max}) – validerad heltalsinmatning med intervall, input krävs
    - readOptionalInt(prompt, {min, max}) – validerad heltalsinmatning med intervall, input krävs EJ
    - readOptions(prompt, List<String>) – tillåtna strängval (case-insensitive om du satt det så)
    - readMenuChoice() – stödfunktion för att styra menyval

json_helper.dart
    - toInt() - försöker konvertera input till int
    - toStr() - försöker konvertera input till String
    - toStrList() - försöker konvertera lista med dynamiska värden till lista med String
    - toJsonMap - Check att input är Map<String, dynamic> 

show_menu.dart
    - printMainMenu() – visar menyn med stegrande fördröjningar 
    - readMainMenuChoice() - tar användar-input

manual_add_hero.dart - Flöde för att manuellt lägga till hjälte
    - manualAddHero - Användare anger light-version av Hero-data (id, name, powerstats samt alignment)
    - Sparar ned hjälte via addHero (i heroDataManager)

add_by_api.dart - Flöde för att lägga till objekt via api. Mest "komplext flöde"
    - 1. Användare anger sökterm vilken skickas till 2. fetchHeroModel (i NetworkManager)
        - 2 fetchHeroModel inväntar fetchHero där :
            * url med sökterm byggs upp
            * Inväntar svar 
            * decodar svar till heroData och returnerar till 3 fetchHeroModel
        - 3 Om resultat icke är null eller tomt -> Skapar lista med hero-objekt från lista med decodad heroData.
    - 4 I add_by_api.dart får användare möjlighet att söka igen eller lägga till (första träff eller ALLA träffar):
        - addHero (i heroDataManager) anropas en gång / med for-loop för att lägga till objekt.

ascii_print.dart Flöde för att generera ASCII-porträtt
    - Anropar getHeroList (i heroDataManager) och filtrerar ut alla med url för Image
    - Printar ut träffar med index och låter användaren välja objekt som ska printas
    - Printar resultatet av convertImage från enough_ascii_art.dart 


5 - 🗂️ Managers
I programmet finns 3st Singleton-instanser som initieras vid programstart:

* HeroDataManager - Ansvarar för att lagra hjältar lokalt, lägga till hjältar, lokala sökningar samt sortering utav hjältar
Innehåller bland annat
    - addHero - Lägger till hjälte (eller uppdaterar befintlig) till lista med hjältar
    - getHeroList - Returnerar lista med hjältar
    - searchHero - Tar in sökterm och returnerar lista med objekt där denna finns
    - sortHeroesByStrength - Returnerar kopia av listan där objekt sorterats med fallande hero.powerstats.strength

* FileStoreManager - 1 Läser in sparad heroes.json och anropar fromJson vidare för konvertering till lista med Heroes-objekt, 2 anropar toJson för att konvertera lista med Heroes-objekt till json-fil. Innehåller bland annat:
    - loadAll  - Laddar in json-data och konverterar till lista med hero-objekt
    - saveAll  - Konverterar lista med hero-objekt till json-fil som skriver över data/heroes.json
    - clearAll - Tömmer data.heroes.json

* NetWorkManager    - Ansvarar för API-anrop där input är sökord (t.ex. "Batman"). Anropas av funktion i lib/helpers genom "net.fetchHeroModel(searchKey)" vilket returnerar en lista med hero-objekt. Innehåller bland annat:
    - fetchHero     - Konstruerar url för API-anrop, tolkar, decodar svar och skapar lista med Map<String, dynamic> från results
    - fetchHeroModel - Skickar elementvis Map<String, dynamic> från decodedList till HeroModel.fromJson och skapar hero-objekt som läggs i lista

MAPPEN TEST 🧪 - Innehåller små skript där olika delar testats, såsom t.ex. json-bearbetning.

Egna tankar:
    *Inte van att arbeta OOP - Så superkul att göra det lite mer seriöst
    *Mycket svårt att greppa class... implements - chat gpt hjälpte en hel del och måste sitta mer för att förstå...
    (Förstår tanken - se extends_exempel.dart, implements_exempel.dart) men min klass heroes är lite för komplex för 
    att enkelt anamma allt.
    *Många begrepp, metoder o.s.v. är nya för mig, sitter lugnt i båten och hoppas man förstår mer framåt.
    *På det stora hela - Tror detta projekt kommer hjälpa mig att se samband och få en känsla för hur allt hänger ihop

Kan bli bättre
    -  Bredare funktionalitet - Ta bort specifika hjältar, lägg till specifika, printa särskilda egenskaper m.m.
    -  Mapp för flöden
    -  Förbättrat UI, snyggare meny, illustrationer vid "väntetid" m.m.
    -  Bättre struktur för testning
    -  Börja med README tidigare
    -  Arbete med Pull, Commit, Merge o.s.v. mer strukturerat i git, har hittills bara skapat nya förgreningar och inte mergat...
    - Kommentarer - Kommentera mer enhetligt och med samma stil genom all kod.
    


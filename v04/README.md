Om projektet

Detta projekt är ett lärande-exempel där jag steg för steg försöker förstå hur man:
Hanterar JSON-data i Dart
Använder abstrakta klasser och interfaces/class implements

Implementerar en singleton för att lagra och söka hjälte-objekt (HeroDataManager)
- Har i nuläget inte riktigt koll på detta...

Använder async / await och Futures

Jag håller fortfarande på att lära mig dessa begrepp, så koden är inte perfekt – men den fungerar och hjälper mig att förstå grunderna bättre.

Just nu är strukturen lite rörig men följande gäller:
    *bin/main.dart - Körbar via dart run main.dart
    *lib/v03.dart - Innehåller funktioner som används av main.dart.
OBS - Ovanstående kommer att helt skrivas om / tas bort.

Struktur för OOP:
    *models/ innehåller datamodeller för hur ett hero-objekt skapas.
    hero_model.dart skapar hero-objekt m.h.a. helpers samt "underklasser"
    *helpers/ innehåller hjälpfunktioner för JSON-hantering
    *managers/ innehåller den abstrakta klassen AbstractHeroDataManaging och implementationen HeroDataManager
    * test/ innehåller exempel på hur man kan skapa hjältar och testa funktioner som addHero, searchHero och sortHeroesByStrength

Hur man kör aktuell testfunktion: 
    dart run test/test_med_data.dart

Egna tankar:
    *Inte van att arbeta OOP - Så superkul att göra det lite mer seriöst
    *Mycket svårt att greppa class... implements - chat gpt hjälpte en hel del och måste sitta mer för att förstå...
    (Förstår tanken - se extends_exempel.dart, implements_exempel.dart) men min klass heroes är lite för komplex för 
    att enkelt anamma allt.
    *Många begrepp, metoder o.s.v. är nya för mig, sitter lugnt i båten och hoppas man förstår mer framåt.
    *På det stora hela - Tror detta projekt kommer hjälpa mig att se samband och få en känsla för hur allt hänger ihop

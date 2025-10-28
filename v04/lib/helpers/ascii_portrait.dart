import 'package:v04/helpers/input_helper.dart' as input;
import 'package:v04/managers/hero_data_manager.dart';
//import 'package:v04/models/hero_model.dart';
import 'package:enough_ascii_art/enough_ascii_art.dart' as art;
import 'package:image/image.dart' as img;
//import 'package:ascii_art_converter/ascii_art_converter.dart' as art;
import 'package:http/http.dart' as http;

Future<void> showHeroAsciiArt(HeroDataManager manager) async {
  // Hämtar lokala hjältar
  final all = await manager.getHeroList();

  // Vi filtrerar fram de som har bild-url
  final withImg = all.where((h) {
    final u = h.heroImage?.url?.trim();
    return u != null && u.isNotEmpty;
  }).toList();

  if (withImg.isEmpty) {
    print('Inga lokalt sparade hjältar med bild hittades.');
    return;
  }

  // printar ut lista med hjältar att välja bland (start från 1)
  print('\nVälj hjälte att rendera som ASCII:');
  for (var i = 0; i < withImg.length; i++) {
    final h = withImg[i];
    print('${i + 1}. ${h.name} (id=${h.id})');
  }

  // Utifrån antal träffar har får vi ut "valspann"
  final max = withImg.length;
  final choice = input.readInt('Ange val (0=avbryt)', min: 0, max: max);

  if (choice == 0) {
    print('Avbrutet.');
    return;
  }

  // -1 för att matcha indexstart 0
  final selected = withImg[choice - 1];

  // rendera ASCII
  // OBS - Gick ej utan proxyUrl... Fick hela tiden fel 403...
  //final url = Uri.parse(selected.heroImage!.url!);
  // Som jag förstår - corsproxy.io är en betrodd mellanhand som tillåts
  //final url = Uri.parse(selected.heroImage!.url!);
  final proxyUrl = Uri.parse('https://corsproxy.io/?${Uri.encodeFull(selected.heroImage!.url!)}');

  print('\nRenderar ${selected.name} från $proxyUrl ...');
  try {
    final res = await http.get(proxyUrl);
    
    if (res.statusCode != 200) {
      print('HTTP ${res.statusCode} – kunde inte hämta bilden');
      return;
    }
    final decoded = img.decodeImage(res.bodyBytes);
    if (decoded == null) {
      print("Kunde inte decoda bilden.");
      return;
    }

    final ascii = art.convertImage(decoded, maxWidth: 120, invert: true);
    print('\n---ASCII-porträtt utav ${selected.name.toUpperCase()}---\n  $ascii\n');
      } catch (e) {
        print('Kunde inte rendera bilden: $e');
      }
    }

    
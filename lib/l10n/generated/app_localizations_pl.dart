// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get unknownArtist => 'Nieznany Artysta';

  @override
  String get settings => 'Ustawienia';

  @override
  String get recent => 'Ostatnie';

  @override
  String get favourite => 'Ulubione';

  @override
  String get favouriteSongs => 'Ulubione piosenki';

  @override
  String get randomSong => 'Losowa piosenka';

  @override
  String get notInitialized => 'Wybierz folder z piosenkami w ustawieniach';

  @override
  String get emptyFolder => 'Aktualnie wybrany folder jest pusty';

  @override
  String get searchSongNotFound => 'Nie znaleziono takiej piosenki';

  @override
  String get recentEmpty => 'Nic nie zostało odtworzone';

  @override
  String get recentlyPlayed => 'Ostatnio odtwarzane';

  @override
  String get favouriteEmpty => 'Nie masz ulubionych piosenek';

  @override
  String get errorGettingFavouriteSongs => 'BŁĄD przy pobieraniu listy ulubionych piosenek';

  @override
  String get errorGettingRecentSong => 'BŁĄD przy pobieraniu listy ostatnio granych piosenek';

  @override
  String get miniPlayerCurrentlyPlaying => 'Aktualnie odtwarzane:';

  @override
  String get miniPlayerNothingPlaying => 'Nic aktualnie nie gra';

  @override
  String get changeSongsFolder => 'Zmień folder z piosenkami';

  @override
  String get selectFolder => 'Wybierz folder';

  @override
  String get exit => 'Wyjdź';

  @override
  String get apply => 'Zastosuj';

  @override
  String get saving => 'Zapisywanie';

  @override
  String get systemTheme => 'Motyw';

  @override
  String get mainColor => 'Główny kolor';

  @override
  String get language => 'Język';
}

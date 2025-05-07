// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get unknownArtist => 'Unknown Artist';

  @override
  String get settings => 'Settings';

  @override
  String get recent => 'Recent';

  @override
  String get favourite => 'Favourite';

  @override
  String get favouriteSongs => 'Favourite songs';

  @override
  String get randomSong => 'Random song';

  @override
  String get notInitialized => 'Please select songs folder in settings';

  @override
  String get emptyFolder => 'Currently selected folder is empty';

  @override
  String get searchSongNotFound => 'No songs found';

  @override
  String get recentEmpty => 'Nothing was played';

  @override
  String get recentlyPlayed => 'Recently played';

  @override
  String get favouriteEmpty => 'You have no favourite songs';

  @override
  String get errorGettingFavouriteSongs => 'ERROR getting favourite songs';

  @override
  String get errorGettingRecentSong => 'ERROR getting recent songs';

  @override
  String get miniPlayerCurrentlyPlaying => 'Currently playing:';

  @override
  String get miniPlayerNothingPlaying => 'Nothing is playing, right now';

  @override
  String get changeSongsFolder => 'Change songs folder';

  @override
  String get selectFolder => 'Select folder';

  @override
  String get exit => 'Exit';

  @override
  String get apply => 'Apply';

  @override
  String get saving => 'Saving';

  @override
  String get systemTheme => 'Theme';

  @override
  String get mainColor => 'Main color';

  @override
  String get language => 'Language';
}

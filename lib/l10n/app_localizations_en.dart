// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get title => 'My Tasks';

  @override
  String get new_task => 'New Task';

  @override
  String get edit_task => 'Edit Task';

  @override
  String get add => 'Add';

  @override
  String get update => 'Update';

  @override
  String get delete_task => 'Delete task?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';
}

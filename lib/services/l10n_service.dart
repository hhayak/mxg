import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mxg/generated/l10n.dart';

class LocalizationService {
  final S strings = S();

  final localizationsDelegates = AppLocalizations.localizationsDelegates;
  final supportedLocales = AppLocalizations.supportedLocales;
}
import 'package:flutter/material.dart';
import 'package:ryal_mobile/l10n/app_localizations.dart';

extension BuildContextL10nExt on BuildContext {
  AppLocalizations get l10n {
    return AppLocalizations.of(this)!;
  }
}

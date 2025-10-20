import 'package:flutter/material.dart';
import 'package:ryal_mobile/extension/localization_ext.dart';

enum UserType  {
  corporate,
  individual
  
}

extension UserTypeExt on UserType {
  String name(BuildContext ctx) {
    switch (this) {
      case UserType.individual:
      return ctx.l10n.individual;
        case UserType.corporate:
      return ctx.l10n.corporate;
    }
  }
}

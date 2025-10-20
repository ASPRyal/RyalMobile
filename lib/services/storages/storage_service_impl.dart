import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:ryal_mobile/services/providers/i_local_storage_provider.dart';
import 'package:ryal_mobile/services/storages/i_storage_service.dart';


@Injectable(as: IStorageService)
class StorageServiceImpl extends IStorageService {
  const StorageServiceImpl({
    required ILocalStorageProvider localProvider,
  }) : _localProvider = localProvider;

  final ILocalStorageProvider _localProvider;


  @override
  Future<void> changeLangCode(String langCode) =>
      _localProvider.saveLangCode(langCode);

  @override
  Future<Locale?> getLangCode() async {
    final result = await _localProvider.getLangCode();
    if (result != null) {
      return Locale.fromSubtags(languageCode: result);
    }
    return null;
  }


}

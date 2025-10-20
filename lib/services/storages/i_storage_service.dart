import 'package:flutter/material.dart';

abstract class IStorageService {
  const IStorageService();


  //Language
  Future<void> changeLangCode(String langCode);
  Future<Locale?> getLangCode();

}

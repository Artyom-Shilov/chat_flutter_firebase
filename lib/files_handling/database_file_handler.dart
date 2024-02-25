import 'dart:io';

abstract interface class DatabaseFileHandler {

  Future<void> uploadFile(File file, String ref);
  Future<String> getDownloadUrl(String ref);
}
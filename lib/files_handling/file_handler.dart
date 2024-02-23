import 'dart:io';

abstract interface class FileHandler {

  Future<void> uploadFile(File file, String ref);
  Future<File?> pickImageFromGallery();
  Future<File?> pickVideoFromGallery();
  Future<String> getDownloadUrl(String ref);
}
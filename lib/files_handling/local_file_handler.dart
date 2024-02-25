import 'dart:io';

abstract interface class LocalFileHandler {
  Future<File?> pickImageFromGallery();
  Future<File?> pickVideoFromGallery();
  Future<File?> pickImageFromCamera();

}
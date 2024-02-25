import 'dart:io';

import 'package:chat_flutter_firebase/files_handling/local_file_handler.dart';
import 'package:image_picker/image_picker.dart';

class LocalFileHandlerImpl implements LocalFileHandler {

  @override
  Future<File?> pickImageFromGallery() async {
    File? image;
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
    return image;
  }

  @override
  Future<File?> pickVideoFromGallery() async {
    File? video;
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
    return video;
  }

  @override
  Future<File?> pickImageFromCamera() async {
    File? image;
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
    return image;
  }
}
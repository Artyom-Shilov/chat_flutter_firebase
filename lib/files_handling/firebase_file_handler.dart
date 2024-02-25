import 'dart:io';

import 'package:chat_flutter_firebase/files_handling/file_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

enum Folders {
  images,
  video
}

class FirebaseFileHandler implements FileHandler {

  @override
  Future<void> uploadFile(File file, String ref) async {
    await FirebaseStorage.instance.ref(ref).putFile(file);
  }

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
  Future<String> getDownloadUrl(String ref) async {
    return await FirebaseStorage.instance.ref().child(ref).getDownloadURL();
  }
}
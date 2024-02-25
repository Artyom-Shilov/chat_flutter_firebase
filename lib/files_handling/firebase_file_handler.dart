import 'dart:io';

import 'package:chat_flutter_firebase/files_handling/database_file_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum Folders {
  images,
  video
}

class FirebaseFileHandler implements DatabaseFileHandler {

  @override
  Future<void> uploadFile(File file, String ref) async {
    await FirebaseStorage.instance.ref(ref).putFile(file);
  }

  @override
  Future<String> getDownloadUrl(String ref) async {
    return await FirebaseStorage.instance.ref().child(ref).getDownloadURL();
  }
}
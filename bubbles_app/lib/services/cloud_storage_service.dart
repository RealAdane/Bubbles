//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import "dart:io";

import 'package:flutter/foundation.dart';

const String userCollection = "users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService();

  Future<String?> saveUserImageToStorage(String uid, PlatformFile file) async {
    try {
      Reference ref =
          _storage.ref().child('images/users/$uid/profile.${file.extension}');
      UploadTask task = ref.putFile(
        File(file.path!),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<String?> saveChatImageToStorage(
      String chatID, String userID, PlatformFile file) async {
    try {
      Reference ref = _storage.ref().child(
          'images/bubbles/$chatID/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');
      UploadTask task = ref.putFile(
        File(file.path!),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}

extension BubbleCloudStorageService on CloudStorageService {
  Future<String?> saveBubbleImageToStorage(String uid, PlatformFile file,
      [void param2]) async {
    try {
      Reference ref =
          _storage.ref().child('images/bubbles/$uid/profile.${file.extension}');
      UploadTask task = ref.putFile(
        File(file.path!),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<String?> saveSentBubbleImageToStorage(
      String bubbleID, String userID, PlatformFile file) async {
    try {
      Reference ref = _storage.ref().child(
          'images/bubbles/$bubbleID/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');
      UploadTask task = ref.putFile(
        File(file.path!),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}

extension ExplorerCloudStorageService on CloudStorageService {
  Future<String?> saveExplorerImageToStorage(String uid, PlatformFile file,
      [void param2]) async {
    try {
      Reference ref =
          _storage.ref().child('images/bubbles/$uid/profile.${file.extension}');
      UploadTask task = ref.putFile(
        File(file.path!),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  Future<String?> saveSentExplorerImageToStorage(
      String userID, PlatformFile file) async {
    try {
      Reference ref = _storage.ref().child(
          'images/explorer/${userID}_${Timestamp.now().millisecondsSinceEpoch}.${file.extension}');
      UploadTask task = ref.putFile(
        File(file.path!),
      );
      return await task.then(
        (result) => result.ref.getDownloadURL(),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}

// Create Unique id for chat
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:renting_app_mobile/models/item_detail_model.dart';
import '/utils/custom_extension.dart';

String getGroupId(List<String> ab) {
  ab.sort((a, b) => a.compareTo(b));
  return ab.reduce((value, element) => value + element);
}

// File path from asset...
// Future<List<String>> filePathFromAsset({
//   required List<dynamic> selectedAssets,
// }) async {
//   if (selectedAssets.isEmpty) return [];
//   List<String> _selectedAssets = [];
//   for (Asset asset in selectedAssets) {
//     // final filePath =
//     //     await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
//
//     File file = await getImageFileFromAssets(asset);
//
//     _selectedAssets.add(file.path);
//   }
//
//   // Compress images...
//   for (int i = 0; i < _selectedAssets.length; i++) {
//     _selectedAssets[i] = await compressImage(_selectedAssets[i]);
//   }
//
//   return _selectedAssets;
// }

// Future<File> getImageFileFromAssets(Asset asset) async {
//   final byteData = await asset.getByteData();
//
//   final tempFile =
//       File("${(await getTemporaryDirectory()).path}/${asset.name}");
//   final file = await tempFile.writeAsBytes(
//     byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
//   );
//
//   return file;
// }

// Pick - upload and fetch download url of Document
Future<List<String>> pickAndUploadImageAsMessage(
    List<String> documentList) async {
  if (documentList.isEmpty) return [];

  List<String> downlaodedUrls = [];

  for (String document in documentList) {
    String fileName = document.split("/").last;

    final Reference firebaseStorage =
        FirebaseStorage.instance.ref().child(fileName);

    // final StorageReference storageRef =
    //     FirebaseStorage.instance.ref().child(fileName);

    final UploadTask uploadTask = firebaseStorage.putFile(
      File(document), // File path
    );

    await uploadTask
        .then((p0) async => downlaodedUrls.add(await p0.ref.getDownloadURL()));
  }

  return downlaodedUrls;
}

// Compress image...
Future<String> compressImage(String img) async {
  if ((img.isEmpty)) return "";
  if (!img.isImage) return img;

  final Directory tempDir = await getTemporaryDirectory();

  String targetPath = tempDir.path + "/" + DateTime.now().toString() + ".jpeg";
  File? compressedFile = await FlutterImageCompress.compressAndGetFile(
    img,
    targetPath,
    quality: 85,
  );

  return compressedFile?.path ?? "";
}

// Calculate number of days between two days
int daysBetween({required DateTime from, required DateTime to}) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

double hoursBetweenItem({required DateTime from, required DateTime to}) {
  
  // from = DateTime(from.year, from.month, from.day, to.hour, to.minute);
  // to = DateTime(to.year, to.month, to.day, to.hour, to.minute);
  return to.difference(from).inMinutes / 60;
}

// int hoursBetween({required TimeOfDay from, required TimeOfDay to}) {
int hoursBetween({ItemDetailModel? itemDetailModel}) {
  if (itemDetailModel == null) return 0;

  TimeOfDay from = TimeOfDay(
    hour: hourFromTime(itemDetailModel.serviceStartTime),
    minute: minuteFromTime(itemDetailModel.serviceStartTime),
  );
  TimeOfDay to = TimeOfDay(
    hour: hourFromTime(itemDetailModel.serviceEndTime),
    minute: minuteFromTime(itemDetailModel.serviceEndTime),
  );

  return (((to.hour * 60) + to.minute) - ((from.hour * 60) + from.minute))
      .round();
}

int hourFromTime(String timeOfDay) {
  return timeOfDay.isEmpty ? 0 : int.parse(timeOfDay.split(":")[0]);
}

int minuteFromTime(String timeOfDay) {
  return timeOfDay.isEmpty
      ? 0
      : int.parse(timeOfDay.split(":")[1].split(":").first);
}

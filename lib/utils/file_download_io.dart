import 'dart:io';

Future<void> downloadFileToDevice(String fileName, String content) async {
  final file = File(fileName);
  await file.writeAsString(content);
}

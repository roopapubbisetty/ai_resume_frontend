import 'file_download_stub.dart'
    if (dart.library.html) 'file_download_web.dart'
    if (dart.library.io) 'file_download_io.dart';

class FileDownloadUtils {
  FileDownloadUtils._();

  static Future<void> downloadReport({
    required String fileName,
    required String content,
  }) async {
    await downloadFileToDevice(fileName, content);
  }
}

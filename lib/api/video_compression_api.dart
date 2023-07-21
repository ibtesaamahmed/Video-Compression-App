import 'dart:io';

import 'package:video_compress/video_compress.dart';

/* a class to manage the compression process using asynchronous
function to wait for the compression process to finish and showing 
the linear progress indicator while waiting */

class VideoCompressionApi {
  static Future<MediaInfo?> compressVideo(File file) async {
    try {
      // await VideoCompress.setLogLevel(0);
      final res = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.LowQuality,
        includeAudio: true,
      );
      return res;
    } catch (error) {
      VideoCompress.cancelCompression();
    }
    return null;
  }
}

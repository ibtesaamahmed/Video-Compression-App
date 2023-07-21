import 'package:flutter/material.dart';
import 'package:video_compression_app/video_compression.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData().copyWith(useMaterial3: true),
    home: const VideoCompression(), // main entry point
  ));
}

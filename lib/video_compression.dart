import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_compression_app/widgets/logo_widget.dart';
import 'package:video_compression_app/widgets/progress_dialog_widget.dart';
import 'package:video_compression_app/api/video_compression_api.dart';
import 'package:video_compression_app/widgets/video_player_widget.dart';

class VideoCompression extends StatefulWidget {
  const VideoCompression({super.key});

  @override
  State<VideoCompression> createState() => _VideoCompressionState();
}

class _VideoCompressionState extends State<VideoCompression> {
  //defining helper variables
  File? fileVideo;
  Uint8List? thumnnailBytes;
  int? videoSize;
  MediaInfo? compressedVideoInfo;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amberAccent,
        body:
            /* if currently no video file is selected then show
         options to pick video */
            fileVideo == null
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const LogoWidget(), // custom logo widget
                          const Spacer(),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black),
                            onPressed: _openGallery,
                            icon: const Icon(Icons.browse_gallery),
                            label: const Text('Pick video from Gallery'),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black),
                            onPressed: _openCamera,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Pick video from Camera'),
                          ),
                          const SizedBox(height: 100)
                        ]),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 20),
                      _buildThumbnail(), // custom function to build thumbnail
                      const SizedBox(height: 20),
                      _buildVideoInfo(), // custom function to get video size info
                    ],
                  ),
      ),
    );
  }

  _openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    } else {
      final file = File(pickedFile.path);
      setState(() => fileVideo = file);
      _generateThumbnail(fileVideo!);
      _getVideoSize(fileVideo!);
    }
  }

  _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);
    if (pickedFile == null) {
      return;
    } else {
      final file = File(pickedFile.path);
      setState(() => fileVideo = file);
      _generateThumbnail(fileVideo!);
      _getVideoSize(fileVideo!);
    }
  }

  _generateThumbnail(File file) async {
    // generating thumbnail bytes using VideoCompress package
    final thumbnailB = await VideoCompress.getByteThumbnail(file.path);
    setState(() => thumnnailBytes = thumbnailB);
  }

  _getVideoSize(File file) async {
    // retrieving original video size using built-in length method
    final size = await file.length();
    setState(() => videoSize = size);
  }

  Widget _buildThumbnail() {
    // building thumbnail using Image.memory widget
    return thumnnailBytes == null
        ? const Center(
            child: Text('Error Loading Thumbnail'),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: Image.memory(
              thumnnailBytes!,
              height: 200,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          );
  }

  Widget _buildVideoInfo() {
    if (videoSize == null) {
      return Container();
    }
    final size = (videoSize! / 1000000)
        .toStringAsFixed(2); // converting size into megabytes
    return Column(
      children: [
        const Text(
          'Original Video Info',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(
          'Size: $size MB',
          style: TextStyle(color: Colors.grey[800]),
        ),
        buildCompressedVideoInfo(), // compressed video info custom widget
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, foregroundColor: Colors.black),
              onPressed: _pickAnotherVideo,
              icon: const Icon(Icons.video_collection),
              label: const Text('Pick another video')),
        ),
        compressedVideoInfo == null
            ? Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black),
                    onPressed: _compressVideo,
                    icon: const Icon(Icons.compress),
                    label: const Text('Compress the video')),
              )
            : Container()
      ],
    );
  }

  // clear all helper variables when new video is to be choosen
  _pickAnotherVideo() {
    setState(() {
      fileVideo = null;
      thumnnailBytes = null;
      videoSize = null;
      compressedVideoInfo = null;
    });
  }

  // video compression using custom VideoCompressionApi
  _compressVideo() async {
    showDialog(
        context: context,
        builder: (context) => const Dialog(child: ProgressDialogWidget()));
    final info = await VideoCompressionApi.compressVideo(fileVideo!);
    setState(() => compressedVideoInfo = info);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  // custom widget to build compressed video info
  Widget buildCompressedVideoInfo() {
    if (compressedVideoInfo == null) {
      return Container();
    } else {
      final size =
          (compressedVideoInfo!.filesize! / 1000000).toStringAsFixed(2);
      return Column(
        children: <Widget>[
          const SizedBox(height: 20),
          VideoPlayerWidget(videoPath: File(compressedVideoInfo!.path!)),
          const SizedBox(height: 20),
          const Text(
            'Compressed Video Info',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 6),
          Text('Size: $size MB', style: TextStyle(color: Colors.grey[800])),
        ],
      );
    }
  }
}

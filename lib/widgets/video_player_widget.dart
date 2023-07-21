import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final File videoPath;

  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoPath);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      looping: false,
      autoInitialize: true,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* using chewie and video_player package to show compressed video on screen
       and let the user play/pause, forward, change playback speed of video */
    return SizedBox(
      width: 320,
      height: 220,
      child: Chewie(controller: _chewieController),
    );
  }
}

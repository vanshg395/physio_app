import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen(this.title, this.vidUrl);

  final String title;
  final String vidUrl;

  @override
  State<StatefulWidget> createState() {
    return _VideoScreenState();
  }
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    print(widget.title);
    print(widget.vidUrl);
    _videoPlayerController1 = VideoPlayerController.network(widget.vidUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: _videoPlayerController1.value.aspectRatio,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Example',
      home: VideoPlayerScreen(),
    );
  }
}
      String vidUrl = "https://www.youtube.com/watch?v=R3pCi5QKiik"; 

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  VideoPlayerController _videoController=VideoPlayerController.networkUrl(Uri.parse(vidUrl));
  YoutubePlayerController _youtubeController=YoutubePlayerController(initialVideoId: "") ;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void initializePlayer() {

    if (vidUrl.contains('youtube.com')) {
      String youtubeVideoId = vidUrl.split('v=')[1];
      _youtubeController = YoutubePlayerController(
        initialVideoId: youtubeVideoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    } else {
      // Local video URL
      _videoController = VideoPlayerController.network(vidUrl)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_youtubeController != null)
              YoutubePlayer(
                controller: _youtubeController,
                showVideoProgressIndicator: true,
              ),
            if (_videoController != null)
              _videoController.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

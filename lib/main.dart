import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      String vidUrl = 
      "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4";
      // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"; 
      // "https://www.youtube.com/watch?v=a6LOsdqU5fo";

class VideoPlayerScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  VideoPlayerController _videoController=VideoPlayerController.networkUrl(Uri.parse(vidUrl),videoPlayerOptions: VideoPlayerOptions());
    late BetterPlayerController _betterPlayerController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  YoutubePlayerController _youtubeController=YoutubePlayerController(initialVideoId: "") ;
  bool isYoutube=false;

  @override
  void initState() {
     BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      autoPlay: true,
      looping: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp
      ],
    );
      _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      vidUrl,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(_betterPlayerDataSource);
    super.initState();
    initializePlayer();
  }

  void initializePlayer() {

    if (vidUrl.contains('youtube.com')) {
      setState(() {
        isYoutube=true;
      });
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
      _videoController = VideoPlayerController.contentUri(Uri.parse(vidUrl))
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
            isYoutube?
              YoutubePlayer(
                controller: _youtubeController,
                showVideoProgressIndicator: true,
              )
           :
              _betterPlayerController.isBuffering()
                  ?   AspectRatio(
            aspectRatio: 16 / 9,
            child: BetterPlayer(controller: _betterPlayerController),
          )
                  : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

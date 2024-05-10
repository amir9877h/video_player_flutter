import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final VideoPlayerController _controller =
      VideoPlayerController.asset('assets/file.mp4')
        ..initialize()
        ..setLooping(true)
        ..play();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: VideoPlayer(_controller)),
          Positioned.fill(
              child: Container(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.person_pin_rounded),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'id',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Video title',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'Video subtitle',
                      style: TextStyle(color: Colors.white),
                    ),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors:
                          const VideoProgressColors(playedColor: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'time',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'time',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            iconSize: 56,
                            icon: const Icon(
                              CupertinoIcons.backward_end_alt,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {
                              // setState(() {
                              //   _controller.value.ser = !_controller.value.isPlaying;
                              // });
                            },
                            iconSize: 56,
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? CupertinoIcons.pause_circle
                                  : CupertinoIcons.play_circle,
                              color: Colors.white,
                            )),
                        IconButton(
                            onPressed: () {},
                            iconSize: 56,
                            icon: const Icon(
                              CupertinoIcons.forward_end_alt,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

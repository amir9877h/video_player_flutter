import 'dart:async';

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

  Timer? timer;

  bool showControlPanel = false;

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showControlPanel = !showControlPanel;
                      initControlPanelTimer();
                    });
                  },
                  child: VideoPlayer(_controller))),
          if (showControlPanel)
            VideoControlPanel(
              controller: _controller,
              callback: () {
                setState(() {
                  showControlPanel = false;
                  timer?.cancel();
                });
              },
            ),
        ],
      ),
    );
  }

  void initControlPanelTimer() {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        showControlPanel = false;
      });
    });
  }
}

class VideoControlPanel extends StatefulWidget {
  const VideoControlPanel({
    super.key,
    required VideoPlayerController controller,
    required this.callback,
  }) : _controller = controller;

  final VideoPlayerController _controller;

  final GestureTapCallback callback;

  @override
  State<VideoControlPanel> createState() => _VideoControlPanelState();
}

class _VideoControlPanelState extends State<VideoControlPanel> {
  Timer? timer;

  void initTimer() {
    if (timer != null && timer!.isActive) return;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    initTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: GestureDetector(
      onTap: widget.callback,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_pin_rounded,
                      size: 32,
                    )),
                const Column(
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
                  widget._controller,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(playedColor: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget._controller.value.position.toHHMMSS(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      widget._controller.value.duration.toHHMMSS(),
                      style: const TextStyle(color: Colors.white),
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
                          if (widget._controller.value.isPlaying) {
                            widget._controller.pause();
                          } else {
                            widget._controller.play();
                          }
                        },
                        iconSize: 56,
                        icon: Icon(
                          widget._controller.value.isPlaying
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
      ),
    ));
  }
}

extension DurationExtensions on Duration {
  String toHHMMSS() {
    final h = inHours.toString().padLeft(2, '0');
    final m = inMinutes.toString().padLeft(2, '0');
    final s = inSeconds.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

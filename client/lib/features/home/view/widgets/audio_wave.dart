import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musync/core/theme/app_pallete.dart';

class AudioWave extends StatefulWidget {
  final String audioPath;
  const AudioWave({super.key, required this.audioPath});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave> {
  final PlayerController playerController = PlayerController();

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.audioPath);
  }

  Future<void> playAndPause() async {
    if (playerController.playerState.isPlaying) {
      await playerController.pausePlayer();
    } else {
      await playerController.startPlayer();
    }
    setState(() {});
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              playAndPause();
            },
            icon: Icon(playerController.playerState.isPlaying
                ? CupertinoIcons.pause_solid
                : CupertinoIcons.play_arrow_solid)),
        Expanded(
          child: AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width, 80),
              playerWaveStyle: const PlayerWaveStyle(
                  fixedWaveColor: Pallete.borderColor,
                  liveWaveColor: Pallete.gradient2,
                  spacing: 6,
                  showSeekLine: true),
              playerController: playerController),
        ),
      ],
    );
  }
}

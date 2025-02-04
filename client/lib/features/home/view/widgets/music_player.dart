import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musync/core/providers/current_music_notifier.dart';
import 'package:musync/core/theme/app_pallete.dart';
import 'package:musync/core/utils.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Replace with your provider
    final currentMusic = ref.watch(currentMusicNotifierProvider);
    final musicNotifier = ref.read(currentMusicNotifierProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor(currentMusic!.hex_code), Pallete.backgroundColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Pallete.transparentColor,
        appBar: AppBar(
          backgroundColor: Pallete.transparentColor,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SizedBox(
              child: Transform.translate(
                offset: Offset(10, -2),
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: Pallete.whiteColor,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(24),
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: Hero(
                    tag: 'music_thumb',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: currentMusic.thumbnail_url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/placeholder.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              currentMusic.music_name,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.whiteColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(height: 1),
                          SizedBox(
                            width: 200,
                            child: Text(
                              currentMusic.artist_name,
                              style: TextStyle(
                                color: Pallete.subtitleText,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(CupertinoIcons.heart),
                        color: Pallete.whiteColor,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: StreamBuilder(
                      stream: musicNotifier.audioPlayer!.positionStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox();
                        }
                        final position = snapshot.data;
                        final duration = musicNotifier.audioPlayer!.duration;
                        double sliderValue = 0.0;
                        if (position != null && duration != null) {
                          sliderValue =
                              position.inMilliseconds / duration.inMilliseconds;
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            StatefulBuilder(
                              builder: (context, setState) {
                                return SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Pallete.whiteColor,
                                      inactiveTrackColor:
                                          // ignore: deprecated_member_use
                                          Pallete.whiteColor.withOpacity(0.117),
                                      thumbColor: Pallete.whiteColor,
                                      trackHeight: 4,
                                      overlayShape:
                                          SliderComponentShape.noOverlay),
                                  child: Slider(
                                    value: sliderValue,
                                    min: 0,
                                    max: 1,
                                    onChanged: (val) {
                                      setState(() {
                                        sliderValue = val;
                                      });
                                    },
                                    onChangeEnd: (val) {
                                      musicNotifier.seek(val);
                                    },
                                  ),
                                );
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 2),
                                  child: Text(
                                    '${position?.inMinutes}:${(position?.inSeconds ?? 0) < 10 ? '0${position?.inSeconds}' : position?.inSeconds}',
                                    style: TextStyle(
                                      color: Pallete.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10, top: 2),
                                  child: Text(
                                    '${duration?.inMinutes}:${(duration?.inSeconds ?? 0) < 10 ? '0${duration?.inSeconds}' : duration?.inSeconds}',
                                    style: TextStyle(
                                      color: Pallete.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.shuffle,
                            color: Pallete.greyColor,
                          )),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.skip_previous_sharp,
                          size: 55,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          musicNotifier.playPause();
                        },
                        icon: Icon(
                          musicNotifier.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          size: 85,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.skip_next_sharp,
                          size: 55,
                          color: Pallete.whiteColor,
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.repeat,
                            color: Pallete.greyColor,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.devices,
                            color: Pallete.greyColor,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.format_list_bulleted_add,
                            color: Pallete.greyColor,
                          )),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

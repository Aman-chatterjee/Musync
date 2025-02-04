import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musync/core/providers/current_music_notifier.dart';
import 'package:musync/core/theme/app_pallete.dart';
import 'package:musync/core/utils.dart';
import 'package:musync/features/home/view/widgets/music_player.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMusic = ref.watch(currentMusicNotifierProvider);
    final musicNotifier = ref.read(currentMusicNotifierProvider.notifier);

    if (currentMusic == null) {
      return const SizedBox();
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 250),
            pageBuilder: (context, anim, secondaryAnim) => MusicPlayer(),
            transitionsBuilder: (context, anim, secondaryAnim, child) {
              // Slide animation
              final slideTween =
                  Tween(begin: const Offset(0, 1), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeInOut));
              final offsetAnimation = anim.drive(slideTween);

              // Fade animation
              final fadeTween = Tween(begin: 0.0, end: 1.0);
              final fadeAnimation = anim.drive(fadeTween);

              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: child,
                ),
              );
            }));
      },
      child: Stack(
        children: [
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width - 15,
            decoration: BoxDecoration(
                color: hexToColor(currentMusic.hex_code),
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'music_thumb',
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            width: 48,
                            height: 48,
                            imageUrl: currentMusic.thumbnail_url,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Image.asset(
                              'assets/images/placeholder.jpg',
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    SizedBox(width: 15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Text(
                            currentMusic.music_name,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Pallete.whiteColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            currentMusic.artist_name,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Pallete.whiteColor),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          CupertinoIcons.heart,
                          color: Pallete.whiteColor,
                        )),
                    IconButton(
                        onPressed: () {
                          musicNotifier.playPause();
                        },
                        icon: Icon(
                            musicNotifier.isPlaying
                                ? CupertinoIcons.pause_solid
                                : CupertinoIcons.play_arrow_solid,
                            color: Pallete.whiteColor)),
                  ],
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: musicNotifier.audioPlayer?.positionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                }
                final position = snapshot.data;
                final duration = musicNotifier.audioPlayer!.duration;
                double sliderValue = 0.0;
                if (position != null && duration != null) {
                  sliderValue =
                      position.inMilliseconds / duration.inMilliseconds;
                }
                return Positioned(
                  bottom: 0,
                  child: Container(
                    height: 2,
                    width:
                        sliderValue * (MediaQuery.of(context).size.width - 15),
                    decoration: BoxDecoration(
                      color: Pallete.whiteColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                );
              }),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 25,
              decoration: BoxDecoration(
                color: Pallete.inactiveSeekColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          )
        ],
      ),
    );
  }
}

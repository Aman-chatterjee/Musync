import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musync/core/providers/current_music_notifier.dart';
import 'package:musync/core/theme/app_pallete.dart';
import 'package:musync/core/utils.dart';
import 'package:musync/core/widgets/loader.dart';
import 'package:musync/features/home/view/viewmodel/home_viewmodel.dart';

class MusicPage extends ConsumerWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayedMusic =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedMusic();
    final currentMusic = ref.watch(currentMusicNotifierProvider);

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      decoration: currentMusic == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  hexToColor(currentMusic.hex_code),
                  Pallete.transparentColor,
                ],
                stops: const [0.0, 0.3],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            recentlyPlayedMusic.isEmpty
                ? Column()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recently Played',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        constraints: BoxConstraints(maxHeight: 275),
                        child: GridView.builder(
                          padding:
                              EdgeInsets.symmetric(vertical: 30, horizontal: 0),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: recentlyPlayedMusic.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => ref
                                  .read(currentMusicNotifierProvider.notifier)
                                  .updateMusic(recentlyPlayedMusic[index]),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Pallete.cardColor),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            bottomLeft: Radius.circular(4)),
                                        child: CachedNetworkImage(
                                          height: double.infinity,
                                          imageUrl: recentlyPlayedMusic[index]
                                              .thumbnail_url,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                            'assets/images/placeholder.jpg',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                        flex: 6,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              recentlyPlayedMusic[index]
                                                  .music_name,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Pallete.whiteColor),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              recentlyPlayedMusic[index]
                                                  .artist_name,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Pallete.subtitleText),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
            Text(
              'Lastest Today',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            ref.watch(getAllMusicProvider).when(
                data: (music) {
                  return SizedBox(
                    height: 260,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: music.length,
                      itemBuilder: (contex, index) {
                        return InkWell(
                          onTap: () {
                            ref
                                .read(currentMusicNotifierProvider.notifier)
                                .updateMusic(music[index]);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                    width: 180,
                                    height: 180,
                                    imageUrl: music[index].thumbnail_url,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                          'assets/images/placeholder.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error)),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                width: 180,
                                child: Text(
                                  music[index].music_name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Pallete.whiteColor),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: 1),
                              SizedBox(
                                width: 180,
                                child: Text(
                                  music[index].artist_name,
                                  style: TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (contex, index) => SizedBox(width: 10),
                    ),
                  );
                },
                error: (error, st) {
                  return Center(child: Text(error.toString()));
                },
                loading: () => Loader()),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musync/core/providers/current_music_notifier.dart';
import 'package:musync/core/theme/app_pallete.dart';
import 'package:musync/core/widgets/loader.dart';
import 'package:musync/features/home/view/pages/upload_music_page.dart';
import 'package:musync/features/home/view/viewmodel/home_viewmodel.dart';

class LilbraryPage extends ConsumerWidget {
  const LilbraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UploadMusicPage(),
              )),
              icon: Icon(Icons.upload),
              iconSize: 30,
            ),
          ),
        ],
      ),
      body: ref.watch(getFavMusicProvider).when(
            data: (data) {
              return Container(
                margin: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      final music = data[index];
                      return Ink(
                        decoration: BoxDecoration(
                          color: Pallete.cardColor,
                        ),
                        child: InkWell(
                          onTap: () => ref
                              .read(currentMusicNotifierProvider.notifier)
                              .updateMusic(music),
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
                                      imageUrl: music.thumbnail_url,
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
                                          music.music_name,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Pallete.whiteColor),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          music.artist_name,
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
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 5);
                    },
                    itemCount: data.length),
              );
            },
            error: (error, st) {
              return Center(child: Text(error.toString()));
            },
            loading: () => const Loader(),
          ),
    );
  }
}

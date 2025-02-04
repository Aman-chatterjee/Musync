import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musync/core/theme/app_pallete.dart';
import 'package:musync/features/home/view/pages/lilbrary_page.dart';
import 'package:musync/features/home/view/pages/music_page.dart';
import 'package:musync/features/home/view/widgets/music_slab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIndex = 0;
  final pages = const [
    MusicPage(),
    LilbraryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    //final current_user = ref.watch(currentUserNotifierProvider);
    return Scaffold(
        body: Stack(children: [
          pages[selectedIndex],
          Positioned(
            bottom: 0,
            child: MusicSlab(),
          )
        ]),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedIconTheme: IconThemeData(color: Pallete.whiteColor),
          unselectedIconTheme:
              IconThemeData(color: Pallete.inactiveBottomBarItemColor),
          items: [
            BottomNavigationBarItem(
              icon: selectedIndex == 0
                  ? Icon(Icons.home_rounded)
                  : Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: selectedIndex == 1
                  ? Icon(Icons.library_music_rounded)
                  : Icon(Icons.library_music_outlined),
              label: 'Library',
            ),
          ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ));
  }
}

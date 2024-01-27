import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research/common/loader.dart';
import 'package:research/features/auth/auth_controller.dart';
import 'package:research/features/home/pages/add_post_page.dart';
import 'package:research/theme/pallete.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _page = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(authControllerProvider.notifier).getData(context: context);
    });
  }

  void navigatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Pallete.primaryColor.withOpacity(0.5),
      body: isLoading
          ? const Loader()
          : IndexedStack(
              index: _page,
              children: const [
                Text('Home'),
                Text('Top Researches'),
                AddPostPage(),
                Text('Profile'),
              ],
            ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            selectedFontSize: 0.0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Pallete.secondaryColor,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            currentIndex: _page,
            onTap: navigatePage,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                  size: 30.0,
                ),
                label: '',
                // backgroundColor: primaryColor,
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.trending_up_rounded,
                  size: 30.0,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextButton(
                      onPressed: () {
                        navigatePage(2);
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Pallete.logoGreen,
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 35.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  size: 30.0,
                ),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

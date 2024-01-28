import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:research/common/loader.dart';
import 'package:research/features/auth/auth_controller.dart';
import 'package:research/features/home/home_controller.dart';
import 'package:research/features/home/post_card.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  final String uid;
  const UserProfilePage({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    final researches = ref.watch(getUserResearches(widget.uid)).value;
    if (researches == null) {
      return const Loader();
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: ref.watch(getUserDataByIdProvider(widget.uid)).when(
              data: (user) {
                return Column(
                  children: [
                    Text(
                      user.fullName,
                      style: const TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '\$${user.funding.toString()}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: const Text(
                                'Funding Raised',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              researches.length < 10
                                  ? '0${researches.length.toString()}'
                                  : researches.length.toString(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              child: const Text(
                                'Researches Published',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (researches.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListView.separated(
                            itemCount: researches.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 10);
                            },
                            itemBuilder: (context, index) {
                              final post = researches[index];

                              return PostCard(researchModel: post);
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
              error: (error, st) {
                return Center(
                  child: Text(error.toString()),
                );
              },
              loading: () => const Loader(),
            ),
      ),
    );
  }
}

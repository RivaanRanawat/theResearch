import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research/common/loader.dart';
import 'package:research/features/home/home_controller.dart';
import 'package:research/features/home/post_card.dart';

class PostsList extends ConsumerWidget {
  const PostsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPDFsProvider).when(
          data: (posts) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  final post = posts[index];

                  return PostCard(researchModel: post);
                },
              ),
            );
          },
          error: (error, st) {
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          },
          loading: () => const Loader(),
        );
  }
}

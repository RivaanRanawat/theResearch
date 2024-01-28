import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research/features/home/home_repository.dart';
import 'package:research/models/discussion_model.dart';
import 'package:research/providers.dart';
import 'package:research/utils.dart';
import 'package:uuid/uuid.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(ref.watch(homeRepositoryProvider), ref);
});

final getPDFsProvider = StreamProvider((ref) {
  return ref.watch(homeRepositoryProvider).getPDFs();
});

final getDiscussionsProvider = StreamProvider.family((ref, String researchId) {
  return ref.watch(homeRepositoryProvider).getDiscussions(researchId);
});

final getDiscussionsByReplyProvider =
    StreamProvider.family((ref, (String, String) discussion) {
  return ref
      .watch(homeRepositoryProvider)
      .getDiscussionsByReplyId(discussion.$1, discussion.$2);
});

final getTopPDFsProvider = StreamProvider.family((ref, String orderBy) {
  return ref.watch(homeRepositoryProvider).getTopPDFs(orderBy);
});

class HomeController extends StateNotifier<bool> {
  final Ref ref;
  final HomeRepository homeRepository;
  HomeController(this.homeRepository, this.ref) : super(false);

  void sharePDF(
    String title,
    File file,
    BuildContext context,
  ) async {
    title = title.trim();

    if (title.isEmpty) {
      return showSnackBar(context, 'Title field missing!');
    }

    state = true;
    final res = await homeRepository.sharePDF(
      title,
      file,
      ref.read(currentUserModelProvider)!.uid,
    );
    state = false;

    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Research Uploaded!');
      // TODO: Go back to the home page!
    });
  }

  void comment(
    String comment,
    String researchId,
    bool isReplied,
    String repliedTo,
    BuildContext context,
  ) async {
    final discussionModel = DiscussionModel(
      text: comment,
      datePublished: DateTime.now(),
      uid: ref.read(currentUserModelProvider)!.uid,
      researchId: researchId,
      isRepliedTo: isReplied,
      discussionId: const Uuid().v1(),
      repliedTo: repliedTo,
    );
    final res = await homeRepository.comment(discussionModel);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }
}

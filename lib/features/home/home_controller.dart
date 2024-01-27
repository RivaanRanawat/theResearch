import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research/features/home/home_repository.dart';
import 'package:research/providers.dart';
import 'package:research/utils.dart';

final homeControllerProvider =
    StateNotifierProvider<HomeController, bool>((ref) {
  return HomeController(ref.watch(homeRepositoryProvider), ref);
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
}

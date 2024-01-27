import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:research/common/error_failure.dart';
import 'package:research/models/research_model.dart';
import 'package:research/providers.dart';
import 'package:research/type_defs.dart';
import 'package:uuid/uuid.dart';

final homeRepositoryProvider = Provider(
  (ref) => HomeRepository(
    firebaseFirestore: ref.watch(firestoreProvider),
  ),
);

class HomeRepository {
  final FirebaseFirestore firebaseFirestore;

  HomeRepository({required this.firebaseFirestore});

  FutureEither<ResearchModel> sharePDF(
    String title,
    File file,
    String uid,
  ) async {
    try {
      final storage = FirebaseStorage.instance.ref('researches').child(title);
      final task = await storage.putFile(
        file,
        SettableMetadata(
          contentType: 'pdf',
        ),
      );
      final pdfUrl = await task.ref.getDownloadURL();
      final id = const Uuid().v1();
      // TODO: Add summary

      final research = ResearchModel(
        title: title,
        pdfUrl: pdfUrl,
        fundingRaised: 0,
        commentCount: 0,
        datePublished: DateTime.now(),
        uid: uid,
        summary: "",
        id: id,
      );
      await firebaseFirestore
          .collection('researches')
          .doc(id)
          .set(research.toMap());

      return right(research);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:research/common/error_failure.dart';
import 'package:research/models/research_model.dart';
import 'package:research/providers.dart';
import 'package:research/secrets.dart';
import 'package:research/type_defs.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

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
      // extract data from text

      PdfDocument document = PdfDocument(
        inputBytes: await file.readAsBytes(),
      );

      PdfTextExtractor extractor = PdfTextExtractor(document);

      String summary = extractor.extractText();

      // gemini api call
      final res = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$geminiAPIKey',
        ),
        body: jsonEncode({
          'contents': [
            {
              "parts": [
                {
                  "text":
                      "Summarise the unstructured text I give to you in the next message in 150 words",
                },
                {
                  "text": summary,
                },
              ]
            }
          ],
        }),
      );
      print(res.body);
      final geminiSummarised =
          jsonDecode(res.body)['candidates'][0]['content']['parts'][0]['text'];

      final research = ResearchModel(
        title: title,
        pdfUrl: pdfUrl,
        fundingRaised: 0,
        commentCount: 0,
        datePublished: DateTime.now(),
        uid: uid,
        summary: geminiSummarised,
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

  Stream<List<ResearchModel>> getPDFs() {
    return firebaseFirestore.collection('researches').snapshots().map(
          (event) => event.docs
              .map(
                (e) => ResearchModel.fromMap(e.data()),
              )
              .toList(),
        );
  }
}

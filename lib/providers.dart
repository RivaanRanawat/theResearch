import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:research/models/user_model.dart';

final firestoreProvider = Provider(
  (ref) => FirebaseFirestore.instance,
);

final firebaseAuthProvider = Provider(
  (ref) => FirebaseAuth.instance,
);

final firebaseStorageProvider = Provider(
  (ref) => FirebaseStorage.instance,
);

final googleSignInProvider = Provider(
  (ref) => GoogleSignIn(),
);

final currentUserModelProvider = StateProvider<UserModel?>((ref) => null);

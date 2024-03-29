import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:research/common/error_failure.dart';
import 'package:research/models/user_model.dart';
import 'package:research/providers.dart';
import 'package:research/type_defs.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firestoreProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final GoogleSignIn googleSignIn;
  const AuthRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.googleSignIn,
  });

  FutureEither<Map<String, dynamic>> getData(String uid) async {
    try {
      final documentSnapshot =
          await firebaseFirestore.collection('users').doc(uid).get();
      if (documentSnapshot.data() != null) {
        return right(documentSnapshot.data()!);
      }
      throw left(const Failure());
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<UserModel> getUserDataById(String uid) {
    return firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  FutureEither<UserModel> signUpUser({
    required UserModel userModel,
  }) async {
    try {
      final user = await firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password ?? '',
      );
      if (user.user != null) {
        userModel = userModel.copyWith(
          uid: user.user?.uid,
        );
        await firebaseFirestore.collection('users').doc(user.user!.uid).set(
              userModel.toMap(),
            );
      }
      return right(userModel);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserModel? userModel;
      final user = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user.user != null) {
        final userData = await firebaseFirestore
            .collection('users')
            .doc(user.user!.uid)
            .get();

        userModel = UserModel.fromMap(userData.data()!);
      }
      if (userModel != null) {
        return right(userModel);
      }
      return left(const Failure());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return left(const Failure(message: 'Invalid Login Credentials!'));
      }
      return left(Failure(message: e.message!));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<UserModel> updateUserData(UserModel userModel) async {
    try {
      await firebaseFirestore.collection('users').doc(userModel.uid).update(
            userModel.toMap(),
          );

      return right(userModel);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureVoid updateFundingUsers(
    UserModel currentUser,
    String currentUserId,
    String otherUserId,
    int amountFunded,
    String researchId,
  ) async {
    try {
      await firebaseFirestore.collection('researches').doc(researchId).update({
        'fundingRaised': FieldValue.increment(amountFunded),
      });

      await firebaseFirestore.collection('users').doc(currentUserId).update({
        'funding': FieldValue.increment(-amountFunded),
      });

      await firebaseFirestore.collection('users').doc(otherUserId).update({
        'funding': FieldValue.increment(amountFunded),
      });

      currentUser = currentUser.copyWith(
        funding: currentUser.funding - amountFunded,
      );

      return right(null);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      userCredential = await firebaseAuth.signInWithCredential(credential);

      late UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          fullName: userCredential.user!.displayName ?? 'No Name',
        );

        await firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
      } else {
        final res = await getData(userCredential.user!.uid);
        res.fold(
          (l) => throw l.message,
          (r) => userModel = UserModel.fromMap(r),
        );
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}

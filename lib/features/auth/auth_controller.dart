import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:research/features/auth/auth_repository.dart';
import 'package:research/models/user_model.dart';
import 'package:research/providers.dart';
import 'package:research/utils.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(ref.watch(authRepositoryProvider), ref),
);
final authStateChangesProvider =
    StreamProvider((ref) => ref.watch(firebaseAuthProvider).authStateChanges());

class AuthController extends StateNotifier<bool> {
  final AuthRepository authRepository;
  final Ref ref;
  AuthController(
    this.authRepository,
    this.ref,
  ) : super(false);

  Future<void> signUpUser({
    required String email,
    required String password,
    required String fullName,
    required BuildContext context,
  }) async {
    state = true;
    email = email.trim();
    password = password.trim();
    fullName = fullName.trim();
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      state = false;
      return showSnackBar(context, 'Missing fields!');
    }

    final userModel = UserModel(
      uid: '',
      email: email,
      fullName: fullName,
      password: password,
    );
    final res = await authRepository.signUpUser(userModel: userModel);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      ref.read(currentUserModelProvider.notifier).update((state) => r);
      showSnackBar(context, 'Account created!');
      GoRouter.of(context).go('/');
    });
  }

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    if (email.isEmpty || password.isEmpty) {
      state = false;
      return showSnackBar(context, 'Missing fields!');
    }

    final res = await authRepository.loginUser(
      email: email,
      password: password,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      ref.read(currentUserModelProvider.notifier).update((state) => r);
    });
  }

  Future<void> getData({
    required BuildContext context,
  }) async {
    state = true;

    final res = await authRepository.getData(
      authRepository.firebaseAuth.currentUser!.uid,
    );
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      final user = UserModel.fromMap(r);
      ref.read(currentUserModelProvider.notifier).update((state) => user);
    });
  }

  Future<void> updateUserData(UserModel userModel) async {
    state = true;
    final res = await authRepository.updateUserData(userModel);
    state = false;
    res.fold((l) {}, (r) {
      ref.read(currentUserModelProvider.notifier).update((state) => r);
    });
  }

  void updateFundingUsers(
    String otherUserId,
    int amountFunded,
    BuildContext context,
  ) async {
    final currentUser = ref.read(currentUserModelProvider);
    final res = await authRepository.updateFundingUsers(
      currentUser!,
      currentUser.uid,
      otherUserId,
      amountFunded,
    );

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => showSnackBar(context, 'Funds transferred successfully!'),
    );
  }
}

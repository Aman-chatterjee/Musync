import 'package:fpdart/fpdart.dart' as fpdart;
import 'package:musync/core/providers/current_user_notifier.dart';
import 'package:musync/features/auth/model/user_model.dart';
import 'package:musync/features/auth/repositories/auth_local_repository.dart';
import 'package:musync/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.read(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    final val = switch (res) {
      fpdart.Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      fpdart.Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final res =
        await _authRemoteRepository.login(email: email, password: password);

    final val = switch (res) {
      fpdart.Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      fpdart.Right(value: final r) => _loginSuccess(r),
    };
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    state = AsyncValue.data(user);
    _authLocalRepository.setToken(user.token);
    _currentUserNotifier.addUser(user);
    return state;
  }

  Future<UserModel?>? getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();

    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUser(token: token);
      final val = switch (res) {
        fpdart.Left(value: final l) => state =
            AsyncValue.error(l.message, StackTrace.current),
        fpdart.Right(value: final r) => _getDataSuccess(r),
      };
      return val.value;
    }
    return null;
  }

  AsyncValue<UserModel> _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state = AsyncValue.data(user);
  }
}

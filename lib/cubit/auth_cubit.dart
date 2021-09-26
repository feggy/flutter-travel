import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_wisata/models/user_model.dart';
import 'package:travel_wisata/services/auth_service.dart';
import 'package:travel_wisata/services/user_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void signIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      UserModel user = await AuthService().signIn(
        email: email,
        password: password,
      );
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  void getCurrentUser(String id) async {
    try {
      UserModel user = await UserService().getUserById(id);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }

  void logout() async {
    try {
      emit(AuthLoading());
      await AuthService().logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }
}

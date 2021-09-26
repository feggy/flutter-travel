import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_wisata/models/user_model.dart';
import 'package:travel_wisata/services/auth_service.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  void signUp({
    required String email,
    required String name,
    required String password,
    required String role,
    required String birth,
    required String gender,
    required String phone,
    required String address,
  }) async {
    try {
      emit(RegisterLoading());

      UserModel user = await AuthService().signUp(
          email: email,
          name: name,
          password: password,
          role: role,
          birth: birth,
          gender: gender,
          phone: phone,
          address: address);

      emit(RegisterSuccess(user));
    } catch (e) {
      emit(RegisterFailed(e.toString()));
    }
  }
}

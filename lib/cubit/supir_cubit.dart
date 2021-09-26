import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_wisata/models/user_model.dart';
import 'package:travel_wisata/services/user_service.dart';

part 'supir_state.dart';

class SupirCubit extends Cubit<SupirState> {
  SupirCubit() : super(SupirInitial());

  void getListSupir() async {
    try {
      emit(SupirLoading());
      List<UserModel> listSupir = await UserService().getListUser('SUPIR');
      if (listSupir.isNotEmpty) {
        emit(SupirSuccess(listSupir));
      } else {
        emit(const SupirFailed('Data supir belum ditambahkan'));
      }
    } catch (e) {
      emit(SupirFailed(e.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_wisata/models/user_model.dart';
import 'package:travel_wisata/services/user_service.dart';

part 'pemandu_state.dart';

class PemanduCubit extends Cubit<PemanduState> {
  PemanduCubit() : super(PemanduInitial());

  void getListPemandu() async {
    try {
      emit(PemanduLoading());
      List<UserModel> listPemandu = await UserService().getListUser('PEMANDU');
      if (listPemandu.isNotEmpty) {
        emit(PemanduSucces(listPemandu));
      } else {
        emit(const PemanduFailed('Data pemandu belum ditambahkan'));
      }
    } catch (e) {
      emit(PemanduFailed(e.toString()));
    }
  }
}

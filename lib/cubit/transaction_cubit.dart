import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:travel_wisata/models/transaction_model.dart';
import 'package:travel_wisata/services/transaction_service.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());

  void reset() {
    emit(TransactionInitial());
  }

  void addTransaction({
    required TransactionModel data,
  }) async {
    try {
      emit(TransactionLoading());

      await TransactionService().addTransaction(data: data).then((value) {
        emit(TransactionSuccessAdd(value));
      }).catchError((onError) {
        emit(TransactionFailedAdd(onError));
      });
    } catch (e) {
      emit(TransactionFailed(e.toString()));
    }
  }

  void getListTransaction({required String email}) async {
    try {
      emit(TransactionLoading());

      await TransactionService().getListTransaction(email: email).then((value) {
        log(value.toString());
        if (value.isNotEmpty) {
          emit(TransactionSuccess(value));
        } else {
          emit(const TransactionFailed('Belum ada agenda sedang\nberlangsung'));
        }
      }).catchError((onError) {
        log(onError);
        emit(TransactionFailed(onError));
      });
    } catch (e) {
      log(e.toString());
      emit(TransactionFailed(e.toString()));
    }
  }
}

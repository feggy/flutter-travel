part of 'alasan_cubit.dart';

abstract class AlasanState extends Equatable {
  const AlasanState();

  @override
  List<Object> get props => [];
}

class AlasanInitial extends AlasanState {}

class LoadingGetAlasan extends AlasanState {}

class SuccessGetAlasan extends AlasanState {
  final List<AlasanModel> listAlasan;

  const SuccessGetAlasan(this.listAlasan);

  @override
  List<Object> get props => [listAlasan];
}

class FailedGetAlasan extends AlasanState {
  final String error;

  const FailedGetAlasan(this.error);

  @override
  List<Object> get props => [error];
}

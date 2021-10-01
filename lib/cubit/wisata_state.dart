part of 'wisata_cubit.dart';

abstract class WisataState extends Equatable {
  const WisataState();

  @override
  List<Object> get props => [];
}

class WisataInitial extends WisataState {}

class WisataLoading extends WisataState {}

class WisataSuccess extends WisataState {
  final List<WisataModel> data;

  const WisataSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class WisataFailed extends WisataState {
  final String error;

  const WisataFailed(this.error);

  @override
  List<Object> get props => [error];
}

class WisataLoadingAdd extends WisataState {}

class WisataSuccessAdd extends WisataState {
  final String response;

  const WisataSuccessAdd(this.response);

  @override
  List<Object> get props => [response];
}

class WisataFailedAdd extends WisataState {
  final String error;

  const WisataFailedAdd(this.error);

  @override
  List<Object> get props => [error];
}

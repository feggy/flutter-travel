part of 'jemput_cubit.dart';

abstract class JemputState extends Equatable {
  const JemputState();

  @override
  List<Object> get props => [];
}

class JemputInitial extends JemputState {}

class JemputLoading extends JemputState {}

class JemputSuccessAdd extends JemputState {
  final String response;

  const JemputSuccessAdd(this.response);

  @override
  List<Object> get props => [response];
}

class JemputFailedAdd extends JemputState {
  final String error;

  const JemputFailedAdd(this.error);

  @override
  List<Object> get props => [error];
}

class JemputSuccessGet extends JemputState {
  final JemputPenumpang data;

  const JemputSuccessGet(this.data);

  @override
  List<Object> get props => [data];
}

class JemputFailedGet extends JemputState {
  final String error;

  const JemputFailedGet(this.error);

  @override
  List<Object> get props => [error];
}

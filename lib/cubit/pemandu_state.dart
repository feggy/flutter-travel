part of 'pemandu_cubit.dart';

abstract class PemanduState extends Equatable {
  const PemanduState();

  @override
  List<Object> get props => [];
}

class PemanduInitial extends PemanduState {}

class PemanduLoading extends PemanduState {}

class PemanduSucces extends PemanduState {
  final List<UserModel> list;

  const PemanduSucces(this.list);

  @override
  List<Object> get props => [list];
}

class PemanduFailed extends PemanduState {
  final String error;

  const PemanduFailed(this.error);

  @override
  List<Object> get props => [error];
}

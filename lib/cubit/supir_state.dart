part of 'supir_cubit.dart';

abstract class SupirState extends Equatable {
  const SupirState();

  @override
  List<Object> get props => [];
}

class SupirInitial extends SupirState {}

class SupirLoading extends SupirState {}

class SupirSuccess extends SupirState {
  final List<UserModel> list;

  const SupirSuccess(this.list);

  @override
  List<Object> get props => [list];
}

class SupirFailed extends SupirState {
  final String error;

  const SupirFailed(this.error);

  @override
  List<Object> get props => [error];
}

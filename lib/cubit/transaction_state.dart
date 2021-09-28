// ignore_for_file: must_be_immutable

part of 'transaction_cubit.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccess extends TransactionState {
  List<ResTransaciton> list;

  TransactionSuccess(this.list);

  @override
  List<Object> get props => [list];
}

class TransactionFailed extends TransactionState {
  final String error;

  const TransactionFailed(this.error);

  @override
  List<Object> get props => [error];
}

class TransactionSuccessAdd extends TransactionState {
  final String response;

  const TransactionSuccessAdd(this.response);

  @override
  List<Object> get props => [response];
}

class TransactionFailedAdd extends TransactionState {
  final String response;

  const TransactionFailedAdd(this.response);

  @override
  List<Object> get props => [response];
}

class TransactionLoadingGet extends TransactionState {}

class TransactionSuccessGet extends TransactionState {
  final ResTransaciton res;

  const TransactionSuccessGet(this.res);

  @override
  List<Object> get props => [res];
}

class TransactionFailedGet extends TransactionState {
  final String error;

  const TransactionFailedGet(this.error);

  @override
  List<Object> get props => [error];
}

part of 'travel_cubit.dart';

abstract class TravelState extends Equatable {
  const TravelState();

  @override
  List<Object> get props => [];
}

class TravelInitial extends TravelState {}

class TravelLoading extends TravelState {}

class TravelSuccess extends TravelState {
  final List<TravelModel> travel;

  const TravelSuccess(this.travel);

  @override
  List<Object> get props => [travel];
}

class TravelSuccessAdd extends TravelState {
  final String response;

  const TravelSuccessAdd(this.response);

  @override
  List<Object> get props => [response];
}

class TravelSuccessEdit extends TravelState {
  final bool status;

  const TravelSuccessEdit(this.status);

  @override
  List<Object> get props => [status];
}

class TravelError extends TravelState {
  final String error;

  const TravelError(this.error);

  @override
  List<Object> get props => [error];
}

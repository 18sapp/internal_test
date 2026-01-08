part of 'bloc.dart';

abstract class Event extends Equatable {
  const Event();

  @override
  List<Object?> get props => [];
}

class LoadInitialData extends Event {
  const LoadInitialData();
}

class AddExpense extends Event {
  final Expense expense;
  const AddExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

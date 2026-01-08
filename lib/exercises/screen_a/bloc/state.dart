part of 'bloc.dart';

@immutable
abstract class State extends Equatable {
  final Model model;
  const State(this.model);

  @override
  List<Object?> get props => [model];
}

class ExpensesInitial extends State {
  const ExpensesInitial(super.model);
}

class ExpensesReady extends State {
  const ExpensesReady(super.model);
}

class Model extends Equatable {
  final List<Expense> expenses;

  const Model({required this.expenses});

  Model copyWith({List<Expense>? expenses}) {
    return Model(expenses: expenses ?? this.expenses);
  }

  @override
  List<Object?> get props => [expenses];
}

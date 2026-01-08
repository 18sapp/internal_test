part of 'bloc.dart';

@immutable
abstract class State extends Equatable {
  final Model model;
  const State(this.model);

  @override
  List<Object?> get props => [model];
}

class DashboardInitial extends State {
  const DashboardInitial(super.model);
}

class DashboardReady extends State {
  const DashboardReady(super.model);
}

class Model extends Equatable {
  final double total;
  final int expensesCount;

  const Model({required this.total, required this.expensesCount});

  Model copyWith({double? total, int? expensesCount}) {
    return Model(
      total: total ?? this.total,
      expensesCount: expensesCount ?? this.expensesCount,
    );
  }

  @override
  List<Object?> get props => [total, expensesCount];
}

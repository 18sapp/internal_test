import 'package:bloc/bloc.dart' as bloc;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:internal_test/exercises/screen_a/bloc/fake_repository.dart';

part 'event.dart';
part 'state.dart';

class Bloc extends bloc.Bloc<Event, State> {
  final FakeRepository repo;

  Bloc([FakeRepository? repo])
    : repo = repo ?? FakeRepository(),
      super(const DashboardInitial(Model(total: 0, expensesCount: 0))) {
    on<LoadDashboard>(_onLoadDashboard);

    add(const LoadDashboard());
  }

  void _onLoadDashboard(LoadDashboard event, bloc.Emitter<State> emit) {
    final expenses = repo.getExpenses();
    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);

    emit(
      DashboardReady(
        state.model.copyWith(total: total, expensesCount: expenses.length),
      ),
    );
  }
}

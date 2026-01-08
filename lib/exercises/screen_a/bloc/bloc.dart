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
      super(const ExpensesInitial(Model(expenses: []))) {
    on<LoadInitialData>(_onLoadInitialData);
    on<AddExpense>(_onAddExpense);

    add(const LoadInitialData());
  }

  void _onLoadInitialData(LoadInitialData event, bloc.Emitter<State> emit) {
    emit(ExpensesReady(state.model.copyWith(expenses: repo.getExpenses())));
  }

  void _onAddExpense(AddExpense event, bloc.Emitter<State> emit) {
    repo.addExpense(event.expense);

    emit(ExpensesReady(state.model.copyWith(expenses: repo.getExpenses())));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_test/exercises/screen_a/bloc/fake_repository.dart';
import 'package:internal_test/exercises/screen_b/ui/screen_b.dart';

import "../bloc/bloc.dart" as bloca;
// SOLO para el modelo Expense

class ExerciseScreenA extends StatelessWidget {
  const ExerciseScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<bloca.Bloc>(
      create: (_) => bloca.Bloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Screen A - ExpensesBloc')),
        body: BlocBuilder<bloca.Bloc, bloca.State>(
          builder: (context, state) {
            final expenses = state.model.expenses;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (_, i) {
                      final e = expenses[i];
                      return ListTile(
                        title: Text(e.title),
                        trailing: Text('\$${e.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final id = DateTime.now().millisecondsSinceEpoch;

                          context.read<bloca.Bloc>().add(
                            bloca.AddExpense(
                              Expense(
                                id: id,
                                title: 'Nuevo gasto',
                                amount: 100,
                              ),
                            ),
                          );
                        },
                        child: const Text('Agregar gasto'),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExerciseScreenB(),
                            ),
                          );
                        },
                        child: const Text('Ir a Screen B'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

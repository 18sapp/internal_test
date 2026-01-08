import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart' as blocb;

class ExerciseScreenB extends StatelessWidget {
  const ExerciseScreenB({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<blocb.Bloc>(
      create: (_) => blocb.Bloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Screen B - DashboardBloc')),
        body: BlocBuilder<blocb.Bloc, blocb.State>(
          builder: (context, state) {
            final total = state.model.total;
            final count = state.model.expensesCount;

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text('Gastos: $count', style: const TextStyle(fontSize: 16)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

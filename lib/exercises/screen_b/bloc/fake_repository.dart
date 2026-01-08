class Expense {
  final int id;
  final String title;
  final double amount;

  const Expense({required this.id, required this.title, required this.amount});
}

class FakeRepository {
  final List<Expense> _expenses = [
    Expense(id: 1, title: 'Comida', amount: 200),
    Expense(id: 2, title: 'Gasolina', amount: 500),
  ];

  List<Expense> getExpenses() => List.unmodifiable(_expenses);

  void addExpense(Expense expense) {
    _expenses.add(expense);
  }
}

import 'package:hive/hive.dart';
import 'package:expence/domain/src/models/expense.dart';

abstract class ExpenseRepository {
  Future<void> addExpense(Expense expense);
  Future<void> updateExpense(Expense expense);
  Future<void> deleteExpense(String expenseId);
  Future<Expense?> getExpenseById(String expenseId);
  Future<List<Expense>> getAllExpenses();
}

class ExpenseRepositoryImpl implements ExpenseRepository {
  final Box<Expense> _expenseBox;

  ExpenseRepositoryImpl(this._expenseBox);

  // Factory method to create an instance of ExpenseRepositoryImpl
  factory ExpenseRepositoryImpl.create(Box<Expense> expenseBox) {
    return ExpenseRepositoryImpl(expenseBox);
  }

  @override
  Future<void> addExpense(Expense expense) async {
    await _expenseBox.put(expense.expenseId, expense);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    if (_expenseBox.containsKey(expense.expenseId)) {
      await _expenseBox.put(expense.expenseId, expense);
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    await _expenseBox.delete(expenseId);
  }

  @override
  Future<Expense?> getExpenseById(String expenseId) async {
    return _expenseBox.get(expenseId);
  }

  @override
  Future<List<Expense>> getAllExpenses() async {
    return _expenseBox.values.toList();
  }
}

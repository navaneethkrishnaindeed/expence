import 'package:hive/hive.dart';
import 'package:expence/domain/src/models/category.dart';

import '../entities/expense_entity.dart';

part 'expense.g.dart'; // Needed for Hive's code generation

@HiveType(typeId: 1) // Assign a unique type ID for the Expense class
class Expense extends HiveObject {
  @HiveField(0)
  String expenseId;

  @HiveField(1)
  Category category;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  int amount;

  Expense({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
  });

  static final empty = Expense(
    expenseId: '',
    category: Category.empty,
    date: DateTime.now(),
    amount: 0,
  );

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      expenseId: expenseId,
      category: category,
      date: date,
      amount: amount,
    );
  }

  static Expense fromEntity(ExpenseEntity entity) {
    return Expense(
      expenseId: entity.expenseId,
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
    );
  }
}

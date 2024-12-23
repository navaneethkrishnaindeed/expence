import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/src/models/expense.dart';
import '../../infrastructure/i_entity_repo.dart';

part 'create_expense_event.dart';
part 'create_expense_state.dart';

class CreateExpenseBloc extends Bloc<CreateExpenseEvent, CreateExpenseState> {
  final ExpenseRepository expenseRepository;

  CreateExpenseBloc(this.expenseRepository) : super(CreateExpenseInitial()) {
    on<CreateExpense>((event, emit) async {
      emit(CreateExpenseLoading());
      try {
        await expenseRepository.addExpense(event.expense);
        emit(CreateExpenseSuccess());
      } catch (e) {
        log("Create Expence Error : $e");
        emit(CreateExpenseFailure());
      }
    });
  }
}

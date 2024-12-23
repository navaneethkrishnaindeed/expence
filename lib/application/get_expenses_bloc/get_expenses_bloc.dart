import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/src/models/expense.dart';
import '../../infrastructure/i_entity_repo.dart';

part 'get_expenses_event.dart';
part 'get_expenses_state.dart';

class GetExpensesBloc extends Bloc<GetExpensesEvent, GetExpensesState> {
  final ExpenseRepository expenseRepository;

  GetExpensesBloc(this.expenseRepository) : super(GetExpensesInitial()) {
    on<GetExpenses>((event, emit) async {
      emit(GetExpensesLoading());
      try {
        log("Fetching expenses...");
        final List<Expense> expenses = await expenseRepository.getAllExpenses();
        emit(GetExpensesSuccess(expenses));
      } catch (e) {
        log("Error fetching expenses: $e");
        emit(GetExpensesFailure(errorMessage: e.toString()));
      }
    });
  }
}

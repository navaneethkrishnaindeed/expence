import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/src/models/expense.dart';
import '../../../application/create_categorybloc/create_category_bloc.dart';
import '../../../application/create_expense_bloc/create_expense_bloc.dart';
import '../../../application/get_categories_bloc/get_categories_bloc.dart';
import '../../../infrastructure/i_category_repo.dart';
import '../../../infrastructure/i_entity_repo.dart';
import '../../../main.dart';
import '../add_expense/add_expense.dart';
import '../../components/stats.dart';
import '../../../application/get_expenses_bloc/get_expenses_bloc.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GetExpensesBloc>().add(GetExpenses());
  }

  @override
  Widget build(BuildContext context) {
    final CategoryRepository categoryRepository = CategoryRepositoryImpl.create(categoryBox);
    final ExpenseRepository expenseRepository = ExpenseRepositoryImpl.create(expenseBox);
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(builder: (context, state) {
      if (state is GetExpensesSuccess) {
        return Scaffold(
            
            // floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
            floatingActionButton: Container(
              alignment: Alignment.bottomCenter,
              // margin:  const EdgeInsets.only(bottom:30),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(bottom:0,left: 30),
                child: FloatingActionButton(
                  onPressed: () async {
                    Navigator.of(context) .push(
                 
                      MaterialPageRoute(
                        builder: (BuildContext context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => CreateCategoryBloc(categoryRepository),
                            ),
                            BlocProvider(
                              create: (context) => GetCategoriesBloc(categoryRepository)..add(GetCategories()),
                            ),
                            BlocProvider(
                              create: (context) => CreateExpenseBloc(expenseRepository),
                            ),
                          ],
                          child: const AddExpense(),
                        ),
                      ),
                    );
                
                    // if (newExpense != null) {
                    //   setState(() {
                    //     state.expenses.insert(0, newExpense);
                    //   });
                    // }
                  },
                  shape: const CircleBorder(),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.tertiary,
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary,
                          ],
                          transform: const GradientRotation(pi / 4),
                        )),
                    child: const Icon(CupertinoIcons.add),
                  ),
                ),
              ),
            ),
            body: MainScreen(state.expenses));
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../application/get_expenses_bloc/get_expenses_bloc.dart';
import '../../../domain/src/models/category.dart' as cat;
import '../../../domain/src/models/category.dart';
import '../../../domain/src/models/expense.dart';
import '../../../application/create_expense_bloc/create_expense_bloc.dart';
import '../../../application/get_categories_bloc/get_categories_bloc.dart';
import '../../../infrastructure/i_entity_repo.dart';
import '../../../main.dart';
import '../home/home_screen.dart';
import 'category_creation.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  // DateTime selectDate = DateTime.now();
  late Expense expense;
  bool isLoading = false;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense =Expense(
    expenseId: '',
    category: Category.empty,
    date: DateTime.now(),
    amount: 0,
  );
    expense.expenseId = Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                    builder: (context) {
                                      final ExpenseRepository expenseRepository = ExpenseRepositoryImpl.create(expenseBox);

                                      return BlocProvider(
                                        create: (context) => GetExpensesBloc(expenseRepository),
                                        child: const HomeScreen(),
                                      );
                                    },
                                  ), (Route<dynamic> route) => false);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Add Expenses",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            // borderRadius: BorderRadius.circular(500)
                            ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.only(),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 52,
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                    Theme.of(context).colorScheme.tertiary,
                                  ],
                                ).createShader(Rect.fromLTWH(0, 0, 200, 50)),
                            ),
                            controller: expenseController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: const Icon(
                                  FontAwesomeIcons.dollarSign,
                                  size: 40,
                                  color: Colors.transparent,
                                ),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: const Icon(
                                  FontAwesomeIcons.dollarSign,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(500), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: categoryController,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        onTap: () {},
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: expense.category == Category.empty ? Colors.white : Color(expense.category.color),
                          prefixIcon: expense.category == Category.empty
                              ? Icon(
                                  FontAwesomeIcons.list,
                                  size: 16,
                                  color: Colors.grey,
                                )
                              : Image.asset(
                                  'assets/${expense.category.icon}.png',
                                  scale: 2,
                                  color: Colors.white,
                                ),
                          suffixIcon: IconButton(
                              onPressed: () async {
                                var newCategory = await getCategoryCreation(context);
                                setState(() {
                                  state.categories.insert(0, newCategory);
                                });
                              },
                              icon: const Icon(
                                FontAwesomeIcons.plus,
                                size: 16,
                                color: Colors.grey,
                              )),
                          hintText: 'Category',
                          border: const OutlineInputBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12)), borderSide: BorderSide.none),
                        ),
                      ),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 211, 221, 229),
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                                itemCount: state.categories.length,
                                itemBuilder: (context, int i) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          expense.category = state.categories[i];
                                          categoryController.text = expense.category.name;
                                        });
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: Color(state.categories![i]!.color),
                                        child: Image.asset(
                                          'assets/${state.categories[i].icon}.png',
                                          scale: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(state.categories[i].name),
                                      tileColor: Colors.white54,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                  );
                                })),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: dateController,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: expense.date,
                            firstDate: DateTime(2024, 1, 1),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );

                          if (newDate != null) {
                            setState(() {
                              dateController.text = DateFormat('dd/MM/yyyy').format(newDate);
                              // selectDate = newDate;
                              expense.date = newDate;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.clock,
                            size: 16,
                            color: Colors.grey,
                          ),
                          hintText: 'Date',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: kToolbarHeight,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : TextButton(
                                onPressed: () {
                                  setState(() {
                                    expense.amount = int.parse(expenseController.text);
                                  });

                                  context.read<CreateExpenseBloc>().add(CreateExpense(expense));
                                  // Navigator.of(context).pop();
                                  // Navigator.pop(
                                  //   context,
                                  // );
                                  // Navigator.pop(
                                  //   context,
                                  // );
                                  // Navigator.pop(
                                  //   context,
                                  // );
                                 
                                },
                                style: TextButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(fontSize: 22, color: Colors.white),
                                )),
                      )
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

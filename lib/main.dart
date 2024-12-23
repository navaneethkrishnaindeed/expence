import 'package:bloc/bloc.dart';
import 'package:expence/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';

import 'application/simple_bloc_observer.dart';
import 'domain/src/models/category.dart';
import 'domain/src/models/expense.dart';

late final categoryBox;
late final expenseBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // Initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Register Adapters
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ExpenseAdapter());

  // Open Boxes
  categoryBox = await Hive.openBox<Category>('categories');
  expenseBox = await Hive.openBox<Expense>('expenses');
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

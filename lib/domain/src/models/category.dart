import 'package:hive/hive.dart';

import '../entities/category_entity.dart';

part 'category.g.dart'; // Needed for Hive's code generation

@HiveType(typeId: 0) // Assign a unique type ID
class Category extends HiveObject {
  @HiveField(0)
  String categoryId;

  @HiveField(1)
  String name;

  @HiveField(2)
  int totalExpenses;

  @HiveField(3)
  String icon;

  @HiveField(4)
  int color;

  Category({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
  });

  static final empty = Category(
    categoryId: '', 
    name: '', 
    totalExpenses: 0, 
    icon: '', 
    color: 0,
  );

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      totalExpenses: totalExpenses,
      icon: icon,
      color: color,
    );
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      categoryId: entity.categoryId,
      name: entity.name,
      totalExpenses: entity.totalExpenses,
      icon: entity.icon,
      color: entity.color,
    );
  }
}

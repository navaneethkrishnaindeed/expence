import 'package:hive/hive.dart';
import 'package:expence/domain/src/models/category.dart';

abstract class CategoryRepository {
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
  Future<void> deleteCategory(String categoryId);
  Future<Category?> getCategoryById(String categoryId);
  Future<List<Category>> getAllCategories();
}

class CategoryRepositoryImpl implements CategoryRepository {
  final Box<Category> _categoryBox;

  CategoryRepositoryImpl(this._categoryBox);

  // Factory method to create an instance of CategoryRepositoryImpl
  factory CategoryRepositoryImpl.create(Box<Category> categoryBox) {
    return CategoryRepositoryImpl(categoryBox);
  }

  @override
  Future<void> addCategory(Category category) async {
    await _categoryBox.put(category.categoryId, category);
  }

  @override
  Future<void> updateCategory(Category category) async {
    if (_categoryBox.containsKey(category.categoryId)) {
      await _categoryBox.put(category.categoryId, category);
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await _categoryBox.delete(categoryId);
  }

  @override
  Future<Category?> getCategoryById(String categoryId) async {
    return _categoryBox.get(categoryId);
  }

  @override
  Future<List<Category>> getAllCategories() async {
    return _categoryBox.values.toList();
  }
}

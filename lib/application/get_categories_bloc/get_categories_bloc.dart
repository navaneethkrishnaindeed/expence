import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/src/models/category.dart';
import '../../infrastructure/i_category_repo.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  final CategoryRepository categoryRepository;

  GetCategoriesBloc(this.categoryRepository) : super(GetCategoriesInitial()) {
    on<GetCategories>((event, emit) async {
      emit(GetCategoriesLoading());
      try {
        final List<Category> categories = await categoryRepository.getAllCategories();
        emit(GetCategoriesSuccess(categories));
      } catch (e) {
        emit(GetCategoriesFailure(errorMessage: e.toString()));
      }
    });
  }
}

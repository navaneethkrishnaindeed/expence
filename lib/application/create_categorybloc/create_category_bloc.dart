import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/src/models/category.dart';
import '../../infrastructure/i_category_repo.dart';

part 'create_category_event.dart';
part 'create_category_state.dart';

class CreateCategoryBloc extends Bloc<CreateCategoryEvent, CreateCategoryState> {
  final CategoryRepository categoryRepository;

  CreateCategoryBloc(this.categoryRepository) : super(CreateCategoryInitial()) {
    on<CreateCategory>((event, emit) async {
      emit(CreateCategoryLoading());
      try {
        await categoryRepository.addCategory(event.category);
        emit(CreateCategorySuccess());
      } catch (e) {
        emit(CreateCategoryFailure(errorMessage: e.toString()));
      }
    });
  }
}

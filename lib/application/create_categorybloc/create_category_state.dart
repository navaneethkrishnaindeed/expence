part of 'create_category_bloc.dart';

sealed class CreateCategoryState extends Equatable {
  const CreateCategoryState();
  
  @override
  List<Object> get props => [];
}


class CreateCategoryFailure extends CreateCategoryState {
  final String errorMessage;

  const CreateCategoryFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
final class CreateCategoryInitial extends CreateCategoryState {}

final class CreateCategoryLoading extends CreateCategoryState {}
final class CreateCategorySuccess extends CreateCategoryState {}

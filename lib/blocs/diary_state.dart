
part of 'diary_bloc.dart';

abstract class DiaryState extends Equatable {
  const DiaryState();

  @override
  List<Object> get props => [];
}

class DiaryInitial extends DiaryState {}

class DiaryLoaded extends DiaryState {
  final List<DiaryModel> diaries;

  const DiaryLoaded(this.diaries);

  @override
  List<Object> get props => [diaries];
}

class DiaryError extends DiaryState {}

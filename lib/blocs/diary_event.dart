
part of 'diary_bloc.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();

  @override
  List<Object> get props => [];
}

class LoadDiaries extends DiaryEvent {}

class CreateDiary extends DiaryEvent {
  final int year;

  const CreateDiary(this.year);

  @override
  List<Object> get props => [year];
}

class UpdateDiary extends DiaryEvent {
  final DiaryModel diary;

  const UpdateDiary(this.diary);

  @override
  List<Object> get props => [diary];
}

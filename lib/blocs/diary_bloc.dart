
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/diary_model.dart';
import '../../data/repositories/diary_repository.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  final DiaryRepository _diaryRepository;

  DiaryBloc(this._diaryRepository) : super(DiaryInitial()) {
    on<LoadDiaries>(_onLoadDiaries);
    on<CreateDiary>(_onCreateDiary);
    on<UpdateDiary>(_onUpdateDiary);
  }

  Future<void> _onLoadDiaries(LoadDiaries event, Emitter<DiaryState> emit) async {
    try {
      final diaries = await _diaryRepository.getAllDiaries();
      emit(DiaryLoaded(diaries));
    } catch (_) {
      emit(DiaryError());
    }
  }

  Future<void> _onCreateDiary(CreateDiary event, Emitter<DiaryState> emit) async {
    try {
      await _diaryRepository.createDiary(event.year);
      add(LoadDiaries());
    } catch (_) {
      emit(DiaryError());
    }
  }

  Future<void> _onUpdateDiary(UpdateDiary event, Emitter<DiaryState> emit) async {
    try {
      await _diaryRepository.updateDiary(event.diary);
      add(LoadDiaries());
    } catch (_) {
      emit(DiaryError());
    }
  }
}

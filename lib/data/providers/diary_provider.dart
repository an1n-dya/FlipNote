
import 'package:hive/hive.dart';

import '../models/diary_model.dart';

class DiaryProvider {
  final Box<DiaryModel> _diaryBox;

  DiaryProvider(this._diaryBox);

  Future<List<DiaryModel>> getAllDiaries() async {
    return _diaryBox.values.toList();
  }

  Future<DiaryModel?> getDiary(int year) async {
    return _diaryBox.get(year);
  }

  Future<void> createDiary(DiaryModel diary) async {
    await _diaryBox.put(diary.year, diary);
  }

  Future<void> updateDiary(DiaryModel diary) async {
    await _diaryBox.put(diary.year, diary);
  }
}

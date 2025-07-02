
import '../models/diary_model.dart';
import '../providers/diary_provider.dart';

class DiaryRepository {
  final DiaryProvider _diaryProvider;

  DiaryRepository(this._diaryProvider);

  Future<List<DiaryModel>> getAllDiaries() async {
    return _diaryProvider.getAllDiaries();
  }

  Future<DiaryModel?> getDiary(int year) async {
    return _diaryProvider.getDiary(year);
  }

  Future<void> createDiary(int year) async {
    final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    final days = isLeap ? 366 : 365;
    final entries = List.generate(days, (_) => '');
    final diary = DiaryModel(year: year, entries: entries, filledDays: 0);
    await _diaryProvider.createDiary(diary);
  }

  Future<void> updateDiary(DiaryModel diary) async {
    await _diaryProvider.updateDiary(diary);
  }
}

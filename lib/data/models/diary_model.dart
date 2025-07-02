
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'diary_model.g.dart';

@HiveType(typeId: 0)
class DiaryModel extends Equatable {
  @HiveField(0)
  final int year;

  @HiveField(1)
  final List<String> entries;

  @HiveField(2)
  final int filledDays;

  const DiaryModel({
    required this.year,
    required this.entries,
    required this.filledDays,
  });

  @override
  List<Object?> get props => [year, entries, filledDays];
}

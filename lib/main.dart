import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/diary_bloc.dart';
import 'data/models/diary_model.dart';
import 'data/providers/diary_provider.dart';
import 'data/repositories/diary_repository.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  Hive.registerAdapter(DiaryModelAdapter());
  final diaryBox = await Hive.openBox<DiaryModel>('diaries');
  final diaryProvider = DiaryProvider(diaryBox);
  final diaryRepository = DiaryRepository(diaryProvider);

  runApp(MyApp(diaryRepository: diaryRepository));
}

class MyApp extends StatelessWidget {
  final DiaryRepository diaryRepository;

  const MyApp({super.key, required this.diaryRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiaryBloc(diaryRepository)..add(LoadDiaries()),
      child: MaterialApp(
        title: 'FlipNote',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
      ),
    );
  }
}
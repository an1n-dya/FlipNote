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

  final currentYear = DateTime.now().year;
  final currentYearDiary = await diaryRepository.getDiary(currentYear);
  if (currentYearDiary == null) {
    await diaryRepository.createDiary(currentYear);
  }

  runApp(MyApp(diaryRepository: diaryRepository));
}

// Define a custom MaterialColor for a soft blue
MaterialColor softBlue = const MaterialColor(
  0xFFB3E5FC, // Primary color value (light blue)
  <int, Color>{
    50: Color(0xFFE1F5FE),
    100: Color(0xFFB3E5FC),
    200: Color(0xFF81D4FA),
    300: Color(0xFF4FC3F7),
    400: Color(0xFF29B6F6),
    500: Color(0xFF03A9F4),
    600: Color(0xFF039BE5),
    700: Color(0xFF0288D1),
    800: Color(0xFF0277BD),
    900: Color(0xFF01579B),
  },
);

class MyApp extends StatelessWidget {
  final DiaryRepository diaryRepository;

  const MyApp({super.key, required this.diaryRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiaryBloc(diaryRepository)..add(LoadDiaries()),
      child: MaterialApp(
        title: 'FlipNote',
        debugShowCheckedModeBanner: false, // Remove debug banner
        theme: ThemeData(
          primarySwatch: softBlue,
          colorScheme: ColorScheme.light(
            primary: softBlue,
            secondary: Colors.amber.shade300,
            surface: Colors.grey.shade100,
            onPrimary: Colors.white,
            onSecondary: Colors.black87,
            onSurface: Colors.black87,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: softBlue[100],
            foregroundColor: Colors.black87,
            elevation: 0,
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
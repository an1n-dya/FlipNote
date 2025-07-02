import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/diary_bloc.dart';
import '../../data/models/diary_model.dart';
import 'diary_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FlipNote',
          style: GoogleFonts.pacifico(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: BlocBuilder<DiaryBloc, DiaryState>(
          builder: (context, state) {
            if (state is DiaryInitial) {
              context.read<DiaryBloc>().add(LoadDiaries());
              return const Center(child: CircularProgressIndicator());
            } else if (state is DiaryLoaded) {
              return _buildDiaryList(context, state.diaries);
            } else {
              return const Center(child: Text('Failed to load diaries'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDiaryList(BuildContext context, List<DiaryModel> diaries) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: diaries.length,
      itemBuilder: (context, index) {
        final diary = diaries[index];
        final progress = diary.filledDays / diary.entries.length;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiaryPage(diary: diary),
                ),
              );
            },
            borderRadius: BorderRadius.circular(15.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diary.year.toString(),
                    style: GoogleFonts.pacifico(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Filled: ${diary.filledDays}/${diary.entries.length}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.7).round()),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.2).round()),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

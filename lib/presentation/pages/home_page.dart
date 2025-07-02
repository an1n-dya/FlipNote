
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
          style: GoogleFonts.pacifico(),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DiaryBloc, DiaryState>(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDiaryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDiaryList(BuildContext context, List<DiaryModel> diaries) {
    return ListView.builder(
      itemCount: diaries.length,
      itemBuilder: (context, index) {
        final diary = diaries[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(diary.year.toString()),
            subtitle: Text('Filled: ${diary.filledDays}/${diary.entries.length}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiaryPage(diary: diary),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showAddDiaryDialog(BuildContext context) {
    final yearController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create New Diary'),
        content: TextField(
          controller: yearController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Year'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final year = int.tryParse(yearController.text);
              if (year != null) {
                context.read<DiaryBloc>().add(CreateDiary(year));
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

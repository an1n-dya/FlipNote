import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_flip/page_flip.dart';

import '../../blocs/diary_bloc.dart';
import '../../data/models/diary_model.dart';

class DiaryPage extends StatefulWidget {
  final DiaryModel diary;

  const DiaryPage({super.key, required this.diary});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  late final _controller = GlobalKey<PageFlipWidgetState>();
  late final List<TextEditingController> _textControllers;
  late int _initialPage;

  @override
  void initState() {
    super.initState();
    _textControllers = widget.diary.entries
        .map((entry) => TextEditingController(text: entry))
        .toList();

    final now = DateTime.now();
    final startOfYear = DateTime(widget.diary.year, 1, 1);
    _initialPage = now.difference(startOfYear).inDays;

    // Ensure initial page is within bounds
    if (_initialPage < 0) _initialPage = 0;
    if (_initialPage >= widget.diary.entries.length) {
      _initialPage = widget.diary.entries.length - 1;
    }
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diary.year.toString()),
      ),
      body: PageFlipWidget(
        key: _controller,
        backgroundColor: Colors.white,
        initialIndex: _initialPage,
        children: [
          for (int i = 0; i < widget.diary.entries.length; i++) _buildPage(i),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    final date = DateTime(widget.diary.year, 1, 1).add(Duration(days: index));
    final formattedDate = DateFormat.yMMMMd().format(date);

    return CustomPaint(
      painter: RuledPaperPainter(),
      child: Container(
        color: const Color(0x00E3F2FD), // Transparent to show custom painter
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: GoogleFonts.specialElite(fontSize: 16.0),
                ),
                Text(
                  'pg-${index + 1}/${widget.diary.entries.length}',
                  style: GoogleFonts.specialElite(fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _textControllers[index],
                maxLines: null,
                style: GoogleFonts.specialElite(fontSize: 18.0),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start writing...',
                ),
                onChanged: (value) {
                  final newEntries = List<String>.from(widget.diary.entries);
                  newEntries[index] = value;
                  final filledDays = newEntries.where((e) => e.isNotEmpty).length;
                  final updatedDiary = DiaryModel(
                    year: widget.diary.year,
                    entries: newEntries,
                    filledDays: filledDays,
                  );
                  context.read<DiaryBloc>().add(UpdateDiary(updatedDiary));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RuledPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.blue.withAlpha(77)
      ..strokeWidth = 1.0;

    // Draw horizontal lines
    for (double i = 20; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), linePaint);
    }

    // Draw vertical margin line
    final Paint marginPaint = Paint()
      ..color = Colors.red.withAlpha(127)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(40, 0), Offset(40, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
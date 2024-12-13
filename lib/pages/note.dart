import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:mercury/widget/header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotePage extends StatefulWidget {
  final String noteId;
  const NotePage({super.key, required this.noteId});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    final _future = Supabase.instance.client
        .from('notes')
        .select()
        .eq('short_id', widget.noteId)
        .maybeSingle();
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        print(snapshot.error);
        if (!snapshot.hasData) {
          return const Center(child: Text("can't find the note you're looking for"));
        }
        final note = snapshot.data!;
        return FScaffold(
          header: HeaderWidget(title: note["title"]),
          content: Text(note['title']),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:mercury/util/router.dart';
import 'package:mercury/widget/editor.dart';
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
    if (widget.noteId == 'new') {
      return const FScaffold(
          header: HeaderWidget(title: "teste"),
          content: Row(children: [Expanded(child: Card(child: NoteEditor()))]));
    } else {
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
            return const Center(
                child: Text("can't find the note you're looking for"));
          }
          final note = snapshot.data!;
          return FScaffold(
              header: HeaderWidget(title: note["title"]),
              content: Row(children: [
                Expanded(
                  child: Markdown(
                    onTapLink: (text, href, title) {
                      router.go(href ?? "");
                    },
                    data: note['content'],
                  ),
                )
              ]));
        },
      );
    }
  }
}

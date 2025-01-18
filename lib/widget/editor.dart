import 'package:flutter/widgets.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({super.key});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  TextEditingController _controller = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    _controller.text = "# TESTE\n----\n### Utilizando markdown no flutter\n[Outra nota](/note/bb51b881-8263-4)\n😀";
    return MarkdownAutoPreview(
      controller: _controller,
      emojiConvert: true,
      enableToolBar: false,
    );
  }
}

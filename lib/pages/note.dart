import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  final String postId;
  const NotePage({super.key, required this.postId});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    print(widget.postId);
    return Text(widget.postId);
  }
}

import 'package:flutter/material.dart';

class CommentDialog extends StatefulWidget {
  final String? initialComment;
  
  const CommentDialog({this.initialComment});
  
  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.initialComment);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Aggiungi un ricordo'),
      content: TextField(
        controller: _commentController,
        decoration: InputDecoration(
          hintText: 'Scrivi qui il tuo ricordo...',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annulla'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_commentController.text.isNotEmpty) {
              Navigator.pop(context, _commentController.text);
            }
          },
          child: Text('Salva'),
        ),
      ],
    );
  }
}

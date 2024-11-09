import 'package:flutter/material.dart';
import '../models/daily_message.dart';
import '../providers/app_state.dart';
import 'comment_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class DailyMessageCard extends StatelessWidget {
  final DailyMessage message;
  final AppState state;

  const DailyMessageCard({
    Key? key,
    required this.message,
    required this.state,
  }) : super(key: key);

  Future<void> _saveMessage(BuildContext context, DailyMessage message, AppState state) async {
    final isInFavorites = state.favoriteMessages.any((m) => m.text == message.text);
    
    if (isInFavorites) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Questo messaggio è già nei tuoi preferiti'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final bool? wantToAddComment = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vuoi aggiungere un ricordo?'),
        content: Text('Puoi aggiungere un commento personale a questo messaggio'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No, salva solo'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Sì, aggiungi'),
          ),
        ],
      ),
    );

    if (wantToAddComment == true) {
      final commentDialog = await showDialog<String>(
        context: context,
        builder: (context) => CommentDialog(),
      );
      
      if (commentDialog != null) {
        message.comment = commentDialog;
      }
    }
    
    message.isFavorite = true;
    await state.toggleMessageFavorite(message);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Messaggio salvato con successo'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleMessageSave(BuildContext context, DailyMessage message, AppState state) async {
    final isExisting = state.favoriteMessages.any((m) => m.text == message.text);

    if (isExisting) {
      final existingMessage = state.favoriteMessages.firstWhere((m) => m.text == message.text);
      final choice = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Gestisci commento'),
          content: Text('Cosa vuoi fare con il commento di questo messaggio?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'cancel'),
              child: Text('Annulla'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'remove'),
              child: Text('Rimuovi commento'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'modify'),
              child: Text('Modifica commento'),
            ),
          ],
        ),
      );

      if (choice == 'modify') {
        final newComment = await showDialog<String>(
          context: context,
          builder: (context) => CommentDialog(initialComment: existingMessage.comment),
        );
        if (newComment != null) {
          existingMessage.comment = newComment;
          await state.toggleMessageFavorite(existingMessage);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Commento modificato con successo'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (choice == 'remove') {
        existingMessage.comment = null;
        await state.toggleMessageFavorite(existingMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Commento rimosso con successo'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      await _saveMessage(context, message, state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            if (message.comment != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.bookmark, size: 20, color: Color(0xFF4285F4)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Il tuo ricordo: ${message.comment}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    message.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Color(0xFFFF69B4),
                  ),
                  onPressed: () => _handleMessageSave(context, message, state),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/weekly_story.dart';
import 'animated_card.dart';
import 'comment_dialog.dart';
import 'card_container.dart';
import '../config/app_config.dart';

class WeeklyStoryCard extends StatelessWidget {
  final WeeklyStory story;
  final AppState state;

  const WeeklyStoryCard({
    Key? key,
    required this.story,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 8),
                Text(
                  story.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          if (story.comment != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Il tuo ricordo: ${story.comment}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    story.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () => _handleStorySave(context, story, state),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveStory(BuildContext context, WeeklyStory story, AppState state) async {
    final isInFavorites = state.favoriteStories.any((s) => s.title == story.title);
    
    if (isInFavorites) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Questa storia è già nei tuoi preferiti'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final bool? wantToAddComment = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vuoi aggiungere un ricordo?'),
        content: Text('Puoi aggiungere un commento personale a questa storia'),
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
        story.comment = commentDialog;
      }
    }
    
    story.isFavorite = true;
    await state.toggleStoryFavorite(story);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Storia salvata con successo'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleStorySave(BuildContext context, WeeklyStory story, AppState state) async {
    final isExisting = state.favoriteStories.any((s) => s.title == story.title);

    if (isExisting) {
      final existingStory = state.favoriteStories.firstWhere((s) => s.title == story.title);
      final choice = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Gestisci commento'),
          content: Text('Cosa vuoi fare con il commento di questa storia?'),
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
          builder: (context) => CommentDialog(initialComment: existingStory.comment),
        );
        if (newComment != null) {
          existingStory.comment = newComment;
          await state.toggleStoryFavorite(existingStory);
        }
      } else if (choice == 'remove') {
        existingStory.comment = null;
        await state.toggleStoryFavorite(existingStory);
      }
    } else {
      await _saveStory(context, story, state);
    }
  }
}


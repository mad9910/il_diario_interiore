import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'animated_card.dart';
import 'saved_item_tile.dart';
import 'card_container.dart';
import 'confirmation_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class SavedItemsCard extends StatefulWidget {
  @override
  _SavedItemsCardState createState() => _SavedItemsCardState();
}

class _SavedItemsCardState extends State<SavedItemsCard> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Card(
          elevation: 0,
          child: CardContainer(
            gradientColors: [
              Color(0xFF4285F4),
              Color(0xFF00FF9D),
            ],
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.collections_bookmark,
                              color: Color(0xFF4285F4),
                              size: 32,
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'I tuoi Ricordi',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'La tua collezione personale di momenti speciali',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        tabs: [
                          Tab(text: 'Messaggi'),
                          Tab(text: 'Storie'),
                        ],
                      ),
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildMessagesList(appState),
                            _buildStoriesList(appState),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessagesList(AppState appState) {
    if (appState.favoriteMessages.isEmpty) {
      return _buildEmptyState('Nessun messaggio salvato');
    }

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: appState.favoriteMessages.length,
      itemBuilder: (context, index) {
        final message = appState.favoriteMessages[index];
        return SavedItemTile(
          title: 'Messaggio salvato',
          content: message.text,
          comment: message.comment,
          onDelete: () => _handleDelete(
            context, 
            'Messaggio', 
            () async {
              await appState.toggleMessageFavorite(message, remove: true);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Messaggio eliminato con successo'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildStoriesList(AppState appState) {
    if (appState.favoriteStories.isEmpty) {
      return _buildEmptyState('Nessuna storia salvata');
    }

    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: appState.favoriteStories.length,
      itemBuilder: (context, index) {
        final story = appState.favoriteStories[index];
        return SavedItemTile(
          title: story.title,
          content: story.content,
          comment: story.comment,
          onDelete: () => _handleDelete(
            context, 
            story.title, 
            () => appState.toggleStoryFavorite(story, remove: true)
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _handleDelete(BuildContext context, String title, Function onDelete) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Conferma eliminazione',
        message: 'Sei sicuro di voler eliminare "$title" dai tuoi ricordi salvati?',
        confirmLabel: 'Elimina',
        cancelLabel: 'Annulla',
      ),
    );

    if (confirm == true) {
      onDelete();
    }
  }
}

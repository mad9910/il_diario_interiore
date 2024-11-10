import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/weekly_story.dart';

class StoryDetailCard extends StatelessWidget {
  final WeeklyStory story;

  const StoryDetailCard({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          story.title,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: story.comment != null ? Row(
          children: [
            Icon(Icons.bookmark, size: 12, color: Colors.blue),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                story.comment!,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ) : null,
        trailing: Icon(
          Icons.favorite,
          color: Colors.red[400],
          size: 18,
        ),
      ),
    );
  }
}

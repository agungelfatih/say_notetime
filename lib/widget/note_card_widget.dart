import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:say_notetime/model/note.dart';
import 'package:say_notetime/theme/theme.dart';

class NoteCardWidget extends StatelessWidget {
  final Note note;
  final int index;

  NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('MMM d, y | kk:mm').format(note.createdTime);

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              overflow: TextOverflow.ellipsis, // ... ketika overflow
              style: TextStyle(
                color: darkestGrey,
                fontFamily: 'Akrobat',
                fontSize: 25,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4,),
            Text(
              time,
              style: TextStyle(color: ligthGrey),
            ),
            const SizedBox(height: 8,),
            Text(
              note.description,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: TextStyle(
                  color: darkGrey,
                  fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

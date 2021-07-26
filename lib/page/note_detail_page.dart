import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:say_notetime/database/notes_database.dart';
import 'package:say_notetime/model/note.dart';
import 'package:say_notetime/theme/theme.dart';

import 'edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  // membaca note dari database
  Future refreshNotes() async {
    setState(() => isLoading = true);

    // mengisi variable notes dengan satu note
    this.note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back), color: darkestGrey,),
        actions: [deleteButton()],
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'D E T A I L',
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Akrobat',
                  fontWeight: FontWeight.bold,
                  color: darkestGrey
              ),
              children: [
                TextSpan(
                  text: '\nNOTES',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: grey
                  ),
                )
              ]
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: isLoading ?
            CircularProgressIndicator(color: darkestGrey) // jika loading bakal indikator loading
            : Padding(
            padding: EdgeInsets.all(12),
            child: ListView(
              children: [
                Text(
                  note.title,
                  style: TextStyle(
                    color: darkestGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'Montserrat'
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  DateFormat('MMM d, y | kk:mm').format(note.createdTime),
                  style: TextStyle(color: ligthGrey),
                ),
                SizedBox(height: 8,),
                Text(
                  note.description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkestGrey,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: const Icon(Icons.mode_edit_outlined),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage(note: note)),
          );
          refreshNotes();
        },
      ),
    );
  }

  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete_outline_rounded, color: darkestGrey,),
    onPressed: _showDeleteAlert
  );
  
  Future<void> _showDeleteAlert() async {
    return showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation!', style: TextStyle(color: darkestGrey, fontFamily: 'Montserrat'),),
          content: SingleChildScrollView(
            child: Text('Are you sure to delete this note?'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel', style: TextStyle(color: grey, fontWeight: FontWeight.bold),)),
            TextButton(
              onPressed: () async {
                await NotesDatabase.instance.delete(widget.noteId);

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),)),
          ],
        );
      }
    );
  }
}

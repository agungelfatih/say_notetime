import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:say_notetime/database/notes_database.dart';
import 'package:say_notetime/model/note.dart';
import 'package:say_notetime/theme/theme.dart';
import 'package:say_notetime/widget/note_card_widget.dart';
import 'edit_note_page.dart';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget {

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   NotesDatabase.instance.close();
  //
  // }

  // membaca note dari database
  Future refreshNotes() async {
    setState(() => isLoading = true);

    // mengisi variable notes dengan list note
    this.notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Y O U R',
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
          child: isLoading ? CircularProgressIndicator(color: darkestGrey) // jika loading bakal indikator loading
              : notes.isEmpty // jika tidak maka akan mengecek apakah note kosong
              ? Text('No Notes', style: TextStyle(color: grey, fontSize: 24)) // jika kososng, tampil "no notes"
              : buildNotes(),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: darkestGrey,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Icon(Icons.playlist_add_rounded),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditNotePage()),
          );
          refreshNotes();
        },
      ),
    );
  }

  Widget buildNotes() {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return Container(
          // height: 200,
          child: InkWell(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return NoteDetailPage(noteId: note.id!);
              }));

              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          ),
        );
      }
    );
  }

}


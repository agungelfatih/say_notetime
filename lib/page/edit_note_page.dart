import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:say_notetime/database/notes_database.dart';
import 'package:say_notetime/model/note.dart';
import 'package:say_notetime/theme/theme.dart';
import 'package:say_notetime/widget/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {

  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: NoteFormWidget(
            title: title,
            description: description,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: darkestGrey,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Icon(Icons.save_outlined),
        onPressed: addOrUpdateNote
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}

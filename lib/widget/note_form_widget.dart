import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:say_notetime/theme/theme.dart';

class NoteFormWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  NoteFormWidget({
    Key? key,
    this.title = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back), color: darkestGrey,),
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: title == '' ? 'A D D' : "E D I T",
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                maxLines: 1,
                initialValue: title,
                style: TextStyle(
                  color: darkestGrey,
                  fontSize: 25,
                  fontFamily: 'Montserrat'
                ),
                decoration: InputDecoration(
                  hintText: 'Enter the title...',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ligthGrey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ligthGrey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintStyle: TextStyle(color: darkGrey),
                ),
                validator: (title) {
                  return title != null && title.isEmpty ? 'Oops! Your note has no title' : null;
                },
                onChanged: onChangedTitle,
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                initialValue: description,
                style: TextStyle(
                  color: darkGrey,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter the description...',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ligthGrey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ligthGrey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: grey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintStyle: TextStyle(color: darkGrey),
                ),
                validator: (desc) {
                  return desc != null && desc.isEmpty ? 'Oops! Your note has no description' : null;
                },
                onChanged: onChangedDescription,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

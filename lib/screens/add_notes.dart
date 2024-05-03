import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Utils/utils.dart';
import 'package:notes_app/widgets/round_button.dart';

class AddNotesScreen extends StatefulWidget {
  final String? id;
  final bool isForUpdate;
  final String? body;
  const AddNotesScreen(
      {this.body, this.isForUpdate = false, this.id, super.key});

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Notes');
  final postController = TextEditingController();

  @override
  void initState() {
    postController.text = widget.body ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          'Add Notes',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                  hintText: 'What is in your mind?',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
              loading: loading,
              title: widget.isForUpdate ? 'Update' : 'Add Notes',
              onTap: widget.isForUpdate
                  ? () {
                      databaseRef.child(widget.id!).update({
                        'title': postController.text.toString()
                      }).then((value) {
                        Utils().toastMessage('Note Update');
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                      });
                    }
                  : () {
                      setState(() {
                        loading = true;
                      });

                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      databaseRef.child(id).set({
                        'title': postController.text.toString(),
                        'id': id,
                      }).then((value) {
                        Utils().toastMessage('Note Added');
                        setState(() {
                          loading = false;
                        });
                      }).onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    },
            )
          ],
        ),
      ),
    );
  }
}

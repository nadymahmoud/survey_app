import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:project/views/home_view.dart';

class CreateSurveyView extends StatefulWidget {
  const CreateSurveyView({super.key});

  @override
  State<CreateSurveyView> createState() => _CreateSurveyViewState();
}

class _CreateSurveyViewState extends State<CreateSurveyView> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _writeController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  final CollectionReference _items =
      FirebaseFirestore.instance.collection('items');
  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Create your Question',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _writeController,
                  decoration: InputDecoration(
                    labelText: 'Write your Question',
                    hintText: 'Write your Question......?',
                  ),
                ),
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    hintText: 'Answer....!!',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: ' Question Number ',
                    hintText: '1 , 2 , 3 , ......',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.black,
                    ),
                  ),
                  onPressed: () async {
                    final String writeQuestion = _writeController.text;
                    final String answer = _answerController.text;
                    final int? number = int.tryParse(_numberController.text);
                    if (number != null) {
                      await _items.add(
                        {
                          "write question": writeQuestion,
                          "answer": answer,
                          "question number": number
                        },
                      );
                      _writeController.text = '';
                      _answerController.text = '';

                      _numberController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Create'),
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _writeController.text = documentSnapshot["write question"];
      _answerController.text = documentSnapshot["answer"];

      _numberController.text = documentSnapshot["question number"].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Update your Question',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                TextField(
                  controller: _writeController,
                  decoration: InputDecoration(
                    labelText: 'Write your Question',
                    hintText: 'Write your Question......?',
                  ),
                ),
                TextField(
                  controller: _answerController,
                  decoration: InputDecoration(
                    labelText: 'Answer',
                    hintText: 'Answer....!!',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _numberController,
                  decoration: InputDecoration(
                    labelText: ' Question Number ',
                    hintText: '1 , 2 , 3 , ......',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.black)),
                  onPressed: () async {
                    final String writeQuestion = _writeController.text;
                    final String answer = _answerController.text;
                    final int? number = int.tryParse(_numberController.text);
                    if (number != null) {
                      await _items.doc(documentSnapshot!.id).update(
                        {
                          "write question": writeQuestion,
                          "answer": answer,
                          "question number": number
                        },
                      );
                      _writeController.text = '';
                      _answerController.text = '';

                      _numberController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Update'),
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String itemID) async {
    await _items.doc(itemID).delete();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have successfully deleted a question')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Create Survey'),
      ),
      body: StreamBuilder(
          stream: _items.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    color: Color.fromARGB(181, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.white,
                        child: Text(
                          documentSnapshot['question number'].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                      title: Text(
                        documentSnapshot['write question'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      subtitle: Text(
                        documentSnapshot['answer'],
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                color: Colors.black,
                                onPressed: () => _update(documentSnapshot),
                                icon: Icon(Icons.edit)),
                            IconButton(
                                color: Colors.black,
                                onPressed: () => _delete(documentSnapshot.id),
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(),
        backgroundColor: Color.fromARGB(181, 255, 255, 255),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}

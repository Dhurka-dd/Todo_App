import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);
  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  String input = '';

  createTodos(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(input);
    Map<String,String> todos = {
      "todoTitle":input
    };
    documentReference.set(todos).whenComplete((){
      print("$input created");
    });
  }

  deleteTodos(item){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(item);
    documentReference.delete().whenComplete((){
      print("$item deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Todos"),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text("Add Todolist"),
                  content: TextField(
                    onChanged: (String value){
                      input = value;
                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: (){
                          createTodos();
                          Navigator.of(context).pop();
                        },
                        child: Text("Add"),
                    ),
                  ],
                );
              },
          );
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
      body:StreamBuilder(
          stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
          builder: (context,AsyncSnapshot snapshot){
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
                itemBuilder: (context,index){
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                 return Dismissible(
                   onDismissed: (direction){
                     deleteTodos(documentSnapshot["todoTitle"]);
                   },
                     key: Key(documentSnapshot["todoTitle"]),
                     child: Card(
                       elevation: 4,
                       margin: EdgeInsets.all(8),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                       child: ListTile(
                         title: Text(documentSnapshot["todoTitle"]),
                         trailing: IconButton(
                           icon: Icon(Icons.delete,color: Colors.red,),
                           onPressed: (){
                             setState((){
                               deleteTodos(documentSnapshot["todoTitle"]);
                             });
                           },
                         ),
                       ),
                     ),
                 );
                },
            );
          },
      ),
    );
  }
}







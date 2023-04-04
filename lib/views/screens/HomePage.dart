import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../helpers/firebase_auth_helper.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  GlobalKey<FormState> authorKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController bookController = TextEditingController();
  String name = "";
  String book = "";
  Uint8List? image;
  Uint8List? decodedImage;
  String encodedImage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Author Registration",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
        backgroundColor: Colors.black,
        leading: Icon(Icons.arrow_back_ios,color: Colors.white,
        ),
      ),
      body:  SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseCloudHelper.firebaseCloudHelper.fetchAllData(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data!;
              List<QueryDocumentSnapshot> queryDocumentSnapshot = querySnapshot.docs;

              return ListView.builder(
                itemCount: queryDocumentSnapshot.length,
                itemBuilder: (context, i) {
                  Map<String, dynamic> data = queryDocumentSnapshot[i].data() as Map<String, dynamic>;

                  if (data["image"] != null) {
                    // decodedImage == null;
                    decodedImage = base64Decode(data["image"]);
                  } else {
                    decodedImage == null;
                  }
                  //image = base64Decode(data['image']);
                   return ListTile(
                     title: Text("Author : ${data["name"]}"),
                     subtitle: Text("Books : ${data["book"]}"),
                     trailing: InkWell (
                   onTap: () async {
                     deleteData(id: queryDocumentSnapshot[i].id);
                                       },
                         child: Icon(Icons.delete,color: Colors.red,)
                     ),
                    );
                  },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: (){
          ValidateAndInsert(context);
        },
        label: Text("Add",style: TextStyle(fontSize: 22),),
        icon: Icon(Icons.add,size: 30,),
      ),
      backgroundColor: Colors.white,
    );
  }


  ValidateAndInsert(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "Add Here",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800,color: Colors.black),
            ),
            content: Form(
              key: authorKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter name First...";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      name = val!;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey)),
                      hintText: "Author name",
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter book First...";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      book = val!;
                    },
                    controller: bookController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey)),
                      hintText: "Book name",
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  if (authorKey.currentState!.validate()) {
                    authorKey.currentState!.save();

                    await FirebaseCloudHelper.firebaseCloudHelper.insertData(name: name, book: book,);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("Failed To Add data"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                  nameController.clear();
                  bookController.clear();

                  setState(() {
                    name = "";
                    book = "";
                  });
                  Navigator.pop(context);
                },

                child: Text("Save",style: TextStyle(color:  Colors.blue,),),
              ),
              OutlinedButton(
                onPressed: () {
                  nameController.clear();
                  bookController.clear();

                  setState(() {
                    name = "";
                    book = "";
                  });

                  Navigator.pop(context);
                },
                child: Text("Clear",style: TextStyle(color: Colors.blue),),),
            ],
          );
        });
  }


  deleteData({required String id}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: const Text("Delete Data",style: TextStyle(color: Colors.red),),
        content: const Text(
          "Are you sure for delete",
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              FirebaseCloudHelper.firebaseCloudHelper.deleteData(deleteId: id);

              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

}

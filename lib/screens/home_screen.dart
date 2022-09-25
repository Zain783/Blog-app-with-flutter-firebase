import 'package:blogappflutter/screens/add_post.dart';
import 'package:blogappflutter/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatelessWidget {
  final dbref = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Blogs"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          InkWell(
            child: const Icon(Icons.add),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext) => AddPost()));
            },
          ),
          InkWell(
            child: const Icon(Icons.logout),
            onTap: () {
              _auth.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen(),
                  ),
                  (route) => false,
                );
              }).onError((error, stackTrace) {
                tostmessages(error.toString());
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  itemCount: streamSnapshot.data?.docs.length,
                  itemBuilder: (ctx, index) {
                    final imagepath =
                        streamSnapshot.data?.docs[index]['pImage'];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              //because image could be null or some time not null
                              child: streamSnapshot.data?.docs[index]
                                          ['pImage'] !=
                                      null
                                  ? Image.network(
                                      imagepath.toString(),
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      "images/bloglogo.jpg",
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${streamSnapshot.data?.docs[index]['pTitle']}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${streamSnapshot.data?.docs[index]['pDescription']}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ),
                        )
                      ],
                    );
                  });
            },
          ))
        ],
      ),
    );
  }
}

void tostmessages(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0);
}

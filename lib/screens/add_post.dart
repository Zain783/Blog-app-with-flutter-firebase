import 'dart:io';
import 'package:blogappflutter/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPost extends StatefulWidget {
  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _descriptionEditingController = TextEditingController();
  File? _image;
  // late Future<PickedFile?> pickedFile;
  String temptitle = "";
  final _picker = ImagePicker();
  int counter = 0;
  FirebaseStorage storage = FirebaseStorage.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  bool showSpinner = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  void dialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getCameraImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print("no image selected ${counter++}");
    }
  }

  Future getCameraImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print("no image selected ${counter++}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Blogs"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  dialog(context);
                },
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 1,
                    child: _image != null
                        ? ClipRRect(
                            child: Image.file(
                            _image!.absolute,
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          ))
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10)),
                            width: 100,
                            height: 100,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    controller: _titleEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Title",
                        hintText: 'Enter post title',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    minLines: 1,
                    maxLines: 5,
                    controller: _descriptionEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Description",
                        hintText: 'Enter post description',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  RoundButton(
                      title: showSpinner == false
                          ? const Text(
                              "Upload",
                              style: TextStyle(color: Colors.white),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                      onPressed: () async {
                        try {
                          setState(() {
                            showSpinner = true;
                          });
                          int date = DateTime.now().microsecondsSinceEpoch;
                          //this code will help us to just for create path or reference for store image
                          Reference reference =
                              FirebaseStorage.instance.ref('/blogapp${date}');
                          //To mix prev url or path with image path
                          UploadTask uploadTask =
                              reference.putFile(_image!.absolute);
                          //with the help of this image will upload to firebase storage.
                          await Future.value(uploadTask);
                          String newUrl = await reference.getDownloadURL();
                          User? user = _auth.currentUser;
                          final postRef = FirebaseFirestore.instance
                              .collection("Posts")
                              .doc(date.toString())
                              .set({
                            'pId': date.toString(),
                            'pImage': newUrl.toString(),
                            'pTime': date.toString(),
                            'pTitle': _titleEditingController.text.toString(),
                            'pDescription':
                                _descriptionEditingController.text.toString(),
                            'uEmail': user!.email.toString(),
                            'uId': user.uid.toString(),
                          });
                          // postRef
                          //     .child("Post List")
                          //     .child(date.toString())
                          //     .set({
                          //   'pId': date.toString(),
                          //   'pImage': newUrl.toString(),
                          //   'pTime': date.toString(),
                          //   'pTitle': _titleEditingController.text.toString(),
                          //   'pDescription':
                          //       _descriptionEditingController.text.toString(),
                          //   'uEmail': user!.email.toString(),
                          //   'uId': user.uid.toString(),
                          // }).then((value) {
                          //   setState(() {
                          //     showSpinner = false;
                          //   });
                          //   tostmessages("Post Uploaded");
                          // }).onError((error, stackTrace) {
                          //   setState(() {
                          //     showSpinner = false;
                          //   });
                          //   tostmessages(error.toString());
                          // });
                          //     .collection('Posts')
                          //     .doc(date.toString())
                          //     .set({
                          //   'pId': date.toString(),
                          //   'pImage': newUrl.toString(),
                          //   'pTime': date.toString(),
                          //   'pTitle': _titleEditingController.text.toString(),
                          //   'pDescription':
                          //       _descriptionEditingController.text.toString(),
                          //   'uEmail': user!.email.toString(),
                          //   'uId': user.uid.toString(),
                          // });
                          setState(() {
                            showSpinner = false;
                          });
                          tostmessages("Post Uploaded");
                        } catch (e) {
                          setState(() {
                            showSpinner = false;
                          });
                          tostmessages(e.toString());
                        }
                      })
                ],
              ))
            ],
          ),
        ),
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

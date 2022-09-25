import 'package:blogappflutter/components/round_button.dart';
import 'package:blogappflutter/screens/forgetpassword.dart';
import 'package:blogappflutter/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    final _formkey = new GlobalKey<FormState>();
    bool _showSpinner = false;
    FirebaseAuth _firebase_auth = FirebaseAuth.instance;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Forget Password"),
          ),
          body: ModalProgressHUD(
            inAsyncCall: _showSpinner,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            onChanged: (value) {},
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                label: Text("Email"),
                                border: OutlineInputBorder(),
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "enter email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          RoundButton(
                              title: _showSpinner == false
                                  ?const Text(
                                      "Recover Password",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  :const CircularProgressIndicator(
                                      color: Colors.orange,
                                    ),
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    _showSpinner = true;
                                  });
                                  try {
                                    _firebase_auth
                                        .sendPasswordResetEmail(
                                            email: emailcontroller.text)
                                        .then((value) {
                                      tostmessages("Please Check Your Email");
                                      setState(() {
                                        _showSpinner = false;
                                      });
                                    }).onError((error, stackTrace) {
                                      tostmessages(error.toString());
                                    });
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  } catch (e) {
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                    tostmessages(e.toString());
                                  }
                                }
                              })
                        ],
                      ),
                    ))
              ],
            ),
          )),
    );
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
}

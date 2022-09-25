import 'package:blogappflutter/screens/forgetpassword.dart';
import 'package:blogappflutter/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/round_button.dart';

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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passowordcontroller = TextEditingController();
    final _formkey = new GlobalKey<FormState>();
    bool _showSpinnertemp = false;
    FirebaseAuth _firebase_auth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Account"),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
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
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter password";
                            }
                            return null;
                          },
                          controller: passowordcontroller,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Password',
                              label: Text("password"),
                              prefixIcon: Icon(Icons.password)),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPasswordScreen()));
                            },
                            child: const Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   width: double.infinity,
                        //   height: 40,
                        //   child: ElevatedButton(
                        //     style: ButtonStyle(),
                        //     onPressed: () async {
                        //       if (_formkey.currentState!.validate()) {
                        //         setState(() {
                        //           _showSpinnertemp = true;
                        //         });
                        //         try {
                        //           final User = await _firebase_auth
                        //               .signInWithEmailAndPassword(
                        //                   email: emailcontroller.text,
                        //                   password: passowordcontroller.text);
                        //           if (User != null) {
                        //             tostmessages("user successfully Logined");
                        //             setState(() {
                        //               _showSpinnertemp = false;
                        //             });
                        //             Navigator.pushAndRemoveUntil(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (BuildContext context) =>
                        //                     HomeScreen(),
                        //               ),
                        //               (route) => false,
                        //             );
                        //           }
                        //         } catch (e) {
                        //           setState(() {
                        //             _showSpinnertemp = false;
                        //           });
                        //           print(e.toString());
                        //           tostmessages(e.toString());
                        //         }
                        //       }
                        //     },
                        //     child: _showSpinnertemp == false
                        //         ? const Text(
                        //             "Login",
                        //             style: TextStyle(color: Colors.white),
                        //           )
                        //         : const CircularProgressIndicator(
                        //             color: Colors.white,
                        //           ),
                        //   ),
                        // ),,
                        RoundButton(
                            title: _showSpinnertemp == false
                                ? const Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                            onPressed: () async {
                              setState(() {
                                _showSpinnertemp = true;
                              });
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  _showSpinnertemp = true;
                                });
                                try {
                                  final User = await _firebase_auth
                                      .signInWithEmailAndPassword(
                                          email: emailcontroller.text,
                                          password: passowordcontroller.text);
                                  if (User != null) {
                                    tostmessages("user successfully Logined");
                                    setState(() {
                                      _showSpinnertemp = false;
                                    });
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomeScreen(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                } catch (e) {
                                  setState(() {
                                    _showSpinnertemp = false;
                                  });
                                  print(e.toString());
                                  tostmessages(e.toString());
                                }
                              }
                            })
                      ],
                    ),
                  ),
                ))
          ],
        ));
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

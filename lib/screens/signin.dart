import 'package:blogappflutter/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passowordcontroller = TextEditingController();
    final _formkey = new GlobalKey<FormState>();
    bool _showSpinner = false;
    FirebaseAuth _firebase_auth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Account"),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            const SizedBox(
              height: 40,
            ),
            const Align(
              alignment: Alignment.center,
              child: const Text(
                "Register",
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
                        RoundButton(
                            title: _showSpinner == false
                                ? const Text(
                                    "Recover Password",
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const CircularProgressIndicator(
                                    color: Colors.orange,
                                  ),
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  _showSpinner = true;
                                });
                                try {
                                  final User = await _firebase_auth
                                      .createUserWithEmailAndPassword(
                                          email: emailcontroller.text,
                                          password: passowordcontroller.text);
                                  if (User != null) {
                                    print("not registered");
                                    tostmessages(
                                        "user successfully registered");
                                    setState(() {
                                      _showSpinner = false;
                                    });
                                  } else {
                                    print("success");
                                  }
                                } catch (e) {
                                  setState(() {
                                    _showSpinner = false;
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
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

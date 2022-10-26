import 'package:chatapp_flutter_firebase_project/helper/helper_function.dart';
import 'package:chatapp_flutter_firebase_project/pages/auth/register_page.dart';
import 'package:chatapp_flutter_firebase_project/pages/home_page.dart';
import 'package:chatapp_flutter_firebase_project/service/auth_service.dart';
import 'package:chatapp_flutter_firebase_project/service/database_service.dart';
import 'package:chatapp_flutter_firebase_project/shared/color_constants.dart';
import 'package:chatapp_flutter_firebase_project/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  String email = "";
  String password = "";
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Title, name of app
                          Text(
                            "Groupie",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Login now to see what are they talking",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),

                          //Image of login page
                          Image.asset("assets/login.png"),

                          //Email Field
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Email",
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (value) => setState(() {
                              email = value;
                            }),
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          // Password field
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (value) => setState(() {
                              password = value;
                            }),
                            validator: (value) {
                              if (value!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                          ),

                          SizedBox(
                            height: 25,
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 35,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorConstants().primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Text("Sign in",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              onPressed: () {
                                login();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text.rich(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            TextSpan(
                                text: "Don't have an account ? ",
                                children: [
                                  TextSpan(
                                      text: "Register here.",
                                      style: TextStyle(
                                          color: Colors.black,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(context, RegisterPage());
                                        })
                                ]),
                          )
                        ])),
              ),
            ),
    );
  }

  login() async {
    QuerySnapshot snapshot;
    // if (formKey.currentState!.validate()) {}
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .loginWithUserAndPassword(email, password)
          .then((value) async => {
                if (value == true)
                  {
                    snapshot = await DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .gettingUserData(email),
                    //saving the values to our share preference
                    await HelperFunctions.saveUserLoggedInStatus(true),
                    await HelperFunctions.saveUserEmailSF(email),
                    await HelperFunctions.saveUserNameSF(
                        snapshot.docs[0]["fullName"]),
                    nextScreenReplace(context, HomePage())
                  }
                else
                  {
                    showSnackBar(context, Colors.red, value),
                    setState(() {
                      _isLoading = false;
                    })
                  }
              });
    }
  }
}

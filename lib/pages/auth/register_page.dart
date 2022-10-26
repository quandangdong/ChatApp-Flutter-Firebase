import 'package:chatapp_flutter_firebase_project/helper/helper_function.dart';
import 'package:chatapp_flutter_firebase_project/pages/auth/login_page.dart';
import 'package:chatapp_flutter_firebase_project/pages/home_page.dart';
import 'package:chatapp_flutter_firebase_project/service/auth_service.dart';
import 'package:chatapp_flutter_firebase_project/shared/color_constants.dart';
import 'package:chatapp_flutter_firebase_project/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String email = "";
  String password = "";
  String confirmPassword = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).primaryColor,
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
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
                            "Create account to talk with everyone",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),

                          //Image of register page
                          Image.asset("assets/register.png"),

                          //Fullname Field
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Fullname",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (value) => setState(() {
                              fullName = value;
                            }),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Full name cannot be null";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          //email field
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

                          // Confirm passoword field
                          SizedBox(
                            height: 20,
                          ),

                          // Password field
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Confirm Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (value) => setState(() {
                              confirmPassword = value;
                            }),
                            validator: (value) {
                              if (value!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else if (value.toString() != password) {
                                return "Incorrect confirm password";
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
                              child: Text("Register Account",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              onPressed: () {
                                register();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text.rich(
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            TextSpan(text: "Have an account ? ", children: [
                              TextSpan(
                                  text: "Sign in.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreenReplace(context, LoginPage());
                                    })
                            ]),
                          )
                        ])),
              ),
            ),
    );
  }

  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async => {
                if (value == true)
                  {
                    //saving the shared preference state
                    await HelperFunctions.saveUserLoggedInStatus(true),
                    await HelperFunctions.saveUserNameSF(fullName),
                    await HelperFunctions.saveUserEmailSF(email),
                    nextScreen(context, HomePage())
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

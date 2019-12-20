import 'package:crystagram_yen/utilities/dialog_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crystagram_yen/screens/signup_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool isLoading = false;
  ProgressDialog progressDialog;

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = true;
      });

      // Logging in the user w/ Firebase
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
      } catch (e) {
        DialogMessage.showErrorMessageDialog(context, 'Error', e);

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                isLoading
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey.withOpacity(0.5),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SizedBox.shrink(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'crystagram',
                      style: TextStyle(
                        fontFamily: 'Billabong',
                        fontSize: 50.0,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 10.0,
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Email'),
                              validator: (input) => !input.contains('@')
                                  ? 'Please enter a valid email'
                                  : null,
                              onSaved: (input) => _email = input,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 10.0,
                            ),
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Password'),
                              validator: (input) => input.length < 6
                                  ? 'Must be at least 6 characters'
                                  : null,
                              onSaved: (input) => _password = input,
                              obscureText: true,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 250.0,
                            child: FlatButton(
                              onPressed: _submit,
                              color: Colors.blue,
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: 250.0,
                            child: FlatButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, SignupScreen.id),
                              color: Colors.blue,
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Go to Signup',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

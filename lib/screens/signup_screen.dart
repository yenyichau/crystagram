import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crystagram_yen/utilities/dialog_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password;
  bool isLoading = false;

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        isLoading = true;
      });

      // Logging in the user w/ Firebase
      try {
        AuthResult authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        FirebaseUser signedInUser = authResult.user;
        if (signedInUser != null) {
          Firestore.instance
              .collection('/users')
              .document(signedInUser.uid)
              .setData({
            'name': _name,
            'email': _email,
            'profileImageUrl': '',
          });
          // Provider.of<UserData>(context).currentUserId = signedInUser.uid;
          // Navigator.pop(context);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
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
                              decoration: InputDecoration(labelText: 'Name'),
                              validator: (input) => input.trim().isEmpty
                                  ? 'Please enter a valid name'
                                  : null,
                              onSaved: (input) => _name = input,
                            ),
                          ),
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
                                'Sign Up',
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
                              onPressed: () => Navigator.pop(context),
                              color: Colors.blue,
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Back to Login',
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

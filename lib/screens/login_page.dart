import 'package:donence_app/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:donence_app/provider/google_sign_in.dart';
import 'package:donence_app/widget/background_painter.dart';
import 'package:donence_app/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final provider = Provider.of<GoogleSignInProvider>(context);
          if (provider.isSigningIn) {
            return buildLoading();
          } else if (snapshot.hasData) {
            //addUserDatabase();
            return HomePage(FirebaseAuth.instance.currentUser);
          } else {
            return SignUpWidget();
          }
        },
      ),
    ),
  );

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      CustomPaint(painter: BackgroundPainter()),
      Center(child: CircularProgressIndicator()),
    ],
  );
}
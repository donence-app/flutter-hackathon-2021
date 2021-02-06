import 'package:donence_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:donence_app/screens/info_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LandingPage extends StatelessWidget {
  Future<bool> checkFirstStart() async {
    var sp = await SharedPreferences.getInstance();
    if (sp.getBool('isFirstStart') == null) {
      await sp.setBool('isFirstStart', false);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: onBordingBody(),
    );
  }

  Widget onBordingBody() {
    var check = checkFirstStart();
    return FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot ss) {
          switch (ss.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;

            default:
              if (ss.hasError) {
                return Text(ss.error.toString());
              } else if (ss.data == true) {
                return Container(child: SliderLayoutView());
              } else {
                return LoginPage();
              }
          }
        },
        future: check);
  }
}

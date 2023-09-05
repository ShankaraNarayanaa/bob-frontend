// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:bookmytickets/screens/HomePage.dart';
import 'package:bookmytickets/screens/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBvKm6n5AOxTa1oG_lxst3cWumknSbevxQ",
      authDomain: "book-my-tickets-4213f.firebaseapp.com",
      projectId: "book-my-tickets-4213f",
      storageBucket: "book-my-tickets-4213f.appspot.com",
      messagingSenderId: "473086463304",
      appId: "1:473086463304:web:19ce3c51fe88453ebe377d",
      measurementId: "G-PQ9H9NM56E"
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book My Tickets',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.manropeTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // Widget splashScreenWeb(BuildContext context){
  //   return Scaffold();
  // }

  // Widget splashScreenMobile(BuildContext )
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLogged = prefs.getBool('isLoggedIn');
    if(isLogged == true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // return isLoading ? Center(child: SizedBox(height: 50,width: 50,child: CircularProgressIndicator(),),) : 
    // LayoutBuilder(builder: (context, constraints){
    //   if(constraints.maxWidth > 700) return dashboardWeb(context);
    //   else return dashboardMobile(context);
    // });
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(
                'https://i.ebayimg.com/images/g/4HYAAOSwatFiw-jJ/s-l1600.jpg'
              ), fit: BoxFit.cover)
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.35, 0.5, 0.7, 0.9],
                colors: [
                  Colors.black54,
                  Colors.black45,
                  Colors.black45,
                  Colors.black45,
                  Colors.black54
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Book My Tickets',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width < 700 ? 30 : 60,
                    color: Colors.white
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(color: Colors.white,),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
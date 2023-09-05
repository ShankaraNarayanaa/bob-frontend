// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unnecessary_null_comparison, body_might_complete_normally_catch_error

import 'package:bookmytickets/screens/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSpinning = false;
  bool isSignUp = false;

  bool validation() {
    if(!emailController.text.toString().contains("@")){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 5,
          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.3, 5.0, MediaQuery.of(context).size.width * 0.3, 30.0),
          content: Text(
            'Invalid E-Mail or Password. Please Try Again',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
        )
      );
      setState((){
        isSpinning = false;
      });
      return false;
    }
    if(!(passwordController.text.length > 5)){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 15,
          width: MediaQuery.of(context).size.width * 0.45,
          content: Text(
            'Invalid E-Mail or Password. Please Try Again',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
        )
      );
      setState((){
        isSpinning = false;
      });
      return false;
    }
    return true;
  }

  Future<void> signUp() async{
    setState(() {
      isSpinning = true;
    });
    if(validation()){
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString()
      ).catchError(
        (e){
          setState(() {
            isSpinning = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 15,
              width: MediaQuery.of(context).size.width * 0.6,
              content: Text(
                'Invalid E-Mail or Password. Please Try Again',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade600,
            )
          );
        }
      );
      if(credential != null){
        SharedPreferences prefs = await SharedPreferences.getInstance();
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
            'userId' : FirebaseAuth.instance.currentUser!.uid,
            'email' : FirebaseAuth.instance.currentUser!.email
          }).then((value){
              prefs.setString('userId', FirebaseAuth.instance.currentUser!.uid);
              prefs.setBool('isLoggedIn', true).then((value){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomePage())));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 15,
                    width: MediaQuery.of(context).size.width * 0.45,
                    content: Text(
                      'Signup Successful',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green.shade600,
                  )
                );
              });
          });
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 15,
            width: MediaQuery.of(context).size.width * 0.6,
            content: Text(
              'Invalid E-Mail or Password. Please Try Again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade600,
          )
        );
      }
    }
  }

  Future<void> signIn() async{
    setState(() {
      isSpinning = true;
    });
    if(validation()){
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text.toString()
      ).catchError(
        (e){
          setState(() {
            isSpinning = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              elevation: 15,
              width: MediaQuery.of(context).size.width * 0.6,
              content: Text(
                'Invalid E-Mail or Password. Please Try Again',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red.shade600,
            )
          );
        }
      );
      if(credential != null){
        SharedPreferences prefs = await SharedPreferences.getInstance();
          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
            if(value.data() != {}){
              prefs.setString('userId', value.data()!['userId']);
              prefs.setBool('isLoggedIn', true).then((value){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => HomePage())));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 15,
                    width: MediaQuery.of(context).size.width * 0.45,
                    content: Text(
                      'Login Successful',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
                      ),
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.green.shade600,
                  )
                );
              });
            }
          });
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 15,
            width: MediaQuery.of(context).size.width * 0.6,
            content: Text(
              'Invalid E-Mail or Password. Please Try Again',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade600,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://media.istockphoto.com/id/1281041623/vector/studio-room-background.jpg?s=612x612&w=0&k=20&c=sa4Cmfav9HqximETEl9AuMy5BkMNgwu9c-b4apMm4rA='), 
                fit: BoxFit.cover
              )
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isSignUp ? 'Welcome to\nBookMyTickets' : 'Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width > 950 ? 50 : MediaQuery.of(context).size.width * 0.07, fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' 👋',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 950 ? 50 : MediaQuery.of(context).size.width * 0.07, fontWeight: FontWeight.bold, color: Colors.white
                    ),
                  )
                ],
              ), SizedBox(height: 10,),
              Text(
                'Please enter your E-Mail and Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize:MediaQuery.of(context).size.width > 950 ? 25 : MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.w400,
                ),
              ),SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.of(context).size.width > 600 ? 450 : MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  'E-Mail ',
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white
                  ),
                ),
              ),SizedBox(height: 15,),
              Container(
                width: MediaQuery.of(context).size.width > 600 ? 450 : MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: Colors.black),
                  color: Colors.white24
                ),
                child: TextFormField(
                  controller: emailController,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                  decoration: InputDecoration(
                    hintText: 'E-Mail',
                    hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white60,),
                    border: InputBorder.none,
                  ),
                ),
              ),SizedBox(height: 30,),
              SizedBox(
                width: MediaQuery.of(context).size.width > 600 ? 450 : MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  'Password ',
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white
                  ),
                ),
              ),SizedBox(height: 15,),
              Container(
                width: MediaQuery.of(context).size.width > 600 ? 450 : MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: Colors.black),
                  color: Colors.white24
                ),
                child: TextFormField(
                  controller: passwordController,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white60),
                    border: InputBorder.none,
                  ),
                ),
              ),SizedBox(height: 50,),
              GestureDetector(
                onTap: (){
                  isSignUp ? signUp() : signIn();
                },
                child: Container(
                width: MediaQuery.of(context).size.width > 950 ? 450 : MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0XFF007DFE)
                  ),
                  child: Center(
                    child: Text(
                      isSignUp ? 'SignUp' : 'Login',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: () => setState(() {
                  isSignUp = !isSignUp;
                }),
                child: Text(
                  isSignUp ? 'Already having account' : 'I\'m new to BookMyTickets',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline, decorationColor: Color(0XFFFFFFFF), decorationThickness: 5),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty

import 'dart:convert';

import 'package:bookmytickets/models/MovieDetail.dart';
import 'package:bookmytickets/screens/BookingPage.dart';
import 'package:bookmytickets/screens/History.dart';
import 'package:bookmytickets/screens/LoginPage.dart';
import 'package:bookmytickets/widgets/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchMovies();
  }

  List<MovieDetail> movieList = [];
  bool isLoading = true;
  int highLightIndex = 10;

  Future<void> fetchMovies() async{
    String url = 'https://vercel-test-pi-seven.vercel.app/movies';
    await http.get(Uri.parse(url)).then((resp){
      if(resp.statusCode == 200){
        var data = jsonDecode(resp.body);
        data = data['data'];
        if(data.length != 0){
          for(var movie in data){
            String temp = movie['Released'];
            DateTime dt = DateTime(int.parse(temp.split('-')[2]), int.parse(temp.split('-')[1]), int.parse(temp.split('-')[0]));
            movieList.add(
              MovieDetail(movie['Title'], movie['Poster'], movie['cover'], dt, movie['Year'], movie['Plot'], movie['Actors'], movie['Ratings'][0]['Value'], movie['Theatre Location'], movie['Theatre Name'])
            );
          }
        }
      }
    }).then((value){
      movieList.sort((a, b) => a.released.compareTo(b.released));
      setState(() {
        movieList = movieList;
        isLoading = false;
      });
    });
  }

  String selectedDate = '';
  String selectedTime = '';
  int selectedDateIndex = -1;
  int selectedTimeIndex = -1;

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Date and Time'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Select your show date'),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        GestureDetector(onTap: () => setState((){selectedDateIndex = 0; selectedDate = '03-09-2023';}), child: Chip(backgroundColor: selectedDateIndex == 0 ?Colors.greenAccent : Colors.grey, label: Text('03-09-2023', style: normalTxt.copyWith(fontSize: 14, color: Colors.black),))),
                        SizedBox(width: 15,),
                        GestureDetector(onTap: () => setState((){selectedDateIndex = 1; selectedDate = '04-09-2023';}), child: Chip(backgroundColor: selectedDateIndex == 1 ?Colors.greenAccent : Colors.grey, label: Text('04-09-2023', style: normalTxt.copyWith(fontSize: 14, color: Colors.black),))),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Text('Select your show date'),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        GestureDetector(onTap: () => setState((){selectedTimeIndex = 0;selectedTime = '10';}), child: Chip(backgroundColor: selectedTimeIndex == 0 ?Colors.greenAccent : Colors.grey, label: Text('10 AM', style: normalTxt.copyWith(fontSize: 14, color: Colors.black),))),
                        SizedBox(width: 10,),
                        GestureDetector(onTap: () => setState((){selectedTimeIndex = 1;selectedTime = '14';}), child: Chip(backgroundColor: selectedTimeIndex == 1 ?Colors.greenAccent : Colors.grey, label: Text('2 PM', style: normalTxt.copyWith(fontSize: 14, color: Colors.black),))),
                        SizedBox(width: 10,),
                        GestureDetector(onTap: () => setState((){selectedTimeIndex = 2;selectedTime = '18';}), child: Chip(backgroundColor: selectedTimeIndex == 2 ?Colors.greenAccent : Colors.grey, label: Text('6 PM', style: normalTxt.copyWith(fontSize: 14, color: Colors.black),))),
                        SizedBox(width: 10,),
                        GestureDetector(onTap: () => setState((){selectedTimeIndex = 3;selectedTime = '22';}), child: Chip(backgroundColor: selectedTimeIndex == 3 ?Colors.greenAccent : Colors.grey, label: Text('10 PM', style: normalTxt.copyWith(fontSize: 14, color: Colors.black),))),
                        SizedBox(width: 10,),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Continue'),
                  onPressed: () {
                    if(selectedDate != '' && selectedDateIndex != -1 &&  selectedTime != '' && selectedTimeIndex != -1){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage(theatreName: movieList[highLightIndex].theatreName, datetime: selectedDate + ' at ' + selectedTime)));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          elevation: 15,
                          width: MediaQuery.of(context).size.width * 0.6,
                          content: Text(
                            'Please Select Show Date and Show Time',
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
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading ? Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator(),),) : 
        SingleChildScrollView(
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(movieList[highLightIndex].cover),
                  fit: BoxFit.cover
                )
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
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.22,
                  ),
                  Text(
                    movieList[highLightIndex].name + " (" + movieList[highLightIndex].year + ")",
                    style: normalTxt.copyWith(fontSize: 20),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.45 : MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      movieList[highLightIndex].description.substring(0, movieList[highLightIndex].description.length > 200 ? 200: movieList[highLightIndex].description.length) + "....",
                      style: normalTxt.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.35 : MediaQuery.of(context).size.width * 0.75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Starring As:\t\t\t",
                          style: normalTxt.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        if(MediaQuery.of(context).size.width > 600) Expanded(
                          child: Text(
                            movieList[highLightIndex].actors,
                            style: normalTxt.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(MediaQuery.of(context).size.width < 600) SizedBox(
                    width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.35 : MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      movieList[highLightIndex].actors,
                      style: normalTxt.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Row(
                    children: [
                      Chip(
                        backgroundColor: Colors.green,
                        surfaceTintColor: Colors.green,
                        label: Row(
                          children: [
                            Icon(Icons.schedule, color: Colors.white,),SizedBox(width: 10,),
                            Text(
                              movieList[highLightIndex].released.day.toString() + " - " + movieList[highLightIndex].released.month.toString() + " - " + movieList[highLightIndex].released.year.toString(),
                              style: normalTxt.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20,),
                      Chip(
                        backgroundColor: Colors.green,
                        surfaceTintColor: Colors.green,
                        label: Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.pink.shade300,),SizedBox(width: 10,),
                            Text(
                              movieList[highLightIndex].ratings,
                              style: normalTxt.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Chip(
                        backgroundColor: Colors.green,
                        surfaceTintColor: Colors.green,
                        label: Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.red, size: 20,),
                            SizedBox(width: 10,),
                            Text(
                              movieList[highLightIndex].theatreName+ ", " + movieList[highLightIndex].theatreLocation,
                              style: normalTxt.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                    onTap: showAlertDialog,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        'Book Now',
                        style: normalTxt.copyWith(fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Row(
                    children: [
                      Text(
                        'Home', style: normalTxt.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      SizedBox(width: 30,),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingHistory())),
                        child: Text(
                          'Bookings', style: normalTxt.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.clear().then((value) async{
                            await FirebaseAuth.instance.signOut().then((value){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  elevation: 15,
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  content: Text(
                                    'Logged Out Successfully',
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
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade600,
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text(
                            'Logout',
                            style: normalTxt.copyWith(fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.6,),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: movieList.length,
                    itemBuilder: (context, index) {
                      print(index);
                      return GestureDetector(
                        onTap: () => setState(() {
                          highLightIndex = index;
                        }),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                AnimatedContainer(
                                  curve: Curves.easeInOut,
                                  height: highLightIndex == index ? 300 : 200,
                                  width: highLightIndex == index ? 250 : 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(image: NetworkImage(movieList[index].poster), fit: BoxFit.cover)
                                  ), duration: Duration(seconds: 1),
                                ),
                                SizedBox(width: 15,)
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text(
                              movieList[index].name,
                              style: normalTxt.copyWith(fontSize: 14),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              movieList[index].year,
                              style: normalTxt.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height,
                //   width: MediaQuery.of(context).size.width,
                //   child: Container(
                //     decoration: BoxDecoration(),
                //   ),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
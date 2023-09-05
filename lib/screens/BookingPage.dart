// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bookmytickets/widgets/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class BookingPage extends StatefulWidget {
  final String theatreName;
  final String datetime;
  const BookingPage({super.key, required this.theatreName, required this.datetime});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSeats();
  }

  Map<int, bool> booked = {}; 
  bool isLoading = true;

  Future<void> setSeats() async{
    for(int i = 0; i < 70; i++){selectedSeats.add(-1);}
    FirebaseFirestore.instance.collection('theatres').doc(widget.theatreName).collection('dates').doc(widget.datetime).get().then((value){
      if(value.data() != null){
        for (var seat in value.data()!.keys) {
          booked[int.parse(seat.toString())] = value.data()![seat];
          if(value.data()![seat] == true){
            selectedSeats[int.parse(seat.toString())] = 1;
          }else{
            selectedSeats[int.parse(seat.toString())] = 0;
          }
        }
      }
    }).then((value){
      setState(() {
        isLoading = false;
      });
    });
  }

  List<int> selectedSeats = [];

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Seats'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Confirm Seat Bookings? This cannot be undone.'),
                    SizedBox(height: 15,),
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
                  child: const Text('Confirm'),
                  onPressed: () {
                    List<int> selectedByUser = [];
                    for (var i = 0; i < 70; i++) {
                      if(selectedSeats[i] == 2){
                        selectedByUser.add(i);
                      }
                    }
                    if(selectedByUser.length != 0){
                      Map<String, bool> updateMap = {};
                      for(int i in selectedByUser){
                        updateMap[i.toString()] = true;
                      }
                      String ts = DateTime.timestamp().millisecondsSinceEpoch.toInt().toString();
                      FirebaseFirestore.instance.collection('theatres').doc(widget.theatreName).collection('dates').doc(widget.datetime).update(updateMap).then((value){
                        FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('bookings').doc(ts).set({
                          'bookingId' : ts,
                          'seats' : selectedByUser,
                          'bookedAt' : DateTime.now().toString()
                        }).then((value) async{
                            String url = 'https://vercel-test-pi-seven.vercel.app/mail';
                            await http.get(Uri.parse(url));
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                elevation: 15,
                                width: MediaQuery.of(context).size.width * 0.6,
                                content: Text(
                                  'Successfully Booked Tickets. Thank You',
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
      body: isLoading ? Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator(),),) : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 15,),
                GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: Colors.black, size: 30,)),
                SizedBox(width: 30,),
                Text(
                  'Confirm Tickets',
                  style: normalTxt.copyWith(fontSize: 18, color: Colors.black),
                )
              ],
            ),
            SizedBox(height: 50,),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.75,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1
                ),
                itemCount: selectedSeats.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: () => setState(() {
                      if(selectedSeats[index] != 1){
                        setState(() {
                          selectedSeats[index] = selectedSeats[index] == 2 ? 0 : 2;
                        });
                      }
                      print("Selected "+ index.toString());
                    }),
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedSeats[index] == 0 ? Colors.black : Colors.grey,
                          width: selectedSeats[index] == 0 ? 2 : 0.5
                        ),
                        color: selectedSeats[index] == 1 ? Colors.grey : selectedSeats[index] == 2 ?Colors.green : Colors.white
                      ),
                    ),
                  );
                }
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.75,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Booked',
                    style: normalTxt.copyWith(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    width: 30,
                    height: 30,
                    color: Colors.green,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Selected',
                    style: normalTxt.copyWith(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(width: 30,),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2
                      ),
                      color: Colors.white
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Available',
                    style: normalTxt.copyWith(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(width: 30,),
                ],
              ),
            ),
            SizedBox(height: 30,),
            SizedBox(
              width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width * 0.4 : MediaQuery.of(context).size.width * 0.75,
              child: Center(
                child: GestureDetector(
                  onTap: showAlertDialog,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      'Confirm Tickets',
                      style: normalTxt.copyWith(fontSize: 15),
                    ),
                  ),
                ),
              )
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}
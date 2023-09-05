// ignore_for_file: prefer_is_empty, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bookmytickets/widgets/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingHistory extends StatefulWidget {
  const BookingHistory({super.key});

  @override
  State<BookingHistory> createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistory();
  }

  bool isLoading = true;
  List<String> bookingId = [];
  List<String> bookedAt = [];
  List<String> seats = [];

  Future<void> getHistory() async{
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('bookings').get().then((value){
      if(value.docs.length != 0){
        for (var data in value.docs) {
          bookingId.add(data['bookingId']);
          bookedAt.add(data['bookedAt']);
          String s = '';
          for (var i in data['seats']) {
            s += i.toString() + ", ";
          }
          seats.add(s);
        }
      }
    }).then((value){
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(child: SizedBox(width: 50, height: 50, child: CircularProgressIndicator(),),) : 
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                SizedBox(width: 15,),
                GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: Colors.black, size: 30,)),
                SizedBox(width: 30,),
                Text(
                  'Booking History',
                  style: normalTxt.copyWith(fontSize: 18, color: Colors.black),
                )
              ],
            ),
            SizedBox(height: 50,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(height: 30,),
                itemCount: bookingId.length,
                itemBuilder: (context, index){
                  return SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Text(
                          "Booking ID:\t\t\t" + bookingId[index].toString() + '\nBooked At:\t\t\t' + bookedAt[index] + '\nSeats Booked:t\t\t' + seats[index] + '\n'
                        ),
                        Spacer(),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: QrImageView(
                            data: bookingId[index],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
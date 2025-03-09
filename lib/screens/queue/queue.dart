import 'package:chat/models/restaurants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationScreen extends StatefulWidget {
  final String restaurantName;

  ReservationScreen({required this.restaurantName});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? _selectedDateTime;
  int? _guestCount;
  int _selectedTable = 1; // Default to table 1

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> _addToQueue() async {
    try {
      if (_selectedDateTime == null || _guestCount == null) {
        throw Exception("Please select a date, time, and guest count");
      }

      final user = FirebaseAuth.instance.currentUser!;
      final userDataSnapshot =
          await _firestore.collection('user').doc(user.uid).get();
      if (!userDataSnapshot.exists) {
        throw Exception("User data not found");
      }
      final userData = userDataSnapshot.data()!;

      // ดึงวันที่ของการจอง
      final selectedDate = DateTime(_selectedDateTime!.year,
          _selectedDateTime!.month, _selectedDateTime!.day);

      final tableNumber = _selectedTable;

      // Query documents by 'date' only (without 'timestamp' for now)
      final tableReservationsSnapshot = await _firestore
          .collection('restaurants')
          .doc(widget.restaurantName)
          .collection('tables')
          .doc('table$tableNumber')
          .collection('Reservations')
          .where('date', isEqualTo: selectedDate.toString())
          .get();

      // Sort the documents by 'timestamp' after fetching
      List<QueryDocumentSnapshot> sortedDocs = tableReservationsSnapshot.docs;
      sortedDocs.sort((a, b) {
        final timeA = (a['timestamp'] as Timestamp).toDate();
        final timeB = (b['timestamp'] as Timestamp).toDate();
        return timeA.compareTo(timeB); // Sort in ascending order of timestamp
      });

      // Now check for conflicts
      for (var doc in sortedDocs) {
        final existingReservationTime =
            (doc['timestamp'] as Timestamp).toDate();

        if (_selectedDateTime!
                .isBefore(existingReservationTime.add(Duration(hours: 1))) &&
            _selectedDateTime!.isAfter(
                existingReservationTime.subtract(Duration(hours: 1)))) {
          throw Exception(
              "This time is already reserved. Please choose another time.");
        }
      }

      // Continue with adding the reservation to the queue...
      final queueNumber = sortedDocs.length + 1;
      final reservationId = DateTime.now().millisecondsSinceEpoch.toString();

      // Add the new reservation
      await _firestore
          .collection('restaurants')
          .doc(widget.restaurantName)
          .collection('tables')
          .doc('table$tableNumber')
          .collection('Reservations')
          .doc(reservationId)
          .set({
        'guestCount': _guestCount,
        'timestamp': Timestamp.fromDate(_selectedDateTime!),
        'userId': user.uid,
        'username': userData['username'],
        'queueNumber': queueNumber,
        'date': selectedDate.toString(),
        "resName": widget.restaurantName,
        "tableNum": tableNumber,
        'status': false,
      });

      // Add the reservation to the user's current queue as well
      await _firestore
          .collection('user')
          .doc(user.uid)
          .collection("current queue")
          .doc(reservationId)
          .set({
        'guestCount': _guestCount,
        'timestamp': Timestamp.fromDate(_selectedDateTime!),
        'userId': user.uid,
        'username': userData['username'],
        'queueNumber': queueNumber,
        'date': selectedDate.toString(),
        "resName": widget.restaurantName,
        "tableNum": tableNumber,
        'status': false,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation added to queue')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add reservation: ${e.toString()}')),
      );
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (time != null) {
        final selectedDateTime = DateTime(
          selected.year,
          selected.month,
          selected.day,
          time.hour,
          time.minute,
        );

        // กำหนดเวลาเปิดร้านและปิดร้าน
        final openingTime = DateTime(selectedDateTime.year,
            selectedDateTime.month, selectedDateTime.day, 8, 0); // 8:00 AM
        final closingTime = DateTime(selectedDateTime.year,
            selectedDateTime.month, selectedDateTime.day, 21, 0); // 9:00 PM

        // ตรวจสอบว่าเวลาอยู่ระหว่างช่วงเวลาเปิดร้านหรือไม่
        if (selectedDateTime.isBefore(openingTime) ||
            selectedDateTime.isAfter(closingTime)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'The restaurant is only open between 8:00 AM and 9:00 PM.')),
          );
        } else {
          setState(() {
            _selectedDateTime = selectedDateTime;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ส่วนของการเลือกโต๊ะ
            DropdownButton<int>(
              value: _selectedTable,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedTable = newValue!;
                });
              },
              items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('Table $value'),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // ส่วนของการเลือกวันที่และเวลา
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text(
                _selectedDateTime == null
                    ? 'Select Date & Time'
                    : 'Selected: ${_selectedDateTime!.toLocal()}',
              ),
            ),
            SizedBox(height: 16),

            // ส่วนของการเลือกจำนวนผู้เข้าร่วม
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Guest Count'),
              onChanged: (value) {
                setState(() {
                  _guestCount = int.tryParse(value);
                });
              },
            ),
            SizedBox(height: 16),

            // ปุ่มจองโต๊ะ
            ElevatedButton(
              onPressed: _addToQueue,
              child: Text('Book Table'),
            ),
          ],
        ),
      ),
    );
  }
}

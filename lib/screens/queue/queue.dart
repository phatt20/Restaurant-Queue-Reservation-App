import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QueueTest extends StatefulWidget {
  final String restaurantName; // รับชื่อร้านเป็น constructor parameter
  const QueueTest({Key? key, required this.restaurantName}) : super(key: key);

  @override
  State<QueueTest> createState() => _QueueState();
}

class _QueueState extends State<QueueTest> {
  final _formKey = GlobalKey<FormState>();
  int? _guestCount;
  DateTime? _selectedDateTime;
  bool _isLoading = false;

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

      // ดึงข้อมูลการจองทั้งหมดของผู้ใช้ในช่วงเวลาที่ต้องการ
      final bookingsSnapshot = await _firestore
          .collection('user')
          .doc(user.uid)
          .collection("current queue")
          .orderBy('timestamp', descending: true) // เรียงตามเวลาการจอง
          .get();

      // ตรวจสอบการจองซ้อนทับในช่วงเวลา 1 ชั่วโมงก่อนและหลัง
      for (var booking in bookingsSnapshot.docs) {
        final bookingTime = (booking['timestamp'] as Timestamp).toDate();

        // ตรวจสอบว่าเวลาที่ต้องการจองซ้อนทับกับการจองที่มีอยู่หรือไม่
        final minTimeDifference = Duration(minutes: 60); // 1 ชั่วโมง
        final beforeBooking = bookingTime.subtract(minTimeDifference);
        final afterBooking = bookingTime.add(minTimeDifference);

        // ถ้าการจองใหม่ซ้อนทับกับการจองที่มีอยู่
        if (_selectedDateTime!.isBefore(afterBooking) &&
            _selectedDateTime!.isAfter(beforeBooking)) {
          throw Exception("Cannot book within 1 hour of the last booking");
        }
      }

      // บันทึกการจองใหม่
      await _firestore
          .collection('Queue')
          .doc(widget.restaurantName)
          .collection("Current_Queue")
          .add({
        'guestCount': _guestCount,
        'timestamp': Timestamp.fromDate(_selectedDateTime!),
        'userId': user.uid,
        'username': userData['username'],
      });

      await _firestore
          .collection('user')
          .doc(user.uid)
          .collection('current queue')
          .add({
        'guestCount': _guestCount,
        'timestamp': Timestamp.fromDate(_selectedDateTime!),
        'userId': user.uid,
        'username': userData['username'],
        'restaurantName': widget.restaurantName,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Queue Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'Guest Count',
                  border: OutlineInputBorder(),
                ),
                value: _guestCount,
                onChanged: (value) {
                  setState(() {
                    _guestCount = value;
                  });
                },
                items: List.generate(10, (index) {
                  int guests = index + 1;
                  return DropdownMenuItem<int>(
                    value: guests,
                    child: Text('$guests Guests'),
                  );
                }),
                validator: (value) {
                  if (value == null) {
                    return 'Please select the number of guests';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 30)),
                  );
                  if (picked != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedDateTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Text(_selectedDateTime == null
                    ? 'Select Date & Time'
                    : 'Selected: ${_selectedDateTime.toString()}'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          _addToQueue().then((_) {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        }
                      },
                child: const Text('Reserve'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

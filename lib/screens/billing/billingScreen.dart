import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BillScreen extends StatelessWidget {
  const BillScreen({super.key});

  // ดึงข้อมูลประวัติการจองทั้งหมดจาก Firestore โดยใช้ userId จาก Firebase Authentication
  Stream<List<Map<String, dynamic>>> _getAllBookings(String userId) {
    return FirebaseFirestore.instance
        .collection('user') // คอลเลกชันผู้ใช้
        .doc(userId) // ใช้ userId ของผู้ใช้
        .collection('history') // คอลเลกชันประวัติการจอง
        .snapshots()
        .map((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      return querySnapshot.docs.map((doc) {
        return {
          'guestCount':
              doc['guestCount'] ?? 0, // ค่า default หากไม่มี guestCount
          'timestamp': doc['timestamp']?.toDate() ??
              DateTime.now(), // ค่า default หากไม่มี timestamp
          'userId': doc['userId'] ?? '', // ค่า default หากไม่มี userId
          'resName': doc['resName'] ??
              'ไม่ทราบชื่อร้าน', // ค่า default หากไม่มี restaurantName
          'status': doc['status'] ?? 'failed', // ตรวจสอบสถานะการจอง
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('กรุณาล็อกอินเพื่อดูประวัติการจอง'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ประวัติการจอง (History)"),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // ฟังก์ชันในการรีเฟรชข้อมูล
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          // ใช้ StreamBuilder เพื่อรับข้อมูลสดจาก Firestore
          stream: _getAllBookings(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              debugPrint("Error: ${snapshot.error}");
              return const Center(child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('ไม่มีประวัติการจอง'));
            } else {
              final bookings = snapshot.data!;
              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  var booking = bookings[index];
                  var timestamp = booking['timestamp'] as DateTime;
                  var formattedDate =
                      '${timestamp.day}/${timestamp.month}/${timestamp.year} เวลา ${timestamp.hour}:${timestamp.minute}';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 10,
                      shadowColor: Colors.blue.shade200,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'ร้าน: ${booking['resName']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  booking['status'] == 'failed'
                                      ? Icons.cancel
                                      : Icons.check_circle,
                                  color: booking['status'] == 'failed'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'จำนวนผู้เข้าร่วม: ${booking['guestCount']} คน',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'วันที่จอง: $formattedDate',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Divider(
                              thickness: 1.5,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

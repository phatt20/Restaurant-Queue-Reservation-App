import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  // ฟังก์ชันเพื่อดึงข้อมูลของผู้ใช้จาก Firestore
  Future<DocumentSnapshot> _getUserData(String userId) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // ดึงข้อมูลผู้ใช้ที่ล็อกอิน

    if (user == null) {
      return const Center(child: Text('กรุณาล็อกอินเพื่อดูข้อมูล'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ข้อมูลผู้ใช้ (User Management)"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getUserData(user.uid), // ดึงข้อมูลผู้ใช้จาก Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('เกิดข้อผิดพลาดในการดึงข้อมูล'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('ไม่พบข้อมูลผู้ใช้'));
          } else {
            var userData = snapshot.data!;
            var email = userData['email'];
            var username = userData['username'];
            var imageUrl = userData['image_url'];

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // แสดงรูปโปรไฟล์
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    const SizedBox(height: 20),
                    // แสดงชื่อผู้ใช้
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // แสดงอีเมล
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

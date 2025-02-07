import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ข้อมูลการจองคิวร้านอาหาร"),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ชื่อหัวข้อ
              Text(
                "แอปจองคิวร้านอาหาร",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              // ข้อมูลเบื้องต้นเกี่ยวกับแอป
              Text(
                "แอปนี้เป็นแอปสำหรับ **จองคิวร้านอาหาร** ที่จะช่วยให้การจองคิวสะดวกและรวดเร็วขึ้น ไม่ต้องเสียเวลาในการรอคิวนานๆ โดยสามารถเลือกจองคิวล่วงหน้าที่ร้านอาหารต่างๆ ได้ผ่านแอป ทำให้การเลือกและจองที่นั่งสำหรับทานอาหารเป็นเรื่องง่ายและสะดวกมากขึ้น",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              // ร้านอาหารที่สามารถจองคิวได้
              Text(
                "ร้านอาหารที่สามารถจองคิวได้ในแอปนี้:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "1. Mac\n- มีบริการจองคิวออนไลน์ที่สามารถจองล่วงหน้าได้\n- เสิร์ฟเมนูอาหารไทยคุณภาพ พร้อมบริการที่ดี\n- ที่อยู่: ย่านใจกลางเมือง",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              // ภาพร้าน
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://th.bing.com/th/id/OIP.F48Ta-u-I74gaRY18l_8sAHaE8?rs=1&pid=ImgDetMain', // ลิงก์ภาพร้าน
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              // ข้อมูลการจองคิว
              Text(
                "ข้อมูลการจองคิว",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 10),
              _buildBookingInformation("1", "วันนี้ 12:00 PM", 4),
              const SizedBox(height: 15),
              _buildBookingInformation("2", "วันนี้ 7:00 PM", 2),
              const SizedBox(height: 20),
              // การติดต่อร้าน
              Text(
                "การติดต่อร้าน",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green.shade700),
                  const SizedBox(width: 10),
                  Text(
                    "โทร: 02-123-4567",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.green.shade700),
                  const SizedBox(width: 10),
                  const Text(
                    "เวลาทำการ: 10:00 AM - 10:00 PM",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget สำหรับแสดงข้อมูลการจอง
  Widget _buildBookingInformation(
      String queueNumber, String reservationTime, int guestCount) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "หมายเลขคิว: $queueNumber",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "เวลา: $reservationTime",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "จำนวนผู้จอง: $guestCount คน",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

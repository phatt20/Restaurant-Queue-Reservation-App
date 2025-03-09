import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Listscreen extends StatefulWidget {
  const Listscreen({super.key});

  @override
  State<Listscreen> createState() => _ListscreenState();
}

class _ListscreenState extends State<Listscreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("คิวของฉัน"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('user')
            .doc(user.uid)
            .collection("current queue")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("ไม่มีคิวที่จอง"));
          }

          var reservations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              var reservation = reservations[index];
              var data = reservation.data() as Map<String, dynamic>;

              String restaurantName = data.containsKey('restaurantName')
                  ? data['restaurantName']
                  : "MAC";
              int queueNumber =
                  data.containsKey('queueNumber') ? data['queueNumber'] : 0;
              String status = data.containsKey('status')
                  ? (data['status'] == false ? "รอเช็ดอิน" : "เช็คอินเเล้ว")
                  : "รอเช็ดอิน";

              return GestureDetector(
                onTap: () {
                  _showReservationDetails(context, data, reservation.id);
                },
                child: Card(
                  elevation: 8, // เงาของ Card
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // ขอบโค้งมน
                  ),
                  color: Colors.white,
                  shadowColor: Colors.black.withOpacity(0.3), // สีเงาของ Card
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade50, Colors.orange.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: Icon(
                        Icons.restaurant,
                        color: Colors.orange.shade700,
                      ),
                      title: Text(
                        "ร้าน: $restaurantName",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.deepOrange,
                        ),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: status == "รอเช็คอิน"
                              ? Colors.orange.shade200
                              : Colors.green.shade200,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: status == "รอเช็คอิน"
                                ? Colors.orange
                                : Colors.green,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              color: status == "รอเช็คอิน"
                                  ? Colors.orange
                                  : Colors.green,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              status,
                              style: TextStyle(
                                color: status == "รอเช็คอิน"
                                    ? Colors.orange
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showReservationDetails(
      BuildContext context, Map<String, dynamic> data, String reservationId) {
    String restaurantName = data['restaurantName'] ?? "MAC";
    String status = data.containsKey('status')
        ? (data['status'] is bool
            ? (data['status'] == true ? "เช็คอินเเล้ว" : "รอเช็คอิน")
            : data['status'])
        : "รอเช็คอิน";

    int guestCount = data['guestCount'] ?? 0;
    int queueNum = data["queueNumber"] ?? 0;
    String timestamp = data['timestamp']?.toDate().toString() ?? "ไม่ทราบเวลา";
    String userId = data['userId'] ?? "ไม่ระบุ";
    String username = data['username'] ?? "ไม่ระบุ";

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "https://cdn.pixabay.com/photo/2014/09/17/20/26/restaurant-449952_640.jpg",
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("ร้าน: $restaurantName",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    "สถานะ: $status",
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          status == "รอเช็คอิน" ? Colors.orange : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("จำนวนผู้ทาน:  $guestCount",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  Text(
                    "คิวที่:  $queueNum ของวันที่ ${DateFormat('dd/MM/yyyy').format(DateTime.parse(timestamp))}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text("เวลาที่จอง:  $timestamp",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  Text("ผู้จอง:  $username",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            backgroundColor: Colors.blue.shade700,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Close",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (status == "รอเช็คอิน") ...[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                              backgroundColor: Colors.green.shade700,
                            ),
                            onPressed: () {
                              _confirmReservation(context, reservationId, data);
                            },
                            child: const Text(
                              "เช็คอินเเล้ว",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            backgroundColor: Colors.red.shade700,
                          ),
                          onPressed: () {
                            _cancelReservation(context, reservationId, data);
                          },
                          child: const Text(
                            "ยกเลิกการจอง",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmReservation(BuildContext context, String reservationId,
      Map<String, dynamic> data) async {
    final user = _auth.currentUser!;

    try {
      // อัปเดตสถานะการจองในคอลเล็กชัน 'current queue' ของผู้ใช้
      await _firestore
          .collection('user')
          .doc(user.uid)
          .collection("current queue")
          .doc(reservationId)
          .update({
        'status': 'เช็คอินเเล้ว', // เปลี่ยนสถานะเป็น 'เช็คอินเเล้ว'
      });

      // ย้ายข้อมูลไปยังประวัติการจอง
      await _firestore
          .collection('user')
          .doc(user.uid)
          .collection("history")
          .doc(reservationId)
          .set(data);

      // ลบข้อมูลการจองจากคิวปัจจุบัน
      await _firestore
          .collection('user')
          .doc(user.uid)
          .collection("current queue")
          .doc(reservationId)
          .delete();

      // ใช้ข้อมูลร้านอาหารจาก `data`
      String restaurantName = data['resName'];
      int queueNumber = data['queueNumber'];

      // อัปเดตสถานะการจองในคอลเล็กชัน 'Reservations' ของร้านอาหาร
      await _firestore
          .collection('restaurants')
          .doc(restaurantName) // ใช้ชื่อร้านจาก `resName`
          .collection('tables')
          .doc('table$queueNumber') // ใช้หมายเลขคิวเป็นตัวระบุ
          .collection('Reservations')
          .doc(reservationId) // ระบุตัว ID ของการจองที่ต้องการอัปเดต
          .update({
        'status': 'เช็คอินเเล้ว', // เปลี่ยนสถานะเป็น 'เช็คอินเเล้ว'
      });

      // แสดงข้อความ SnackBar เมื่อสำเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("เช็คอินเเล้วการจองเรียบร้อยแล้ว")),
      );

      // กลับไปหน้าก่อนหน้า
      Navigator.of(context).pop();
    } catch (e) {
      // แสดงข้อความเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
      );
    }
  }

  void _cancelReservation(BuildContext context, String reservationId,
      Map<String, dynamic> data) async {
    final user = _auth.currentUser!;

    try {
      // ย้ายข้อมูลไปยังประวัติการจอง
      await _firestore
          .collection('user')
          .doc(user.uid)
          .collection("history")
          .doc(reservationId)
          .set(data);

      // ลบข้อมูลการจองจากคิวปัจจุบัน
      await _firestore
          .collection('user')
          .doc(user.uid)
          .collection("current queue")
          .doc(reservationId)
          .delete();

      // ลบการจองในร้านอาหารที่เกี่ยวข้อง
      String restaurantName = data['resName']; // ใช้ข้อมูลร้านอาหารจาก `data`
      int queueNumber = data['queueNumber']; // ใช้หมายเลขคิวจากข้อมูล

      // ลบเอกสาร (document) ที่ตรงกับ reservationId ในคอลเล็กชัน Reservations ของร้านอาหาร
      await _firestore
          .collection('restaurants')
          .doc(restaurantName) // ใช้ชื่อร้านจาก `resName`
          .collection('tables')
          .doc('table$queueNumber') // ใช้หมายเลขคิวเป็นตัวระบุ
          .collection('Reservations')
          .doc(reservationId) // ระบุตัว ID ของการจองที่ต้องการลบ
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ยกเลิกการจองเรียบร้อยแล้ว")),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
      );
    }
  }
}

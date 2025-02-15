import 'package:chat/screens/chat/chat.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, String>> chatList = [
    {
      "name": "Mac",
      "message": "Hello! How are you?",
      "avatar":
          "https://th.bing.com/th/id/OIP.kjXliNp6y5Bjlmo4stafCAHaHa?rs=1&pid=ImgDetMain"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: Padding(
        padding: const EdgeInsets.all(10.0), // เพิ่ม Padding ด้านนอก
        child: ListView.builder(
          itemCount: chatList.length,
          itemBuilder: (context, index) {
            final chat = chatList[index];
            return Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 8.0), // ระยะห่างระหว่างรายการ
              decoration: BoxDecoration(
                color: Colors.white, // พื้นหลังสีขาว
                borderRadius: BorderRadius.circular(12.0), // ขอบโค้งมน
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // เงาสีเทาอ่อน
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // เงาแนวตั้ง
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chat["avatar"]!),
                ),
                title: Text(
                  chat["name"]!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(chat["message"]!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

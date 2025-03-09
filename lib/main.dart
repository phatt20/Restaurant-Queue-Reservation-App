import 'package:chat/screens/auth/auth.dart';
import 'package:chat/screens/bottom_tap/bottom_tapscreen.dart';
import 'package:chat/splash/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurants',
      theme: ThemeData().copyWith(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 251, 0)),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme.copyWith(
                bodyLarge: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                bodyMedium: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                bodySmall: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return const BottomTapscreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}























// //context เป็นวัตถุที่ใช้ในการอ้างอิงถึง widget tree ของ Flutter และช่วยให้ widget สามารถสื่อสารกับ ancestor widget หรือเข้าถึงข้อมูลต่าง ๆ ที่จำเป็น
// context มีความสำคัญในการจัดการและเข้าถึงทรัพยากรของแอป รวมถึงการนำทาง, การใช้ Theme, การจัดการ State, และการทำงานกับ Inherited Widgets




// ความหมายของ State ใน Flutter
// State คือข้อมูลที่เปลี่ยนแปลงได้ในแอป เช่น ข้อความที่ผู้ใช้กรอก, ตำแหน่งของปุ่มที่ถูกกด, หรือการโหลดข้อมูลจากอินเทอร์เน็ต
// State สามารถแบ่งออกเป็น:
// Ephemeral State (Local State): State ที่จัดการได้ง่าย ๆ ใน widget เดียว เช่น ค่า input ของ TextField
// App State (Global State): State ที่ใช้ร่วมกันในหลาย ๆ ส่วนของแอป เช่น ข้อมูลผู้ใช้ที่ล็อกอิน หรือการตั้งค่า theme ของแอป
import 'package:flutter/material.dart';

class TapButtonUi extends StatelessWidget {
  const TapButtonUi({
    super.key, // ใส่ key และตรวจสอบว่ามีการรับค่าและไม่ใช่ null
    required this.icon,
    required this.onTap,
    required this.isSelected,
    required this.text,
  }); // เพิ่ม super(key: key);

  final IconData icon;
  final Function()? onTap;
  final bool isSelected;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? const Color.fromARGB(255, 20, 130, 219) : Colors.grey;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
          onTap: onTap ??
              () {}, // ตรวจสอบว่า onTap ไม่ใช่ null ก่อนที่จะเรียกใช้งาน
          child: Column(
            children: [
              const SizedBox(
                height: 4,
              ),
              SizedBox(
                width: 40,
                height: 32,
                child: Icon(
                  icon,
                  size: 26,
                  color: color,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:chat/models/restaurants.dart';
import 'package:chat/screens/home/title_view.dart';
import 'package:chat/screens/restaurantDetail/categoriUptoDown.dart';
import 'package:chat/widgets/common_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ratingview extends StatelessWidget {
  final AnimationController animationController;
  final Restaurants restData;
  final FoodDtail fooddata;
  const Ratingview({
    super.key,
    required this.restData,
    required this.animationController,
    required this.fooddata,
  });

  @override
  Widget build(BuildContext context) {
    double rating = restData.rating.toDouble(); // ใช้คะแนนจากข้อมูลร้าน
    double maxRating = 5.0; // กำหนดคะแนนสูงสุด

    return Column(
      children: [
        CommonCardState(
          radius: 16,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // แสดงคะแนนในตัวเลข และดาว
                Row(
                  children: [
                    // แสดงตัวเลขคะแนน
                    SizedBox(
                      width: 60,
                      child: Text(
                        rating.toStringAsFixed(1), // แสดงคะแนน
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSansThai(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // เว้นระยะห่าง
                    // แสดงดาว
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 30, // ขนาดดาว
                    ),
                    Icon(
                      Icons.star,
                      color: rating >= 2 ? Colors.orange : Colors.grey,
                      size: 30,
                    ),
                    Icon(
                      Icons.star,
                      color: rating >= 3 ? Colors.orange : Colors.grey,
                      size: 30,
                    ),
                    Icon(
                      Icons.star,
                      color: rating >= 4 ? Colors.orange : Colors.grey,
                      size: 30,
                    ),
                    Icon(
                      Icons.star,
                      color: rating >= 5 ? Colors.orange : Colors.grey,
                      size: 30,
                    ),
                  ],
                ),
                // แถบคะแนน (rating bar)
                Row(
                  children: [
                    SizedBox(
                      width: 200, // กำหนดความกว้างของแถบคะแนน
                      child: Stack(
                        children: [
                          // แถบพื้นหลังสีเทา
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[300],
                            ),
                          ),
                          // แถบคะแนนที่แสดงเป็นสีน้ำเงิน
                          FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor:
                                rating / maxRating, // ใช้การคำนวณตามคะแนน
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue, // สีแถบคะแนน
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // แสดงหัวข้อ Popular Food
        TitleView(
            titleText: 'Popular Food',
            animationController: animationController,
            animation: animationController,
            click: () {},
            textColor: Colors.black),
        // แสดงข้อมูลรายการอาหาร
        CategoriuptodownSinggle(
          data: restData,
          isHotDeal: false,
          fooddata: fooddata,
        )
      ],
    );
  }
}

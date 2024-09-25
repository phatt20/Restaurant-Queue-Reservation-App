import 'package:chat/screens/home/rowdetail.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/restaurants.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriuptodownSinggle extends StatelessWidget {
  final Restaurants data;
  final FoodDtail fooddata;
  final bool isHotDeal;

  const CategoriuptodownSinggle({
    super.key,
    required this.data,
    required this.isHotDeal,
    required this.fooddata,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<void>(
            future: precacheImage(NetworkImage(data.imagePath), context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(
                    height: 40,
                    width: 40, // Placeholder size
                    child:
                        CircularProgressIndicator(), // Or any placeholder widget
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => Restaurantsdetail(
                    //         resdata: data, fooddata: fooddata),
                    //   ),
                    // );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      color: Colors.white,
                      height: 150,
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: SizedBox(
                                  width: 150,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.network(
                                      data.imagePath,
                                      fit: BoxFit.cover,
                                      height: 150,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data.titleTxt,
                                        style: GoogleFonts.notoSansThai(
                                          fontSize: 21,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Rowdetail(
                                        text: data.dataTxt,
                                        star: true,
                                        rating: data.rating.toString(),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isHotDeal)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: ClipPath(
                                clipper: TriangleClipper(),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(data.imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (isHotDeal)
                            Positioned(
                              bottom: 3,
                              right: 5,
                              child: Text(
                                '180 ',
                                style: GoogleFonts.getFont(
                                  'Lato',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

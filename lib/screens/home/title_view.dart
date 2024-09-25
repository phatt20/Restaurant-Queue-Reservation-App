import 'package:chat/screens/popular/popularscreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chat/models/restaurants.dart';

class TitleView extends StatelessWidget {
  final List<Restaurants>? data;
  final List<FoodDtail>? fooddata;

  final String titleText, subtext;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback click;
  final Color? textColor;
  final String? img;
  final Widget? screen;

  const TitleView({
    super.key,
    this.titleText = '',
    this.subtext = '',
    required this.animationController,
    required this.animation,
    required this.click,
    required this.textColor,
    this.img,
    this.data,
    this.fooddata,
    this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titleText,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: textColor ?? Colors.white,
                          shadows: [
                            Shadow(
                              offset: const Offset(1.0, 1.5),
                              blurRadius: 3.0,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (img != null)
                      ClipOval(
                        child: Container(
                          width: 40,
                          height: 40,
                          color: Colors.blueAccent,
                          child: Image.network(
                            img!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (data != null && fooddata != null)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    screen ??
                                    PopularScreen(
                                      data: data!,
                                      titleTxt: titleText,
                                      fooddata: fooddata!,
                                    ),
                              ),
                            );
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                Text(
                                  subtext,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'View All',
                                      style: GoogleFonts.lato(
                                        fontSize: 20,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.blueAccent,
                                      size: 25,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

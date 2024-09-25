import 'package:chat/screens/foodmenu.dart/foodmenu.dart';
import 'package:chat/screens/home/buttoncustom.dart';
import 'package:chat/screens/home/categori.dart';
import 'package:chat/screens/home/home_list_slider.dart';
import 'package:chat/screens/popular/popularscreen.dart';
import 'package:chat/widgets/bottom_top_move_animation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat/models/restaurants.dart'; // Import your Restaurants model
import 'package:chat/screens/home/title_view.dart'; // Assuming TitleView widget import
import 'package:chat/screens/home/categoriUptoDown.dart'; // Assuming Categoriuptodown widget import

class HomeScreen extends StatefulWidget {
  final AnimationController animationController;

  const HomeScreen({super.key, required this.animationController});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ScrollController controller;
  late AnimationController _animationController;
  double sliderImageHeight = 0.0;
  List<Restaurants> detailRes = [];
  List<Restaurants> bestdeal = [];
  List<FoodDtail> popularList = [];
  List<FoodDtail> sweetmenu = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    widget.animationController.forward();

    controller = ScrollController(initialScrollOffset: 0.0);
    controller.addListener(() {
      if (mounted) {
        if (controller.offset < 0) {
          _animationController.animateTo(0.0);
        } else if (controller.offset > 0.0 &&
            controller.offset < sliderImageHeight) {
          if (controller.offset < (sliderImageHeight / 1.5)) {
            _animationController
                .animateTo((controller.offset / sliderImageHeight));
          } else {
            _animationController
                .animateTo(((sliderImageHeight / 1.5) / sliderImageHeight));
          }
        }
      }
    });
  }

  // Future<void> _fetchData() async {
  //   try {
  //     var popularFood = await FirebaseFirestore.instance
  //         .collection('restaurants_all')
  //         .doc("restaurants_01")
  //         .collection("popular_food")
  //         .get();
  //     popularList = popularFood.docs.map((doc) {
  //       var docData = doc.data();
  //       return FoodDtail(
  //           imagePath: docData['imagePath'] ?? '',
  //           titleTxt: docData['titleTxt'] ?? '');
  //     }).toList();

  //     setState(() {});
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //   }
  // }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sliderImageHeight = MediaQuery.of(context).size.width * 1.3;

    return Scaffold(
      body: BottomTopMoveAnimation(
        animationController: widget.animationController,
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: FutureBuilder(
                future: Future.wait([
                  FirebaseFirestore.instance
                      .collection('restaurants_all')
                      .doc("restaurants_01")
                      .collection("popular_food")
                      .get(),
                  FirebaseFirestore.instance
                      .collection('restaurants_all')
                      .get(),
                  FirebaseFirestore.instance
                      .collection('restaurants_all')
                      .doc("restaurants_01")
                      .collection("Best_deal")
                      .get(),
                  FirebaseFirestore.instance
                      .collection('restaurants_all')
                      .doc("restaurants_01")
                      .collection("sweetmenu")
                      .get(),
                ]),
                builder: (BuildContext context,
                    AsyncSnapshot<List<QuerySnapshot>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.data == null ||
                      snapshot.data![0].docs.isEmpty ||
                      snapshot.data![1].docs.isEmpty ||
                      snapshot.data![2].docs.isEmpty ||
                      snapshot.data![3].docs.isEmpty) {
                    return const Center(child: Text('No documents found'));
                  }

                  popularList = snapshot.data![0].docs.map((doc) {
                    var docData01 = doc.data() as Map<String, dynamic>;

                    return FoodDtail(
                      dataTxt: docData01['dataTxt'] ?? '',
                      rating: docData01['rating'] ?? 1,
                      imagePath: docData01['imagePath'] ?? '',
                      titleTxt: docData01['titleTxt'] ?? '',
                    );
                  }).toList();

                  detailRes = snapshot.data![1].docs.map((doc) {
                    var docData02 = doc.data() as Map<String, dynamic>;

                    return Restaurants(
                      widget,
                      imagePath: docData02['imagePath'] ?? '',
                      BackGround_Res: docData02['BackGround_Res'] ?? '',
                      titleTxt: docData02['titleTxt'] ?? '',
                      subTxt: docData02['subTxt'] ?? '',
                      dataTxt: docData02['dataTxt'] ?? '',
                      isSelected: docData02['isSelected'] ?? false,
                      rating: docData02['rating'] ?? 1,
                      fivetopersen_img: docData02['fivetopersen_img'] ?? '',
                    );
                  }).toList();

                  bestdeal = snapshot.data![2].docs.map((doc) {
                    var docData03 = doc.data() as Map<String, dynamic>;
                    return Restaurants(
                      widget,
                      imagePath: docData03['imagePath'] ?? '',
                      BackGround_Res: docData03['BackGround_Res'] ?? '',
                      titleTxt: docData03['titleTxt'] ?? '',
                      subTxt: docData03['subTxt'] ?? '',
                      dataTxt: docData03['dataTxt'] ?? '',
                      isSelected: docData03['isSelected'] ?? false,
                      rating: docData03['rating'] ?? 1,
                      fivetopersen_img: docData03['fivetopersen_img'] ?? '',
                    );
                  }).toList();

                  sweetmenu = snapshot.data![3].docs.map((doc) {
                    var docData03 = doc.data() as Map<String, dynamic>;

                    return FoodDtail(
                        dataTxt: docData03['dataTxt'] ?? '',
                        rating: docData03['rating'] ?? 1,
                        imagePath: docData03['imagePath'] ?? '',
                        titleTxt: docData03['titleTxt'] ?? '');
                  }).toList();

                  return ListView.builder(
                    itemCount: 6,
                    controller: controller,
                    padding:
                        EdgeInsets.only(top: sliderImageHeight, bottom: 16),
                    itemBuilder: (context, index) {
                      var animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: widget.animationController,
                          curve: Curves.fastLinearToSlowEaseIn,
                        ),
                      );
                      if (index == 0) {
                        return TitleView(
                          titleText: 'Popular food',
                          animationController: _animationController,
                          animation: animation,
                          click: () {},
                          textColor: Colors.black,
                        );
                      } else if (index == 1) {
                        return ImageSlider(
                          data: popularList,
                          resdata: detailRes,
                        );
                      } else if (index == 3) {
                        return ImageSlider(
                          data: sweetmenu,
                          resdata: detailRes,
                        );
                      } else if (index == 2) {
                        return TitleView(
                          img:
                              'https://pbs.twimg.com/profile_images/1356986201610178560/xi2tcS2V_400x400.jpg',
                          titleText: 'Dessert menu',
                          animationController: _animationController,
                          animation: animation,
                          click: () {},
                          textColor: Colors.black,
                          fooddata: sweetmenu,
                          data: detailRes,
                          screen: PopularScreen(
                              data: detailRes, fooddata: sweetmenu),
                        );
                      } else if (index == 4) {
                        return TitleView(
                          img:
                              'https://pbs.twimg.com/profile_images/1356986201610178560/xi2tcS2V_400x400.jpg',
                          titleText: 'Best Deals',
                          animationController: _animationController,
                          animation: animation,
                          click: () {},
                          textColor: Colors.black,
                          fooddata: popularList,
                          data: detailRes,
                        );
                      } else if (index == 5) {
                        return Categoriuptodown(
                          fooddata: popularList,
                          isHotDeal: true,
                          data: bestdeal,
                          resdetail: detailRes,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
            _sliderUI(),
            _viewResButton(_animationController),
          ],
        ),
      ),
    );
  }

  Widget _sliderUI() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        var opacity = 1.0 -
            (_animationController.value > 0.64
                ? 1.0
                : _animationController.value);
        return Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: sliderImageHeight * (1.0 - _animationController.value),
          child: Stack(
            children: [
              Opacity(
                opacity: opacity,
                child: HomeListSlider(
                  opValue: opacity,
                  click: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _viewResButton(AnimationController animationController) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        var opacity = 1.0 -
            (animationController.value > 0.64
                ? 1.0
                : animationController.value);
        return Positioned(
          left: 20,
          right: 250,
          top: 210,
          height: sliderImageHeight * (1.0 - animationController.value),
          child: Opacity(
            opacity: opacity,
            child: Align(
              alignment: Alignment.center,
              child: CustomButton(
                text: 'Visit',
                backgroundColor: Colors.blueAccent,
                textColor: Colors.white,
                width: 100,
                height: 40,
                onPressed: () {},
                textStyle: null,
                minWidth: 100,
              ),
            ),
          ),
        );
      },
    );
  }
}

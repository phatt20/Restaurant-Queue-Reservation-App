import 'dart:async';
import 'package:chat/models/restaurants.dart';
import 'package:chat/screens/home/categoriUptoDown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularScreen extends StatefulWidget {
  final List<Restaurants> data;
  final List<FoodDtail> fooddata;
  final String titleTxt;

  const PopularScreen({
    super.key,
    required this.data,
    this.titleTxt = '',
    required this.fooddata,
  });

  @override
  _PopularScreenState createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );

    _animationController.forward();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        if (_currentPage < widget.data.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 50.0,
            pinned: true,
            floating: false,
            snap: false,
            title: Text(
              widget.titleTxt,
              textAlign: TextAlign.left,
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FadeTransition(
                          opacity: _animation,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                image:
                                    NetworkImage(widget.data[index].imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Categoriuptodown(
                  data: widget.data,
                  isHotDeal: true,
                  fooddata: widget.fooddata,
                  resdetail: widget.data,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

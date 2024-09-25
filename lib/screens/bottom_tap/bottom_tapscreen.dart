import 'package:chat/screens/List/listscreen.dart';
import 'package:chat/screens/bottom_tap/components/tapbutton_ui.dart';
import 'package:chat/screens/chat/chat.dart';
import 'package:chat/screens/home/homescreen.dart';
import 'package:chat/screens/profile/profile.dart';
import 'package:chat/widgets/common_card.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomTapscreen extends StatefulWidget {
  const BottomTapscreen({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BottomTapscreen();
  }
}

class _BottomTapscreen extends State<BottomTapscreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isFirstTime = true;
  Widget _indexView = Container();

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _indexView = Container();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLoadingScreen();
    });
    super.initState();
  }

  Future _startLoadingScreen() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() {
        _isFirstTime = false;
        _indexView = HomeScreen(
          animationController: _animationController,
        );
        _animationController.forward();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  BottomBarType bottomBarType = BottomBarType.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 70 + MediaQuery.of(context).padding.bottom,
        child: getbotbar(bottomBarType),
      ),
      body: _isFirstTime
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : _indexView,
    );
  }

  Widget getbotbar(BottomBarType bottomBarType) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: Colors.blueAccent.withOpacity(0.6),
      color: Colors.blueAccent.withOpacity(0.6),
      animationDuration: const Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(
          Icons.home,
          size: 26,
          color: Colors.white,
        ),
        Icon(
          Icons.receipt,
          size: 26,
          color: Colors.white,
        ),
        Icon(
          Icons.chat,
          size: 26,
          color: Colors.white,
        ),
        Icon(
          Icons.account_circle,
          size: 26,
          color: Colors.white,
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            tabClick(BottomBarType.home);
            break;
          case 1:
            tabClick(BottomBarType.list);
            break;
          case 2:
            tabClick(BottomBarType.chat);
            break;
          case 3:
            tabClick(BottomBarType.profile);
            break;
        }
      },
    );
  }

  // Widget getBottomBarUI(BottomBarType bottomBarType) {
  //   return CommonCardState(
  //     color: Colors.white,
  //     radius: 0,
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             TapButtonUi(
  //               icon: Icons.home,
  //               isSelected: bottomBarType == BottomBarType.home,
  //               text: 'Home',
  //               onTap: () {
  //                 tabClick(BottomBarType.home);
  //               },
  //             ),
  //             TapButtonUi(
  //               icon: Icons.receipt,
  //               isSelected: bottomBarType == BottomBarType.list,
  //               text: 'List',
  //               onTap: () {
  //                 tabClick(BottomBarType.list);
  //               },
  //             ),
  //             TapButtonUi(
  //               icon: Icons.chat,
  //               isSelected: bottomBarType == BottomBarType.chat,
  //               text: 'Chat',
  //               onTap: () {
  //                 tabClick(BottomBarType.chat);
  //               },
  //             ),
  //             TapButtonUi(
  //               icon: Icons.account_circle,
  //               isSelected: bottomBarType == BottomBarType.profile,
  //               text: 'Profile',
  //               onTap: () {
  //                 tabClick(BottomBarType.profile);
  //               },
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: MediaQuery.of(context).padding.bottom,
  //         )
  //       ],
  //     ),
  //   );
  // }

  void tabClick(BottomBarType tabType) {
    if (tabType != bottomBarType) {
      setState(() {
        bottomBarType = tabType;
      });
    }

    if (tabType == BottomBarType.home) {
      setState(() {
        _indexView = HomeScreen(animationController: _animationController);
      });
    } else if (tabType == BottomBarType.list) {
      setState(() {
        _indexView = const Listscreen();
      });
    } else if (tabType == BottomBarType.chat) {
      setState(() {
        _indexView = ChatScreen(
          animationController: _animationController,
        );
      });
    } else if (tabType == BottomBarType.profile) {
      setState(() {
        _indexView = const Profile();
      });
    }
  }
}

enum BottomBarType { home, profile, list, chat }

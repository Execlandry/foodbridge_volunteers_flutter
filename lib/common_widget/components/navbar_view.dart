import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:foodbridge_volunteers_flutter/common/color_extension.dart';
import 'package:foodbridge_volunteers_flutter/view/active_delivery/active_delivery.dart';
import 'package:foodbridge_volunteers_flutter/view/delivery_history/delivery_history.dart';
import '../../view/home/home_view.dart';
import '../../view/more/more_view.dart';

class NavbarView extends StatefulWidget {
  final int? selectedIndex;
  const NavbarView({super.key, this.selectedIndex});

  @override
  State<NavbarView> createState() => _NavbarViewState();
}

class _NavbarViewState extends State<NavbarView> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomeView(),
    const ActiveDelivery(),
    const DeliveryHistory(),
    // const WebViewScreen(),
    const MoreView(),
  ];
  @override
  void initState() {
    _selectedIndex = widget.selectedIndex ?? 0;
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop, result) {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: TColor.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                spreadRadius: 2,
                color: TColor.primary.withOpacity(0.15),
              )
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: GNav(
                curve: Curves.easeOutExpo,
                rippleColor: TColor.primary.withOpacity(0.1),
                hoverColor: TColor.primary.withOpacity(0.15),
                activeColor: TColor.primary,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 500),
                tabBackgroundColor: TColor.primary.withOpacity(0.1),
                color: TColor.secondaryText,
                gap: 6,
                tabs: [
                  GButton(
                    icon: Icons.home_rounded,
                    text: 'Home',
                    textStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      // color: _selectedIndex == 0 ? TColor.primary : TColor.secondaryText,
                    ),
                    iconActiveColor: TColor.primary,
                  ),
                  GButton(
                    icon: Icons.local_shipping_rounded,
                    text: 'Active',
                    textStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      // color: _selectedIndex == 1
                      //     ? TColor.primary
                      //     : TColor.secondaryText,
                    ),
                    iconActiveColor: TColor.primary,
                  ),
                  GButton(
                    icon: Icons.history_rounded,
                    text: 'History',
                    textStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      // color: _selectedIndex == 2
                      //     ? TColor.primary
                      //     : TColor.secondaryText,
                    ),
                    iconActiveColor: TColor.primary,
                  ),
                  GButton(
                    icon: Icons.menu_rounded,
                    text: 'More',
                    textStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      // color: _selectedIndex == 3
                      //     ? TColor.primary
                      //     : TColor.secondaryText,
                    ),
                    iconActiveColor: TColor.primary,
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

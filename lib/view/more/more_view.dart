import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery_auth/bloc/auth_bloc.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery_auth/bloc/auth_event.dart';
import 'package:foodbridge_volunteers_flutter/logic/delivery_auth/bloc/auth_state.dart';
import 'package:foodbridge_volunteers_flutter/view/login/welcome_view.dart';
import 'package:foodbridge_volunteers_flutter/view/main_tabview/main_tabview.dart';
import 'package:foodbridge_volunteers_flutter/view/more/about_us_view.dart';
import 'package:foodbridge_volunteers_flutter/view/more/inbox_view.dart';
import 'package:foodbridge_volunteers_flutter/view/offer/delivery_history.dart';
import 'package:foodbridge_volunteers_flutter/view/on_boarding/startup_view.dart';
import 'package:foodbridge_volunteers_flutter/view/payment/payment_history_view.dart';
// import 'package:foodbridge_volunteers_flutter/view/more/payment_details_view.dart';

import '../../common/color_extension.dart';
// import '../../common/service_call.dart';
import 'my_order_view.dart';
import 'notification_view.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  List moreArr = [
    {
      "index": "1",
      "name": "Payment History",
      "image": "assets/img/more_payment.png",
      "base": 0
    },
    {
      "index": "2",
      "name": "My Deliveries",
      "image": "assets/img/more_my_order.png",
      "base": 0
    },
    {
      "index": "3",
      "name": "Notifications",
      "image": "assets/img/more_notification.png",
      "base": 15
    },
    {
      "index": "4",
      "name": "Inbox",
      "image": "assets/img/more_inbox.png",
      "base": 0
    },
    {
      "index": "5",
      "name": "About Us",
      "image": "assets/img/more_info.png",
      "base": 0
    },
    {
      "index": "6",
      "name": "Logout",
      "image": "assets/img/logout.png",
      "base": 0
    },
  ];
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => WelcomeView()),
              (route) => false,
            );
          }
          if (state is AuthFailure) {
            _showErrorSnackbar(state.error);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 46,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "More",
                        style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const MyOrderView()));
                      //   },
                      //   icon: Image.asset(
                      //     "assets/img/shopping_cart.png",
                      //     width: 25,
                      //     height: 25,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: moreArr.length,
                    itemBuilder: (context, index) {
                      var mObj = moreArr[index] as Map? ?? {};
                      var countBase = mObj["base"] as int? ?? 0;
                      return InkWell(
                        onTap: () {
                          switch (mObj["index"].toString()) {
                            case "1":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PaymentHistoryView()));

                              break;

                            case "2":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DeliveryHistory()));
                            case "3":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationsView()));
                            case "4":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const InboxView()));
                            case "5":
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AboutUsView()));
                            case "6":
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Confirm Logout'),
                                  content: const Text(
                                      'Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                        BlocProvider.of<AuthBloc>(context)
                                            .add(LoggedOutRequestedUserEvent());
                                      },
                                      child: const Text('Logout'),
                                    ),
                                  ],
                                ),
                              );
                              break;

                            default:
                              break;
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                decoration: BoxDecoration(
                                    color: TColor.textfield,
                                    borderRadius: BorderRadius.circular(5)),
                                margin: const EdgeInsets.only(right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: TColor.placeholder,
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                          mObj["image"].toString(),
                                          width: 25,
                                          height: 25,
                                          color: const Color.fromARGB(
                                              255, 37, 36, 36),
                                          fit: BoxFit.contain),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Text(
                                        mObj["name"].toString(),
                                        style: TextStyle(
                                            color: TColor.primaryText,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    if (countBase > 0)
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(12.5)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          countBase.toString(),
                                          style: TextStyle(
                                              color: TColor.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: TColor.primary,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Image.asset("assets/img/btn_next.png",
                                    width: 10, height: 10, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

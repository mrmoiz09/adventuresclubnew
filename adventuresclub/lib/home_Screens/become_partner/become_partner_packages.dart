// ignore_for_file: avoid_print

import 'dart:math';
import 'package:adventuresclub/constants.dart';
import 'package:adventuresclub/home_Screens/navigation_screens/bottom_navigation.dart';
import 'package:adventuresclub/widgets/Lists/package_list.dart';
import 'package:adventuresclub/widgets/my_text.dart';
import 'package:flutter/material.dart';
import '../../models/packages_become_partner/packages_become_partner_model.dart';
import 'package:http/http.dart' as http;

class BecomePartnerPackages extends StatefulWidget {
  final List<PackagesBecomePartnerModel> pbp;
  const BecomePartnerPackages(this.pbp, {super.key});

  @override
  State<BecomePartnerPackages> createState() => _BecomePartnerPackagesState();
}

class _BecomePartnerPackagesState extends State<BecomePartnerPackages> {
  DateTime t = DateTime.now();
  int count = 5;
  String orderId = "";
  String userRole = "";
  bool loading = false;

  List<String> imageOneList = [
    'images/greenrectangle.png',
    'images/orangerectangle.png',
    'images/bluerectangle.png',
    'images/purplerectangle.png',
    'images/greenrectangle.png',
    'images/orangerectangle.png',
    'images/greenrectangle.png',
    'images/orangerectangle.png',
  ];

  List<String> secondImageList = [
    'images/backpic.png',
    'images/orangecoin.png',
    'images/backpic.png',
    'images/backpic.png',
    'images/backpic.png',
    'images/orangecoin.png',
    'images/backpic.png',
    'images/orangecoin.png',
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   orderId();
  // }

  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
    // below statement will generate a random string of length using the characters
    // and length provided to it
    final randomString = List.generate(
        count, (index) => allChars[random.nextInt(allChars.length)]).join();
    setState(() {
      orderId = randomString;
    });
    return randomString; // return the generated string
  }

  void update(String id, String price) async {
    generateRandomString(count);
    try {
      var response = await http.post(
          Uri.parse(
              "https://adventuresclub.net/adventureClub/api/v1/update_subscription"),
          body: {
            'user_id': Constants.userId.toString(), //"27",
            'packages_id': "1",
            "order_id": orderId,
            "payment_type": "card",
            "payment_status": "pending",
            "payment_amount": price,
            "created_at": t.toString(),
            "updated_at": ""
          });
      transactionApi(id, price);
      print(response.statusCode);
      print(response.body);
      print(response.headers);
    } catch (e) {
      print(e.toString());
    }
  }

  void transactionApi(String id, String price) async {
    try {
      var response = await http.post(
          Uri.parse(
              "https://adventuresclub.net/adventureClub/api/v1/transaction"),
          body: {
            'user_id': Constants.userId.toString(), //"27",
            //'packages_id ': id, //"0",
            'transaction_id': t.toString(),
            "type": "booking",
            "transaction_type": "booking",
            "method": "card",
            "status": "pending",
            "price": price, //"0",
            "order_type": "subscription",
          });
      print(response.statusCode);
      print(response.body);
      print(response.headers);
      close();
    } catch (e) {
      print(e.toString());
    }
  }

  void close() async {
    Constants.getProfile();
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const BottomNavigation();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: blackColor),
        backgroundColor: whiteColor,
        title: MyText(
          text: 'Become a partner',
          color: blackColor,
          weight: FontWeight.bold,
        ),
      ),
      body: ListView.builder(
        itemCount: widget.pbp.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                update(widget.pbp[index].id.toString(), widget.pbp[index].cost),
            child: PackageList(imageOneList[index], secondImageList[index],
                widget.pbp[index].cost, widget.pbp[index].duration),
          );
        },
      ),
      // const SizedBox(
      //   height: 10,
      // ),
      // GestureDetector(
      //   onTap: () => update("1", "0"),
      //   child: PackageList(
      //     'images/greenrectangle.png',
      //     'images/backpic.png',
      //     "FREE", //" ${"\$"} ${widget.pbp[0].cost}",
      //     //'\$100',
      //     "${widget.pbp[0].title}  "
      //         "    ${widget.pbp[0].duration}",
      //     // "1",
      //     // "0"
      //     //'Advanced ( 3 Months )'
      //   ),
      // ),
      // const SizedBox(
      //   height: 20,
      // ),
      // PackageList(
      //   'images/orangerectangle.png',
      //   'images/orangecoin.png',
      //   " ${"\$"} ${widget.pbp[1].cost}",
      //   "${widget.pbp[1].title}  "
      //       "    ${widget.pbp[1].duration}",
      //   // "2",
      //   // "100" //'Platinum ( 6 months )'
      //   //,
      // ),
      // const SizedBox(
      //   height: 20,
      // ),
      // PackageList(
      //   'images/bluerectangle.png',
      //   'images/backpic.png',
      //   " ${"\$"} ${widget.pbp[2].cost}", //'\$200',
      //   "${widget.pbp[2].title}  "
      //       "    ${widget.pbp[2].duration},",
      //   // "3",
      //   // "150", //'Diamond ( 12 months )',
      // ),
      // const SizedBox(
      //   height: 20,
      // ),
      // PackageList(
      //   'images/purplerectangle.png',
      //   'images/backpic.png',
      //   " ${"\$"} ${widget.pbp[3].cost}", //'\$250',
      //   "${widget.pbp[3].title}  "
      //       "    ${widget.pbp[3].duration},",
      //   // "4",
      //   // "200",
      // ),
      // const SizedBox(
      //   height: 20,
      // ),

      //  ListView.builder(
      //   itemCount: pbp.length,
      //   itemBuilder: (context, index) {
      //     return PackageList('images/greenrectangle.png', 'images/backpic.png',
      //         pbp[index].cost, pbp[index].duration);
      //   },
      // ),
    );
  }
}

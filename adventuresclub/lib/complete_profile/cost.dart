// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:adventuresclub/constants.dart';
import 'package:adventuresclub/home_Screens/navigation_screens/bottom_navigation.dart';
import 'package:adventuresclub/provider/complete_profile_provider/complete_profile_provider.dart';
import 'package:adventuresclub/widgets/buttons/button.dart';
import 'package:adventuresclub/widgets/my_text.dart';
import 'package:adventuresclub/widgets/text_fields/TF_with_size.dart';
import 'package:adventuresclub/widgets/text_fields/multiline_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Cost extends StatefulWidget {
  const Cost({super.key});

  @override
  State<Cost> createState() => _CostState();
}

class _CostState extends State<Cost> {
  TextEditingController controller = TextEditingController();
  int countryId = 0;
  void addActivites() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 0),
                    const Image(
                      image: ExactAssetImage('images/check_circle.png'),
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10),
                      child: MyText(
                          text: 'Activities Included',
                          weight: FontWeight.bold,
                          color: blackColor,
                          size: 14,
                          fontFamily: 'Raleway'),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15),
                      child: Button(
                          'Okay ,Got it',
                          greenishColor,
                          greyColorShade400,
                          whiteColor,
                          16,
                          goToBottomNavigation,
                          Icons.add,
                          whiteColor,
                          false,
                          1.3,
                          'Raleway',
                          FontWeight.w600,
                          16),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void goToBottomNavigation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return const BottomNavigation();
        },
      ),
    );
  }

  void getData() async {
    countryId =
        Provider.of<CompleteProfileProvider>(context, listen: false).countryId;
  }

  void createService() async {
    try {
      var response = await http.post(
          Uri.parse(
              "https://adventuresclub.net/adventureClub/api/v1/create_service"),
          body: {
            'customer_id': "3",
            'adventure_name': "",
            "country_id": countryId.toString(),
            'region': "",

            // 'mobile_code': ccCode,
          });
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      print(response.statusCode);
      print(response.body);
      print(response.headers);
      print(decodedResponse['data']['user_id']);
    } catch (e) {
      print(e.toString());
    }
  }

  abc() {}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1,
          child: TextField(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              hintText: 'Enter: Geolocation',
              filled: true,
              fillColor: lightGreyColor,
              suffixIcon: const Image(
                image: ExactAssetImage('images/map-symbol.png'),
                height: 15,
                width: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: greyColor.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: greyColor.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: greyColor.withOpacity(0.2)),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TFWithSize('Type Specific Address/Location', controller, 15,
            lightGreyColor, 1),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TFWithSize(
                'Set Cost',
                controller,
                16,
                lightGreyColor,
                3.4,
              ),
            ),
            Expanded(
              child: TFWithSize(
                'Set Cost',
                controller,
                16,
                lightGreyColor,
                3.4,
              ),
            ),
            //DdButton(5.5)
          ],
        ),
        const SizedBox(height: 15),
        Align(
            alignment: Alignment.centerLeft,
            child: MyText(
              text: 'Terms and conditions',
              color: blackTypeColor,
              weight: FontWeight.w500,
            )),
        const SizedBox(height: 20),
        MultiLineField('Type Pre-Requisites….', 5, lightGreyColor, controller),
        const SizedBox(height: 20),
        MultiLineField(
            'Type Minimum Requirement....', 5, lightGreyColor, controller),
        const SizedBox(height: 20),
        MultiLineField(
            'Type Terms & Conditions.....', 5, lightGreyColor, controller),
      ]),
    );
  }
}

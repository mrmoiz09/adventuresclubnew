// // ignore_for_file: avoid_print

// import 'dart:convert';

// import 'package:app/constants.dart';
// import 'package:app/home_Screens/accounts/reviews.dart';
// import 'package:app/models/home_services/services_model.dart';
// import 'package:app/widgets/Lists/Chat_list.dart/show_chat.dart';
// import 'package:app/widgets/Lists/my_services_list.dart';
// import 'package:app/widgets/my_text.dart';
// import 'package:app/widgets/tabs/my_services_tabs.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class MyServicesAdDetails extends StatefulWidget {
//   final ServicesModel sm;
//   const MyServicesAdDetails(this.sm, {super.key});

//   @override
//   State<MyServicesAdDetails> createState() => _MyServicesAdDetailsState();
// }

// class _MyServicesAdDetailsState extends State<MyServicesAdDetails> {
//   Map mapChatNotification = {};
//   String groupChatCount = "";
//   List text = [
//     'Hill Climbing',
//     'Muscat, Oman',
//     '\$ 100.50',
//     'Including gears and other taxes',
//   ];
//   List text1 = [
//     '\$ 80.20',
//     'Excluding gears and other taxes',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     getChatNotification();
//   }

//   void goToReviews(String id) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) {
//           return Reviews(id);
//         },
//       ),
//     );
//   }

//   void selected(BuildContext context, int serviceId, int providerId) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (_) {
//           return ShowChat(
//               "${Constants.baseUrl}/chatlist/${Constants.userId}/$serviceId/$providerId");
//         },
//       ),
//     );
//   }

//   void editService(String id, String providerId) async {
//     try {
//       var response = await http.post(
//           Uri.parse(
//               "${Constants.baseUrl}/api/v1/edit_service"),
//           body: {
//             'service_id': id,
//             'customer_id': providerId, //ccCode.toString(),
//           });
//       print(response.statusCode);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   void deleteService(String id) async {
//     try {
//       var response = await http.post(
//           Uri.parse(
//               "${Constants.baseUrl}/api/v1/services_delete"),
//           body: {
//             'services_id': id,
//           });
//       // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//       if (response.statusCode == 200) {
//         dynamic body = jsonDecode(response.body);
//         // error = decodedError['data']['name'];
//         // Constants.showMessage(context, body['message'].toString());
//         showdelete(body['message'].toString());
//       } else {
//         dynamic body = jsonDecode(response.body);
//         showdelete(body['message'].toString());
//       }
//       print(response.statusCode);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   void showConfirmation(String title) async {
//     showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//               contentPadding: const EdgeInsets.all(12),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               title: const Text(
//                 "Are you sure you want to delete this",
//                 textAlign: TextAlign.center,
//               ),
//               actions: [
//                 MaterialButton(
//                   onPressed: cancel,
//                   child: const Text("No"),
//                 ),
//                 MaterialButton(
//                   onPressed: () => deleteService(title),
//                   child: const Text("Yes"),
//                 )
//               ],
//             ));
//   }

//   void showdelete(String title) {
//     Navigator.of(context).pop();
//     deleteConfirmation(title);
//   }

//   void deleteConfirmation(String title) async {
//     showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//               contentPadding: const EdgeInsets.all(12),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               title: Text(
//                 title,
//                 textAlign: TextAlign.center,
//               ),
//               actions: [
//                 MaterialButton(
//                   onPressed: cancel,
//                   child: const Text("OK"),
//                 )
//               ],
//             ));
//   }

//   void cancel() {
//     Navigator.of(context).pop();
//   }
  

//   Future getChatNotification() async {
//     var response = await http.get(Uri.parse(
//         "${Constants.baseUrl}/unreadchatcount/'${Constants.userId}/${widget.sm.serviceId}"));
//     if (response.statusCode == 200) {
//       mapChatNotification = json.decode(response.body);
//       dynamic result = mapChatNotification['unread'];
//       setState(() {
//         groupChatCount = result.toString();
//       });
//       print(result);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // appBar: AppBar(
//         //   backgroundColor: whiteColor,
//         //   elevation: 1.5,
//         //   centerTitle: true,
//         //   leading: IconButton(
//         //     onPressed: () => Navigator.pop(context),
//         //     icon: Image.asset(
//         //       'images/backArrow.png',
//         //       height: 20,
//         //     ),
//         //   ),
//         //   title: MyText(
//         //     text: widget.sm.adventureName, //'Hill Climbing',
//         //     color: bluishColor,
//         //     weight: FontWeight.w800,
//         //   ),
//         //   actions: [
//         //     Stack(
//         //       alignment: AlignmentDirectional.center,
//         //       children: [
//         //         GestureDetector(
//         //           onTap: () => selected(
//         //               context, widget.sm.serviceId, widget.sm.providerId),
//         //           child: const Icon(
//         //             Icons.message,
//         //             color: bluishColor,
//         //             size: 30,
//         //           ),
//         //         ),
//         //         if (groupChatCount != "0")
//         //           Positioned(
//         //             right: 4,
//         //             bottom: 8,
//         //             child: Container(
//         //               height: 18,
//         //               width: 15,
//         //               decoration: BoxDecoration(
//         //                 color: const Color.fromARGB(255, 187, 39, 28),
//         //                 borderRadius: BorderRadius.circular(12),
//         //               ),
//         //               child: Center(
//         //                 child: MyText(
//         //                   text: groupChatCount,
//         //                   color: whiteColor,
//         //                   weight: FontWeight.bold,
//         //                 ),
//         //               ),
//         //             ),
//         //           ),
//         //       ],
//         //     ),
//         //     const SizedBox(width: 10)
//         //   ],
//         // ),
//         body: DefaultTabController(
//             length: 2,
//             child: NestedScrollView(
//                 headerSliverBuilder:
//                     (BuildContext context, bool innerBoxIsScrolled) {
//                   return [
//                     SliverAppBar(
//                       pinned: false,
//                       expandedHeight: 350,
//                       flexibleSpace: FlexibleSpaceBar(
//                         title: MyText(
//                           text: widget.sm.adventureName, //'Hill Climbing',
//                           color: bluishColor,
//                           weight: FontWeight.w800,
//                         ),
//                         stretchModes: const [StretchMode.zoomBackground],
//                       ),
//                     ),
//                     const SliverPersistentHeader(
//                       delegate: SliverPersistentHeaderDelegateImpl(
//                         TabBar(
//                           tabs: [
//                             Tab(icon: Icon(Icons.flight)),
//                             Tab(icon: Icon(Icons.directions_transit)),
//                             Tab(icon: Icon(Icons.directions_car)),
//                           ],
//                         ),
//                       ),
//                       pinned: false,
//                     )
//                   ];
//                 },
//                 body: body))
//         // Container(
//         //   color: greyShadeColor.withOpacity(0.2),
//         //   child: Column(
//         //     children: [
//         //       SizedBox(
//         //           width: MediaQuery.of(context).size.width,
//         //           height: MediaQuery.of(context).size.height / 5.5,
//         //           child: MyServicesList(widget.sm)),
//         //       Padding(
//         //         padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0),
//         //         child: Card(
//         //             child: Padding(
//         //           padding: const EdgeInsets.all(12.0),
//         //           child: Column(
//         //             children: [
//         //               Row(
//         //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                 children: [
//         //                   MyText(
//         //                     text: widget.sm.adventureName, //'Hill Climbing',
//         //                     color: greyBackgroundColor,
//         //                     size: 16,
//         //                     weight: FontWeight.w600,
//         //                     fontFamily: "Roboto",
//         //                   ),
//         //                   Row(
//         //                     mainAxisAlignment: MainAxisAlignment.end,
//         //                     children: [
//         //                       const SizedBox(
//         //                         width: 20,
//         //                       ),
//         //                       GestureDetector(
//         //                         onTap: () => showConfirmation(
//         //                             widget.sm.serviceId.toString()),
//         //                         child: const Image(
//         //                           image: ExactAssetImage('images/bin.png'),
//         //                           height: 20,
//         //                           width: 20,
//         //                         ),
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 ],
//         //               ),
//         //               const SizedBox(
//         //                 height: 5,
//         //               ),
//         //               Row(
//         //                 children: [
//         //                   const Image(
//         //                     image: ExactAssetImage('images/location-on.png'),
//         //                     color: greyColor,
//         //                   ),
//         //                   const SizedBox(
//         //                     width: 5,
//         //                   ),
//         //                   MyText(
//         //                     text: widget.sm.sAddress.tr(), //'Muscat Oman',
//         //                     color: greyColor,
//         //                     weight: FontWeight.w500,
//         //                   )
//         //                 ],
//         //               ),
//         //               const SizedBox(
//         //                 height: 10,
//         //               ),
//         //               Row(
//         //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         //                 children: [
//         //                   Column(
//         //                     crossAxisAlignment: CrossAxisAlignment.start,
//         //                     children: [
//         //                       MyText(
//         //                         text: "${widget.sm.currency} "
//         //                             "${widget.sm.costInc}", //'\$ 100.50',
//         //                         color: blackColor,
//         //                         weight: FontWeight.bold,
//         //                         fontFamily: "Roboto",
//         //                       ),
//         //                     ],
//         //                   ),
//         //                 ],
//         //               ),
//         //             ],
//         //           ),
//         //         )),
//         //       ),
//         //       Expanded(
//         //         child: MyServicesTab(widget.sm),
//         //       )
//         //     ],
//         //   ),
//         // ),
//         );
//   }

  
// }

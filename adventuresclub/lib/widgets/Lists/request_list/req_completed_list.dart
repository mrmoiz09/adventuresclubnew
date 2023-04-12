// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:adventuresclub/constants.dart';
import 'package:adventuresclub/home_Screens/accounts/my_adventures.dart';
import 'package:adventuresclub/home_Screens/details.dart';
import 'package:adventuresclub/models/filter_data_model/programs_model.dart';
import 'package:adventuresclub/models/home_services/become_partner.dart';
import 'package:adventuresclub/models/home_services/services_model.dart';
import 'package:adventuresclub/models/requests/upcoming_Requests_Model.dart';
import 'package:adventuresclub/models/services/aimed_for_model.dart';
import 'package:adventuresclub/models/services/availability_model.dart';
import 'package:adventuresclub/models/services/create_services/availability_plan_model.dart';
import 'package:adventuresclub/models/services/dependencies_model.dart';
import 'package:adventuresclub/models/services/included_activities_model.dart';
import 'package:adventuresclub/models/services/service_image_model.dart';
import 'package:adventuresclub/widgets/my_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Chat_list.dart/show_chat.dart';

class ReqCompletedList extends StatefulWidget {
  const ReqCompletedList({super.key});

  @override
  State<ReqCompletedList> createState() => _ReqCompletedListState();
}

class _ReqCompletedListState extends State<ReqCompletedList> {
  Map Ulist = {};
  List<ServiceImageModel> gSim = [];
  List<UpcomingRequestsModel> uRequestList = [];
  Map mapChat = {};
  bool loading = false;
  Map mapDetails = {};
  static ServicesModel service = ServicesModel(
      0,
      0,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      0,
      DateTime.now(),
      DateTime.now(),
      "",
      "",
      "",
      0,
      0,
      ab,
      ap,
      "",
      "",
      "",
      "",
      "",
      0,
      "",
      "",
      "",
      0,
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      0,
      0,
      "",
      "",
      "",
      "",
      ia,
      dm,
      bp,
      am,
      programmes,
      "",
      0,
      "",
      images,
      "",
      "",
      0);
  List<BecomePartner> nBp = [];
  static List<AvailabilityModel> ab = [];
  static List<AvailabilityPlanModel> ap = [];
  static List<IncludedActivitiesModel> ia = [];
  static List<DependenciesModel> dm = [];
  static List<BecomePartner> bp = [];
  static List<AimedForModel> am = []; // new
  static List<ProgrammesModel> programmes = [];
  static List<ServiceImageModel> images = [];

  @override
  initState() {
    super.initState();
    getReqList();
    List<AvailabilityModel> av = ab;
  }

  void goToDetails(ServicesModel gm) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Details(gm: gm);
        },
      ),
    );
  }

  Future getReqList() async {
    setState(() {
      loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://adventuresclub.net/adventureClub/api/v1/get_requests?user_id=${Constants.userId}&type=1"));
    try {
      if (response.statusCode == 200) {
        Ulist = json.decode(response.body);
        List<dynamic> result = Ulist['data'];
        result.forEach((element) {
          List<dynamic> image = element['images'];
          image.forEach((i) {
            ServiceImageModel sm = ServiceImageModel(
              int.tryParse(i['id'].toString()) ?? 0,
              int.tryParse(i['service_id'].toString()) ?? 0,
              int.tryParse(i['is_default'].toString()) ?? 0,
              i['image_url'].toString() ?? "",
              i['thumbnail'].toString() ?? "",
            );
            gSim.add(sm);
          });
          String bookingN = element["booking_id"].toString();
          text2[0] = bookingN;
          UpcomingRequestsModel up = UpcomingRequestsModel(
              int.tryParse(bookingN) ?? 0,
              int.tryParse(element["service_id"].toString()) ?? 0,
              int.tryParse(element["provider_id"].toString()) ?? 0,
              int.tryParse(element["service_plan"].toString()) ?? 0,
              element["country"].toString() ?? "",
              element["currency"].toString() ?? "",
              element["region"].toString() ?? "",
              element["adventure_name"].toString() ?? "",
              element["provider_name"].toString() ?? "",
              element["height"].toString() ?? "",
              element["weight"].toString() ?? "",
              element["health_conditions"].toString() ?? "",
              element["booking_date"].toString() ?? "",
              element["activity_date"].toString() ?? "",
              int.tryParse(element["adult"].toString()) ?? 0,
              int.tryParse(element["kids"].toString()) ?? 0,
              element["unit_cost"].toString() ?? "",
              element["total_cost"].toString() ?? "",
              element["discounted_amount"].toString() ?? "",
              element["payment_channel"].toString() ?? "",
              element["status"].toString() ?? "",
              element["payment_status"].toString() ?? "",
              element["points"].toString() ?? "",
              element["description"].toString() ?? "",
              element["registrations"].toString() ?? "",
              gSim);
          uRequestList.add(up);
        });
      }
      setState(() {
        loading = false;
      });
      print(response.statusCode);
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  // void getChats() async {
  //   // setState(() {
  //   //   loading = true;
  //   // });
  //   try {
  //     var response = await http.get(
  //       Uri.parse(
  //           "https://adventuresclub.net/adventureClub/newreceiverchat/3/1/3"),
  //     );
  //     if (response.statusCode == 200) {
  //       mapChat = json.decode(response.body);
  //       List<dynamic> result = mapChat['data'];
  //       result.forEach((element) {});
  //     }
  //     // setState(() {
  //     //   loading = false;
  //     // });
  //     print(response.statusCode);
  //     print(response.body);
  //     print(response.headers);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // Future getReqList() async {
  //   var response = await http.get(Uri.parse(
  //       "https://adventuresclub.net/adventureClub/api/v1/get_requests?user_id=27&type=1"));
  //   try {
  //     if (response.statusCode == 200) {
  //       Ulist = json.decode(response.body);
  //       List<dynamic> result = Ulist['data'];
  //       result.forEach((element) {});
  //     }
  //     print(response.statusCode);
  //     print(response.body);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future getDetails(String serviceId, String userId) async {
    setState(() {
      loading = true;
    });
    var response = await http.get(Uri.parse(
        "https://adventuresclub.net/adventureClub/api/v1/services/$serviceId?user_id=$userId"));
    if (response.statusCode == 200) {
      mapDetails = json.decode(response.body);
      dynamic result = mapDetails['data'];
      List<AvailabilityPlanModel> gAccomodationPlanModel = [];
      List<dynamic> availablePlan = result['availability'];
      availablePlan.forEach((ap) {
        AvailabilityPlanModel amPlan = AvailabilityPlanModel(
            ap['id'].toString() ?? "", ap['day'].toString() ?? "");
        gAccomodationPlanModel.add(amPlan);
      });
      List<AvailabilityModel> gAccomodoationAvaiModel = [];
      List<dynamic> available = result['availability'];
      available.forEach((a) {
        AvailabilityModel am = AvailabilityModel(
            a['start_date'].toString() ?? "", a['end_date'].toString() ?? "");
        gAccomodoationAvaiModel.add(am);
      });
      if (result['become_partner'] != null) {
        List<dynamic> becomePartner = result['become_partner'];
        becomePartner.forEach((b) {
          BecomePartner bp = BecomePartner(
              b['cr_name'].toString() ?? "",
              b['cr_number'].toString() ?? "",
              b['description'].toString() ?? "");
        });
      }
      List<IncludedActivitiesModel> gIAm = [];
      List<dynamic> iActivities = result['included_activities'];
      iActivities.forEach((iA) {
        IncludedActivitiesModel iAm = IncludedActivitiesModel(
          int.tryParse(iA['id'].toString()) ?? 0,
          int.tryParse(iA['service_id'].toString()) ?? 0,
          iA['activity_id'].toString() ?? "",
          iA['activity'].toString() ?? "",
          iA['image'].toString() ?? "",
        );
        gIAm.add(iAm);
      });
      List<DependenciesModel> gdM = [];
      List<dynamic> dependency = result['dependencies'];
      dependency.forEach((d) {
        DependenciesModel dm = DependenciesModel(
          int.tryParse(d['id'].toString()) ?? 0,
          d['dependency_name'].toString() ?? "",
          d['image'].toString() ?? "",
          d['updated_at'].toString() ?? "",
          d['created_at'].toString() ?? "",
          d['deleted_at'].toString() ?? "",
        );
        gdM.add(dm);
      });
      List<AimedForModel> gAccomodationAimedfm = [];
      List<dynamic> aF = result['aimed_for'];
      aF.forEach((a) {
        AimedForModel afm = AimedForModel(
          int.tryParse(a['id'].toString()) ?? 0,
          a['AimedName'].toString() ?? "",
          a['image'].toString() ?? "",
          a['created_at'].toString() ?? "",
          a['updated_at'].toString() ?? "",
          a['deleted_at'].toString() ?? "",
          int.tryParse(a['service_id'].toString()) ?? 0,
        );
        gAccomodationAimedfm.add(afm);
      });
      List<ServiceImageModel> gAccomodationServImgModel = [];
      List<dynamic> image = result['images'];
      image.forEach((i) {
        ServiceImageModel sm = ServiceImageModel(
          int.tryParse(i['id'].toString()) ?? 0,
          int.tryParse(i['service_id'].toString()) ?? 0,
          int.tryParse(i['is_default'].toString()) ?? 0,
          i['image_url'].toString() ?? "",
          i['thumbnail'].toString() ?? "",
        );
        gAccomodationServImgModel.add(sm);
      });
      List<ProgrammesModel> gPm = [];
      List<dynamic> programs = result['programs'];
      programs.forEach((p) {
        ProgrammesModel pm = ProgrammesModel(
          int.tryParse(p['id'].toString()) ?? 0,
          int.tryParse(p['service_id'].toString()) ?? 0,
          p['title'].toString() ?? "",
          p['start_datetime'].toString() ?? "",
          p['end_datetime'].toString() ?? "",
          p['description'].toString() ?? "",
        );
        gPm.add(pm);
      });
      DateTime sDate =
          DateTime.tryParse(result['start_date'].toString()) ?? DateTime.now();
      DateTime eDate =
          DateTime.tryParse(result['end_date'].toString()) ?? DateTime.now();
      ServicesModel nSm = ServicesModel(
        int.tryParse(result['id'].toString()) ?? 0,
        int.tryParse(result['owner'].toString()) ?? 0,
        result['adventure_name'].toString() ?? "",
        result['country'].toString() ?? "",
        result['region'].toString() ?? "",
        result['city_id'].toString() ?? "",
        result['service_sector'].toString() ?? "",
        result['service_category'].toString() ?? "",
        result['service_type'].toString() ?? "",
        result['service_level'].toString() ?? "",
        result['duration'].toString() ?? "",
        int.tryParse(result['availability_seats'].toString()) ?? 0,
        sDate,
        eDate,
        //int.tryParse(services['start_date'].toString()) ?? "",
        //int.tryParse(services['end_date'].toString()) ?? "",
        result['latitude'].toString() ?? "",
        result['longitude'].toString() ?? "",
        result['write_information'].toString() ?? "",
        int.tryParse(result['service_plan'].toString()) ?? 0,
        int.tryParse(result['sfor_id'].toString()) ?? 0,
        gAccomodoationAvaiModel,
        gAccomodationPlanModel,
        result['geo_location'].toString() ?? "",
        result['specific_address'].toString() ?? "",
        result['cost_inc'].toString() ?? "",
        result['cost_exc'].toString() ?? "",
        result['currency'].toString() ?? "",
        int.tryParse(result['points'].toString()) ?? 0,
        result['pre_requisites'].toString() ?? "",
        result['minimum_requirements'].toString() ?? "",
        result['terms_conditions'].toString() ?? "",
        int.tryParse(result['recommended'].toString()) ?? 0,
        result['status'].toString() ?? "",
        result['image'].toString() ?? "",
        result['descreption]'].toString() ?? "",
        result['favourite_image'].toString() ?? "",
        result['created_at'].toString() ?? "",
        result['updated_at'].toString() ?? "",
        result['delete_at'].toString() ?? "",
        int.tryParse(result['provider_id'].toString()) ?? 0,
        int.tryParse(result['service_id'].toString()) ?? 0,
        result['provided_name'].toString() ?? "",
        result['provider_profile'].toString() ?? "",
        result['including_gerea_and_other_taxes'].toString() ?? "",
        result['excluding_gerea_and_other_taxes'].toString() ?? "",
        gIAm,
        gdM,
        nBp,
        gAccomodationAimedfm,
        gPm,
        result['stars'].toString() ?? "",
        int.tryParse(result['is_liked'].toString()) ?? 0,
        result['baseurl'].toString() ?? "",
        gAccomodationServImgModel,
        result['rating'].toString() ?? "",
        result['reviewd_by'].toString() ?? "",
        int.tryParse(result['remaining_seats'].toString()) ?? 0,
      );
      //gAccomodationSModel.add(nSm);
      setState(() {
        service = nSm;
        loading = false;
      });
      goToDetails(service);
    }
  }

  abc() {}
  void goToMyAd(UpcomingRequestsModel gm) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return MyAdventures(gm);
        },
      ),
    );
  }

  List text = [
    'Booking Number :',
    'Activity Name :',
    'Provider Name :',
    'Booking Date :',
    'Activity Date :',
    'Registrations :',
    'Unit Cost :',
    'Total Cost :',
    'Payable Cost',
    'Payment Channel :'
  ];
  List text2 = [
    '112',
    'Mr adventure',
    'John Doe',
    '30 Sep, 2020',
    '05 Oct, 2020',
    '2 Adults, 3 Youngsters',
    '\$ 400.50',
    '\$ 1500.50',
    '\$ 1500.50',
    'Debit/Credit Card'
  ];

  void selected(BuildContext context, int serviceId, int providerId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return ShowChat(
              "https://adventuresclub.net/adventureClub/newreceiverchat/${Constants.userId}/$serviceId/$providerId");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                text: "Loading...",
                color: bluishColor,
                weight: FontWeight.w700,
              ),
              const SizedBox(
                height: 5,
              ),
              const CircularProgressIndicator(),
            ],
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 00),
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: uRequestList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return loading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: "Loading Information...",
                          color: blackColor,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const CircularProgressIndicator(),
                      ],
                    )
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyText(
                                  text: uRequestList[index]
                                      .region, //'Location Name',
                                  color: blackColor,
                                ),
                                uRequestList[index].status == "1"
                                    ? MyText(
                                        text: 'Confirmed',
                                        color: Colors.green,
                                        weight: FontWeight.bold,
                                      )
                                    : MyText(
                                        text: 'Requested',
                                        color: yellowcolor,
                                        weight: FontWeight.bold,
                                      )
                              ],
                            ),
                            Divider(
                              color: blackColor.withOpacity(0.3),
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 26,
                                  backgroundImage:
                                      ExactAssetImage('images/airrides.png'),
                                  // NetworkImage(
                                  //     "${"https://adventuresclub.net/adventureClub/public/uploads/"}${uRequestList[index].sImage[0].imageUrl}}"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 3),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(direction: Axis.vertical, children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Booking Number: ",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text:
                                                  uRequestList[index].BookingId,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Activity Name: ",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text: uRequestList[index]
                                                  .adventureName,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Provider Name: ",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text: uRequestList[index].pName,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Booking Date: ",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text: uRequestList[index].bDate,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Activity Date : ",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text: uRequestList[index].aDate,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Registrations :",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text: uRequestList[index]
                                                  .registration,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Unit Cost : ",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text: uRequestList[index].uCost,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Total Cost : ",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text: uRequestList[index].tCost,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Payable Cost : ",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text: uRequestList[index].tCost,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MyText(
                                              text: "Payment Channel : ",
                                              color: blackColor,
                                              weight: FontWeight.w700,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                            MyText(
                                              text: uRequestList[index].pChanel,
                                              color: greyColor,
                                              weight: FontWeight.w400,
                                              size: 13,
                                              height: 1.8,
                                            ),
                                          ],
                                        ),
                                      ]),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => getDetails(
                                      uRequestList[index].serviceId.toString(),
                                      uRequestList[index]
                                          .providerId
                                          .toString()),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 21,
                                    width:
                                        MediaQuery.of(context).size.width / 3.8,
                                    decoration: const BoxDecoration(
                                      color: bluishColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'View Details',
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // SquareButton('View Details', bluishColor, whiteColor,
                                //     3.7, 21, 12, abc),
                                // SquareButton('Rate Now', yellowcolor,
                                //     whiteColor, 3.7, 21, 12, goToMyAd),
                                GestureDetector(
                                  onTap: () => goToMyAd(uRequestList[index]),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 21,
                                    width:
                                        MediaQuery.of(context).size.width / 3.8,
                                    decoration: const BoxDecoration(
                                      color: yellowcolor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Rate Now',
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => selected(
                                      context,
                                      uRequestList[index].serviceId,
                                      uRequestList[index].providerId),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 21,
                                    width:
                                        MediaQuery.of(context).size.width / 3.8,
                                    decoration: const BoxDecoration(
                                      color: blueColor1,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text(
                                              'Chat Provider',
                                              style: TextStyle(
                                                  color: whiteColor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // SquareButton(
                                //     'Chat Provider',
                                //     blueColor1,
                                //     whiteColor,
                                //     3.7,
                                //     21,
                                //     12,
                                //     () => selected(
                                //         context,
                                //         uRequestList[index].serviceId.toString(),
                                //         uRequestList[index].providerId.toString())),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
            });
  }
}

// ignore_for_file: avoid_function_literals_in_foreach_calls, unused_local_variable, avoid_print

import 'dart:convert';
import 'package:adventuresclub/models/filter_data_model/category_filter_model.dart';
import 'package:adventuresclub/models/filter_data_model/programs_model.dart';
import 'package:adventuresclub/models/home_services/home_services_model.dart';
import 'package:adventuresclub/models/home_services/services_model.dart';
import 'package:adventuresclub/models/search_model.dart';
import 'package:adventuresclub/models/services/aimed_for_model.dart';
import 'package:adventuresclub/models/services/availability_model.dart';
import 'package:adventuresclub/models/services/dependencies_model.dart';
import 'package:adventuresclub/models/services/included_activities_model.dart';
import 'package:adventuresclub/models/services/service_image_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/home_services/become_partner.dart';
import '../models/services/create_services/availability_plan_model.dart';

class ServicesProvider with ChangeNotifier {
  ServicesProvider({Key? key});
  bool loadingServices = false;
  int homeIndex = 0;
  List<String> categories = [];
  List<BecomePartner> nBp = [];
  List<BecomePartner> transportBp = [];
  List<BecomePartner> skyBp = [];
  List<BecomePartner> waterBp = [];
  List<BecomePartner> landBp = [];
  List<ServicesModel> gAccomodationSModel = [];
  List<ServicesModel> gTransportSModel = [];
  List<ServicesModel> gSkyServicesModel = [];
  List<ServicesModel> gWaterServicesModel = [];
  List<ServicesModel> gLandServicesModel = [];
  List<ServicesModel> allServices = [];
  List<ServicesModel> filterServices = [];
  List<ServicesModel> allAccomodation = [];
  List<ServicesModel> allTransport = [];
  List<ServicesModel> allSky = [];
  List<ServicesModel> allWater = [];
  List<ServicesModel> allLand = [];
  List<CategoryFilterModel> categoryFilter = [];
  List<HomeServicesModel> gAllServices = [];
  String search = "";
  List<HomeServicesModel> filteredServices = [];
  List<SearchModel> searchedList = [];
  List<HomeServicesModel> searchfilterServices = [];
  List<DependenciesModel> gdM = [];
  bool searchFilter = false;

  bool loading = false;

  void setHomeIndex(int i) {
    homeIndex = i;
    notifyListeners();
  }

  void setSearch(String x) {
    filteredServices.clear();
    if (x.isNotEmpty) {
      List<ServicesModel> filtered = allServices
          .where((element) =>
              element.adventureName.toLowerCase().contains(x.toLowerCase()))
          .toList();
      for (int i = 0; i < filtered.length; i++) {
        int index = filteredServices.indexWhere(
            (element) => element.category == filtered[i].serviceCategory);
        if (index == -1) {
          filteredServices.add(
              HomeServicesModel(filtered[i].serviceCategory, [filtered[i]]));
        } else {
          filteredServices[index].sm.add(filtered[i]);
        }
      }
    } else {
      filteredServices = [...gAllServices];
    }
    notifyListeners();
  }

  void getCategory(List<CategoryFilterModel> cm) {
    cm = categoryFilter;
  }

  void clearAll() {
    allAccomodation.clear();
    allTransport.clear();
    allSky.clear();
    allWater.clear();
    allLand.clear();
    nBp.clear();
    transportBp.clear();
    skyBp.clear();
    waterBp.clear();
    landBp.clear();
    gAccomodationSModel.clear();
    gTransportSModel.clear();
    gSkyServicesModel.clear();
    gWaterServicesModel.clear();
    gLandServicesModel.clear();
    allServices.clear();
    print(filterServices);
  }

  void changeState() {
    searchFilter = true;
  }

  Future getServicesList() async {
    //if ()
    if (loading) {
      return;
    }
    loading = true;
    filteredServices.clear();
    allServices.clear();
    gAllServices.clear();
    var response = await http.post(
        Uri.parse(
            "https://adventuresclub.net/adventureClub/api/v1/get_allservices"),
        body: {
          "country_id": Constants.countryId.toString(), //id,
        });
    if (response.statusCode == 200) {
      var getServicesMap = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      List<dynamic> result = getServicesMap['data'];
      String acc = "";
      result.forEach((element) {
        List<ServicesModel> all_Services = [];
        acc = element['category'].toString() ?? "";
        categories.add(acc);
        List<dynamic> s = element['services'];
        s.forEach((services) {
          List<AvailabilityPlanModel> gAccomodationPlanModel = [];
          List<dynamic> availablePlan = services['availability'];
          availablePlan.forEach((ap) {
            AvailabilityPlanModel amPlan = AvailabilityPlanModel(
                ap['id'].toString() ?? "", ap['day'].toString() ?? "");
            gAccomodationPlanModel.add(amPlan);
          });
          List<AvailabilityModel> gAccomodoationAvaiModel = [];
          List<dynamic> available = services['availability'];
          available.forEach((a) {
            AvailabilityModel am = AvailabilityModel(
                a['start_date'].toString() ?? "",
                a['end_date'].toString() ?? "");
            gAccomodoationAvaiModel.add(am);
          });
          List<dynamic> becomePartner = services['become_partner'];
          becomePartner.forEach((b) {
            BecomePartner bp = BecomePartner(
                b['cr_name'].toString() ?? "",
                b['cr_number'].toString() ?? "",
                b['description'].toString() ?? "");
          });
          List<IncludedActivitiesModel> gIAm = [];
          List<dynamic> iActivities = services['included_activities'];
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
          List<dynamic> dependency = services['dependencies'];
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
          List<dynamic> aF = services['aimed_for'];
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
          List<dynamic> image = services['images'];
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
          List<dynamic> programs = services['programs'];
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
              DateTime.tryParse(services['start_date'].toString()) ??
                  DateTime.now();
          DateTime eDate = DateTime.tryParse(services['end_date'].toString()) ??
              DateTime.now();
          List<ServicesModel> aS = [];
          ServicesModel nSm = ServicesModel(
            int.tryParse(services['id'].toString()) ?? 0,
            int.tryParse(services['owner'].toString()) ?? 0,
            services['adventure_name'].toString() ?? "",
            services['country'].toString() ?? "",
            services['region'].toString() ?? "",
            services['city_id'].toString() ?? "",
            services['service_sector'].toString() ?? "",
            services['service_category'].toString() ?? "",
            services['service_type'].toString() ?? "",
            services['service_level'].toString() ?? "",
            services['duration'].toString() ?? "",
            int.tryParse(services['available_seats'].toString()) ?? 0,
            sDate,
            eDate,
            services['latitude'].toString() ?? "",
            services['longitude'].toString() ?? "",
            services['write_information'].toString() ?? "",
            int.tryParse(services['service_plan'].toString()) ?? 0,
            int.tryParse(services['sfor_id'].toString()) ?? 0,
            gAccomodoationAvaiModel,
            gAccomodationPlanModel,
            services['geo_location'].toString() ?? "",
            services['specific_address'].toString() ?? "",
            services['cost_inc'].toString() ?? "",
            services['cost_exc'].toString() ?? "",
            services['currency'].toString() ?? "",
            int.tryParse(services['points'].toString()) ?? 0,
            services['pre_requisites'].toString() ?? "",
            services['minimum_requirements'].toString() ?? "",
            services['terms_conditions'].toString() ?? "",
            int.tryParse(services['recommended'].toString()) ?? 0,
            services['status'].toString() ?? "",
            services['image'].toString() ?? "",
            services['descreption]'].toString() ?? "",
            services['favourite_image'].toString() ?? "",
            services['created_at'].toString() ?? "",
            services['updated_at'].toString() ?? "",
            services['delete_at'].toString() ?? "",
            int.tryParse(services['provider_id'].toString()) ?? 0,
            int.tryParse(services['service_id'].toString()) ?? 0,
            services['provided_name'].toString() ?? "",
            services['provider_profile'].toString() ?? "",
            services['including_gerea_and_other_taxes'].toString() ?? "",
            services['excluding_gerea_and_other_taxes'].toString() ?? "",
            gIAm,
            gdM,
            nBp,
            gAccomodationAimedfm,
            gPm,
            services['stars'].toString() ?? "",
            int.tryParse(services['is_liked'].toString()) ?? 0,
            services['baseurl'].toString() ?? "",
            gAccomodationServImgModel,
            element['rating'].toString() ?? "",
            services['reviewd_by'].toString() ?? "",
            int.tryParse(services['remaining_seats'].toString()) ?? 0,
          );
          allServices.add(nSm);
          all_Services.add(nSm);
        });
        HomeServicesModel adv = HomeServicesModel(acc, all_Services);
        gAllServices.add(adv);
        List<String> serviceId = [];
        List<String> adventureName = [];
        all_Services.forEach((element) {
          serviceId.add(element.id.toString());
          adventureName.add(element.adventureName);
        });
        searchedList.add(SearchModel(acc, serviceId, adventureName));
      });
      filteredServices = [...gAllServices];
      notifyListeners();
      // allServices.forEach((element) {
      //     gAllServices.add(element.serviceCategory, element);
      //   });
    }
    loading = false;
  }

  void getFilterList() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://adventuresclub.net/adventureClubDev/api/v1/filterServices'));
    request.fields.addAll({
      'country_id': '14',
      'min_price': '10',
      'max_price': '100',
      'sector_id': '1',
      'category_id': '4',
      'service_type': '1',
      'service_level': '1',
      'duration': '1'
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  // void getFilteredList() async {
  //   filteredServices.clear();
  //   try {
  //     var response = await http.post(
  //         Uri.parse(
  //             "https://adventuresclub.net/adventureClub/api/v1/services_filter"),
  //         body: {
  //           "category": "",
  //           "country": Constants.countryId.toString(),
  //           "provider_name": "",
  //           "region": "",
  //           "service_type": "",
  //           "level": "",
  //           "duration": "",
  //           "activity_id": "",
  //           "aimed": "",
  //         });
  //     var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  //     List<dynamic> rm = decodedResponse['data'];
  //     if (response.statusCode == 200) {
  //       var getServicesMap = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
  //       List<dynamic> result = getServicesMap['data'];
  //       String acc = "";
  //       result.forEach((element) {
  //         List<AvailabilityPlanModel> gAccomodationPlanModel = [];
  //         List<AvailabilityModel> gAccomodoationAvaiModel = [];
  //         List<ServicesModel> filter_Services = [];
  //         acc = element['category'].toString() ?? "";
  //         categories.add(acc);
  //         if (element['service_plan'] == 1) {
  //           List<dynamic> availablePlan = element['availability'];
  //           availablePlan.forEach((ap) {
  //             AvailabilityPlanModel amPlan = AvailabilityPlanModel(
  //                 ap['id'].toString() ?? "", ap['day'].toString() ?? "");
  //             gAccomodationPlanModel.add(amPlan);
  //           });
  //         } else {
  //           List<dynamic> available = element['availability'];
  //           available.forEach((a) {
  //             AvailabilityModel am = AvailabilityModel(
  //                 a['start_date'].toString() ?? "",
  //                 a['end_date'].toString() ?? "");
  //             gAccomodoationAvaiModel.add(am);
  //           });
  //         }
  //         List<dynamic> becomePartner = element['become_partner'];
  //         becomePartner.forEach((b) {
  //           BecomePartner bp = BecomePartner(
  //               b['cr_name'].toString() ?? "",
  //               b['cr_number'].toString() ?? "",
  //               b['description'].toString() ?? "");
  //         });
  //         List<IncludedActivitiesModel> gIAm = [];
  //         if (element['included_activities'] != null) {
  //           List<dynamic> iActivities = element['included_activities'];
  //           iActivities.forEach((iA) {
  //             IncludedActivitiesModel iAm = IncludedActivitiesModel(
  //               int.tryParse(iA['id'].toString()) ?? 0,
  //               int.tryParse(iA['service_id'].toString()) ?? 0,
  //               iA['activity_id'].toString() ?? "",
  //               iA['activity'].toString() ?? "",
  //               iA['image'].toString() ?? "",
  //             );
  //             gIAm.add(iAm);
  //           });
  //         }
  //         //List<DependenciesModel> gdM = [];
  //         // List<dynamic> dependency = element['dependencies'];
  //         // dependency.forEach((d) {
  //         //   DependenciesModel dm = DependenciesModel(
  //         //     int.tryParse(d['id'].toString()) ?? 0,
  //         //     d['dependency_name'].toString() ?? "",
  //         //     d['image'].toString() ?? "",
  //         //     d['updated_at'].toString() ?? "",
  //         //     d['created_at'].toString() ?? "",
  //         //     d['deleted_at'].toString() ?? "",
  //         //   );
  //         //   gdM.add(dm);
  //         // });
  //         List<AimedForModel> gAccomodationAimedfm = [];
  //         List<dynamic> aF = element['aimed_for'];
  //         aF.forEach((a) {
  //           AimedForModel afm = AimedForModel(
  //             int.tryParse(a['id'].toString()) ?? 0,
  //             a['AimedName'].toString() ?? "",
  //             a['image'].toString() ?? "",
  //             a['created_at'].toString() ?? "",
  //             a['updated_at'].toString() ?? "",
  //             a['deleted_at'].toString() ?? "",
  //             int.tryParse(a['service_id'].toString()) ?? 0,
  //           );
  //           gAccomodationAimedfm.add(afm);
  //         });
  //         List<ServiceImageModel> gAccomodationServImgModel = [];
  //         List<dynamic> image = element['images'];
  //         image.forEach((i) {
  //           ServiceImageModel sm = ServiceImageModel(
  //             int.tryParse(i['id'].toString()) ?? 0,
  //             int.tryParse(i['service_id'].toString()) ?? 0,
  //             int.tryParse(i['is_default'].toString()) ?? 0,
  //             i['image_url'].toString() ?? "",
  //             i['thumbnail'].toString() ?? "",
  //           );
  //           gAccomodationServImgModel.add(sm);
  //         });
  //         List<ProgrammesModel> gPm = [];
  //         List<dynamic> programs = element['programs'];
  //         programs.forEach((p) {
  //           ProgrammesModel pm = ProgrammesModel(
  //             int.tryParse(p['id'].toString()) ?? 0,
  //             int.tryParse(p['service_id'].toString()) ?? 0,
  //             p['title'].toString() ?? "",
  //             p['start_datetime'].toString() ?? "",
  //             p['end_datetime'].toString() ?? "",
  //             p['description'].toString() ?? "",
  //           );
  //           gPm.add(pm);
  //         });
  //         DateTime sDate =
  //             DateTime.tryParse(element['start_date'].toString()) ??
  //                 DateTime.now();
  //         DateTime eDate = DateTime.tryParse(element['end_date'].toString()) ??
  //             DateTime.now();
  //         List<ServicesModel> aS = [];
  //         ServicesModel nSm = ServicesModel(
  //           int.tryParse(element['id'].toString()) ?? 0,
  //           int.tryParse(element['owner'].toString()) ?? 0,
  //           element['adventure_name'].toString() ?? "",
  //           element['country'].toString() ?? "",
  //           element['region'].toString() ?? "",
  //           element['city_id'].toString() ?? "",
  //           element['service_sector'].toString() ?? "",
  //           element['service_category'].toString() ?? "",
  //           element['service_type'].toString() ?? "",
  //           element['service_level'].toString() ?? "",
  //           element['duration'].toString() ?? "",
  //           int.tryParse(element['available_seats'].toString()) ?? 0,
  //           sDate,
  //           eDate,
  //           element['latitude'].toString() ?? "",
  //           element['longitude'].toString() ?? "",
  //           element['write_information'].toString() ?? "",
  //           int.tryParse(element['service_plan'].toString()) ?? 0,
  //           int.tryParse(element['sfor_id'].toString()) ?? 0,
  //           gAccomodoationAvaiModel,
  //           gAccomodationPlanModel,
  //           element['geo_location'].toString() ?? "",
  //           element['specific_address'].toString() ?? "",
  //           element['cost_inc'].toString() ?? "",
  //           element['cost_exc'].toString() ?? "",
  //           element['currency'].toString() ?? "",
  //           int.tryParse(element['points'].toString()) ?? 0,
  //           element['pre_requisites'].toString() ?? "",
  //           element['minimum_requirements'].toString() ?? "",
  //           element['terms_conditions'].toString() ?? "",
  //           int.tryParse(element['recommended'].toString()) ?? 0,
  //           element['status'].toString() ?? "",
  //           element['image'].toString() ?? "",
  //           element['descreption]'].toString() ?? "",
  //           element['favourite_image'].toString() ?? "",
  //           element['created_at'].toString() ?? "",
  //           element['updated_at'].toString() ?? "",
  //           element['delete_at'].toString() ?? "",
  //           int.tryParse(element['provider_id'].toString()) ?? 0,
  //           int.tryParse(element['service_id'].toString()) ?? 0,
  //           element['provided_name'].toString() ?? "",
  //           element['provider_profile'].toString() ?? "",
  //           element['including_gerea_and_other_taxes'].toString() ?? "",
  //           element['excluding_gerea_and_other_taxes'].toString() ?? "",
  //           gIAm,
  //           gdM,
  //           nBp,
  //           gAccomodationAimedfm,
  //           gPm,
  //           element['stars'].toString() ?? "",
  //           int.tryParse(element['is_liked'].toString()) ?? 0,
  //           element['baseurl'].toString() ?? "",
  //           gAccomodationServImgModel,
  //           element['rating'].toString() ?? "",
  //           element['reviewd_by'].toString() ?? "",
  //           int.tryParse(element['remaining_seats'].toString()) ?? 0,
  //         );
  //         filterServices.add(nSm);
  //         filter_Services.add(nSm);
  //         HomeServicesModel adv = HomeServicesModel(acc, filter_Services);
  //         searchfilterServices.add(adv);
  //       });
  //       filteredServices = [...searchfilterServices];
  //       notifyListeners();
  //       // allServices.forEach((element) {
  //       //     gAllServices.add(element.serviceCategory, element);
  //       //   });
  //     }
  //     print(response.statusCode);
  //     print(response.body);
  //     print(response.headers);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future getServicesListy1() async {
    var response = await http.post(
        Uri.parse(
            "https://adventuresclub.net/adventureClub/api/v1/get_allservices"),
        body: {
          "country_id": Constants.countryId.toString(), //id,
        });
    if (response.statusCode == 200) {
      var getServicesMap = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      List<dynamic> result = getServicesMap['data'];
      result.forEach((element) {
        if (element['category'] == "Accomodation") {
          String acc = element['category'].toString() ?? "";
          List<dynamic> s = element['services'];
          s.forEach((services) {
            List<AvailabilityPlanModel> gAccomodationPlanModel = [];
            List<dynamic> availablePlan = services['availability'];
            availablePlan.forEach((ap) {
              AvailabilityPlanModel amPlan = AvailabilityPlanModel(
                  ap['id'].toString() ?? "", ap['day'].toString() ?? "");
              gAccomodationPlanModel.add(amPlan);
            });
            List<AvailabilityModel> gAccomodoationAvaiModel = [];
            List<dynamic> available = services['availability'];
            available.forEach((a) {
              AvailabilityModel am = AvailabilityModel(
                  a['start_date'].toString() ?? "",
                  a['end_date'].toString() ?? "");
              gAccomodoationAvaiModel.add(am);
            });
            List<dynamic> becomePartner = services['become_partner'];
            becomePartner.forEach((b) {
              BecomePartner bp = BecomePartner(
                  b['cr_name'].toString() ?? "",
                  b['cr_number'].toString() ?? "",
                  b['description'].toString() ?? "");
            });
            List<IncludedActivitiesModel> gIAm = [];
            List<dynamic> iActivities = services['included_activities'];
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
            List<dynamic> dependency = services['dependencies'];
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
            List<dynamic> aF = services['aimed_for'];
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
            List<dynamic> image = services['images'];
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
            List<dynamic> programs = services['programs'];
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
                DateTime.tryParse(services['start_date'].toString()) ??
                    DateTime.now();
            DateTime eDate =
                DateTime.tryParse(services['end_date'].toString()) ??
                    DateTime.now();
            ServicesModel nSm = ServicesModel(
              int.tryParse(services['id'].toString()) ?? 0,
              int.tryParse(services['owner'].toString()) ?? 0,
              services['adventure_name'].toString() ?? "",
              services['country'].toString() ?? "",
              services['region'].toString() ?? "",
              services['city_id'].toString() ?? "",
              services['service_sector'].toString() ?? "",
              services['service_category'].toString() ?? "",
              services['service_type'].toString() ?? "",
              services['service_level'].toString() ?? "",
              services['duration'].toString() ?? "",
              int.tryParse(services['available_seats'].toString()) ?? 0,
              sDate,
              eDate,
              //int.tryParse(services['start_date'].toString()) ?? "",
              //int.tryParse(services['end_date'].toString()) ?? "",
              services['latitude'].toString() ?? "",
              services['longitude'].toString() ?? "",
              services['write_information'].toString() ?? "",
              int.tryParse(services['service_plan'].toString()) ?? 0,
              int.tryParse(services['sfor_id'].toString()) ?? 0,
              gAccomodoationAvaiModel,
              gAccomodationPlanModel,
              services['geo_location'].toString() ?? "",
              services['specific_address'].toString() ?? "",
              services['cost_inc'].toString() ?? "",
              services['cost_exc'].toString() ?? "",
              services['currency'].toString() ?? "",
              int.tryParse(services['points'].toString()) ?? 0,
              services['pre_requisites'].toString() ?? "",
              services['minimum_requirements'].toString() ?? "",
              services['terms_conditions'].toString() ?? "",
              int.tryParse(services['recommended'].toString()) ?? 0,
              services['status'].toString() ?? "",
              services['image'].toString() ?? "",
              services['descreption]'].toString() ?? "",
              services['favourite_image'].toString() ?? "",
              services['created_at'].toString() ?? "",
              services['updated_at'].toString() ?? "",
              services['delete_at'].toString() ?? "",
              int.tryParse(services['provider_id'].toString()) ?? 0,
              int.tryParse(services['service_id'].toString()) ?? 0,
              services['provided_name'].toString() ?? "",
              services['provider_profile'].toString() ?? "",
              services['including_gerea_and_other_taxes'].toString() ?? "",
              services['excluding_gerea_and_other_taxes'].toString() ?? "",
              gIAm,
              gdM,
              nBp,
              gAccomodationAimedfm,
              gPm,
              services['stars'].toString() ?? "",
              int.tryParse(services['is_liked'].toString()) ?? 0,
              services['baseurl'].toString() ?? "",
              gAccomodationServImgModel,
              element['rating'].toString() ?? "",
              services['reviewd_by'].toString() ?? "",
              int.tryParse(services['remaining_seats'].toString()) ?? 0,
            );
            //gAccomodationSModel.add(nSm);
            allServices.add(nSm);
            allAccomodation.add(nSm);
          });
          HomeServicesModel adv = HomeServicesModel(acc, gAccomodationSModel);
          gAllServices.add(adv);
          // accomodation.add(adv);
          // accomodation.forEach((acco) {
          //   gm.add(acco);
          // });
        } else if (element['category'] == "Transport") {
          String acc = element['category'].toString() ?? "";
          List<dynamic> t = element['services'];
          t.forEach((tServices) {
            List<AvailabilityPlanModel> gTransportPlanModel = [];
            List<dynamic> availablePlan = tServices['availability'];
            availablePlan.forEach((ap) {
              AvailabilityPlanModel tPlan = AvailabilityPlanModel(
                  ap['id'].toString() ?? "", ap['day'].toString() ?? "");
              gTransportPlanModel.add(tPlan);
            });
            List<AvailabilityModel> gTransportAvaiModel = [];
            List<dynamic> tAvailable = tServices['availability'];
            tAvailable.forEach((aS) {
              AvailabilityModel tAM = AvailabilityModel(
                  aS['start_date'].toString() ?? "",
                  aS['end_date'].toString() ?? "");
              gTransportAvaiModel.add(tAM);
            });
            List<dynamic> tBecomePartner = tServices['become_partner'];
            tBecomePartner.forEach((bS) {
              BecomePartner transportBp = BecomePartner(
                  bS['cr_name'].toString() ?? "",
                  bS['cr_number'].toString() ?? "",
                  bS['description'].toString() ?? "");
            });
            List<IncludedActivitiesModel> gIAm = [];
            List<dynamic> iActivities = tServices['included_activities'];
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
            List<dynamic> dependency = tServices['dependencies'];
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
            List<AimedForModel> gTransportAimedfm = [];
            List<dynamic> tAimedFor = tServices['aimed_for'];
            tAimedFor.forEach((atransport) {
              AimedForModel transportAimed = AimedForModel(
                int.tryParse(atransport['id'].toString()) ?? 0,
                atransport['AimedName'].toString() ?? "",
                atransport['image'].toString() ?? "",
                atransport['created_at'].toString() ?? "",
                atransport['updated_at'].toString() ?? "",
                atransport['deleted_at'].toString() ?? "",
                int.tryParse(atransport['service_id'].toString()) ?? 0,
              );
              gTransportAimedfm.add(transportAimed);
            });
            List<ServiceImageModel> gTransportServImgModel = [];
            List<dynamic> timage = tServices['images'];
            timage.forEach((ti) {
              ServiceImageModel transportServiceImage = ServiceImageModel(
                int.tryParse(ti['id'].toString()) ?? 0,
                int.tryParse(ti['service_id'].toString()) ?? 0,
                int.tryParse(ti['is_default'].toString()) ?? 0,
                ti['image_url'].toString() ?? "",
                ti['thumbnail'].toString() ?? "",
              );
              gTransportServImgModel.add(transportServiceImage);
            });
            List<ProgrammesModel> gPm = [];
            List<dynamic> programs = tServices['programs'];
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
                DateTime.tryParse(tServices['start_date'].toString()) ??
                    DateTime.now();
            DateTime eDate =
                DateTime.tryParse(tServices['end_date'].toString()) ??
                    DateTime.now();
            ServicesModel tServicesModelList = ServicesModel(
              int.tryParse(tServices['id'].toString()) ?? 0,
              int.tryParse(tServices['owner'].toString()) ?? 0,
              tServices['adventure_name'].toString() ?? "",
              tServices['country'].toString() ?? "",
              tServices['region'].toString() ?? "",
              tServices['city_id'].toString() ?? "",
              tServices['service_sector'].toString() ?? "",
              tServices['service_category'].toString() ?? "",
              tServices['service_type'].toString() ?? "",
              tServices['service_level'].toString() ?? "",
              tServices['duration'].toString() ?? "",
              int.tryParse(tServices['availability_seats'].toString()) ?? 0,
              sDate,
              eDate,
              tServices['latitude'].toString() ?? "",
              tServices['longitude'].toString() ?? "",
              tServices['write_information'].toString() ?? "",
              int.tryParse(tServices['service_plan'].toString()) ?? 0,
              int.tryParse(tServices['sfor_id'].toString()) ?? 0,
              gTransportAvaiModel,
              gTransportPlanModel,
              tServices['geo_location'].toString() ?? "",
              tServices['specific_address'].toString() ?? "",
              tServices['cost_inc'].toString() ?? "",
              tServices['cost_exc'].toString() ?? "",
              tServices['currency'].toString() ?? "",
              int.tryParse(tServices['points'].toString()) ?? 0,
              tServices['pre_requisites'].toString() ?? "",
              tServices['minimum_requirements'].toString() ?? "",
              tServices['terms_conditions'].toString() ?? "",
              int.tryParse(tServices['recommended'].toString()) ?? 0,
              tServices['status'].toString() ?? "",
              tServices['image'].toString() ?? "",
              tServices['descreption]'].toString() ?? "",
              tServices['favourite_image'].toString() ?? "",
              tServices['created_at'].toString() ?? "",
              tServices['updated_at'].toString() ?? "",
              tServices['delete_at'].toString() ?? "",
              int.tryParse(tServices['provider_id'].toString()) ?? 0,
              int.tryParse(tServices['service_id'].toString()) ?? 0,
              tServices['provided_name'].toString() ?? "",
              tServices['provider_profile'].toString() ?? "",
              tServices['including_gerea_and_other_taxes'].toString() ?? "",
              tServices['excluding_gerea_and_other_taxes'].toString() ?? "",
              gIAm,
              gdM,
              transportBp,
              gTransportAimedfm,
              gPm,
              tServices['stars'].toString() ?? "",
              int.tryParse(tServices['is_liked'].toString()) ?? 0,
              tServices['baseurl'].toString() ?? "",
              gTransportServImgModel,
              element['rating'].toString() ?? "",
              tServices['reviewd_by'].toString() ?? "",
              int.tryParse(tServices['remaining_seats'].toString()) ?? 0,
            );
            //gTransportSModel.add(tServicesModelList);
            allServices.add(tServicesModelList);
            allTransport.add(tServicesModelList);
          });
          HomeServicesModel transportList =
              HomeServicesModel(acc, gTransportSModel);
          gAllServices.add(transportList);
          //transport.add(transportList);
          // transport.forEach((trans) {
          //   gm.add(trans);
          // });
        } else if (element['category'] == "Sky") {
          String acc = element['category'].toString() ?? "";
          List<dynamic> skyList = element['services'];
          skyList.forEach((skyServices) {
            List<AvailabilityPlanModel> gSkyPlanModel = [];
            List<dynamic> availablePlan = skyServices['availability'];
            availablePlan.forEach((ap) {
              AvailabilityPlanModel skyPlan = AvailabilityPlanModel(
                  ap['id'].toString() ?? "", ap['day'].toString() ?? "");
              gSkyPlanModel.add(skyPlan);
            });
            List<AvailabilityModel> gSkyAvaiModel = [];
            List<dynamic> tAvailable = skyServices['availability'];
            tAvailable.forEach((skyAvailable) {
              AvailabilityModel tAM = AvailabilityModel(
                  skyAvailable['start_date'].toString() ?? "",
                  skyAvailable['end_date'].toString() ?? "");
              gSkyAvaiModel.add(tAM);
            });
            List<dynamic> skyBecomePartnerList = skyServices['become_partner'];
            skyBecomePartnerList.forEach((skyBecomePartner) {
              BecomePartner skyBp = BecomePartner(
                  skyBecomePartner['cr_name'].toString() ?? "",
                  skyBecomePartner['cr_number'].toString() ?? "",
                  skyBecomePartner['description'].toString() ?? "");
            });
            List<IncludedActivitiesModel> gIAm = [];
            List<dynamic> iActivities = skyServices['included_activities'];
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
            List<dynamic> dependency = skyServices['dependencies'];
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
            List<AimedForModel> gSkyAimedfm = [];
            List<dynamic> skyAimedForList = skyServices['aimed_for'];
            skyAimedForList.forEach((skyAimedFor) {
              AimedForModel skyAimed = AimedForModel(
                int.tryParse(skyAimedFor['id'].toString()) ?? 0,
                skyAimedFor['AimedName'].toString() ?? "",
                skyAimedFor['image'].toString() ?? "",
                skyAimedFor['created_at'].toString() ?? "",
                skyAimedFor['updated_at'].toString() ?? "",
                skyAimedFor['deleted_at'].toString() ?? "",
                int.tryParse(skyAimedFor['service_id'].toString()) ?? 0,
              );
              gSkyAimedfm.add(skyAimed);
            });
            List<ServiceImageModel> gSkyServImgModel = [];
            List<dynamic> skyImages = skyServices['images'];
            skyImages.forEach((skyImages) {
              ServiceImageModel skyServiceImage = ServiceImageModel(
                int.tryParse(skyImages['id'].toString()) ?? 0,
                int.tryParse(skyImages['service_id'].toString()) ?? 0,
                int.tryParse(skyImages['is_default'].toString()) ?? 0,
                skyImages['image_url'].toString() ?? "",
                skyImages['thumbnail'].toString() ?? "",
              );
              gSkyServImgModel.add(skyServiceImage);
            });
            List<ProgrammesModel> gPm = [];
            List<dynamic> programs = skyServices['programs'];
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
                DateTime.tryParse(skyServices['start_date'].toString()) ??
                    DateTime.now();
            DateTime eDate =
                DateTime.tryParse(skyServices['end_date'].toString()) ??
                    DateTime.now();
            ServicesModel skyServicesModelList = ServicesModel(
              int.tryParse(skyServices['id'].toString()) ?? 0,
              int.tryParse(skyServices['owner'].toString()) ?? 0,
              skyServices['adventure_name'].toString() ?? "",
              skyServices['country'].toString() ?? "",
              skyServices['region'].toString() ?? "",
              skyServices['city_id'].toString() ?? "",
              skyServices['service_sector'].toString() ?? "",
              skyServices['service_category'].toString() ?? "",
              skyServices['service_type'].toString() ?? "",
              skyServices['service_level'].toString() ?? "",
              skyServices['duration'].toString() ?? "",
              int.tryParse(skyServices['availability_seats'].toString()) ?? 0,
              sDate,
              eDate,
              skyServices['latitude'].toString() ?? "",
              skyServices['longitude'].toString() ?? "",
              skyServices['write_information'].toString() ?? "",
              int.tryParse(skyServices['service_plan'].toString()) ?? 0,
              int.tryParse(skyServices['sfor_id'].toString()) ?? 0,
              gSkyAvaiModel,
              gSkyPlanModel,
              skyServices['geo_location'].toString() ?? "",
              skyServices['specific_address'].toString() ?? "",
              skyServices['cost_inc'].toString() ?? "",
              skyServices['cost_exc'].toString() ?? "",
              skyServices['currency'].toString() ?? "",
              int.tryParse(skyServices['points'].toString()) ?? 0,
              skyServices['pre_requisites'].toString() ?? "",
              skyServices['minimum_requirements'].toString() ?? "",
              skyServices['terms_conditions'].toString() ?? "",
              int.tryParse(skyServices['recommended'].toString()) ?? 0,
              skyServices['status'].toString() ?? "",
              skyServices['image'].toString() ?? "",
              skyServices['descreption]'].toString() ?? "",
              skyServices['favourite_image'].toString() ?? "",
              skyServices['created_at'].toString() ?? "",
              skyServices['updated_at'].toString() ?? "",
              skyServices['delete_at'].toString() ?? "",
              int.tryParse(skyServices['provider_id'].toString()) ?? 0,
              int.tryParse(skyServices['service_id'].toString()) ?? 0,
              skyServices['provided_name'].toString() ?? "",
              skyServices['provider_profile'].toString() ?? "",
              skyServices['including_gerea_and_other_taxes'].toString() ?? "",
              skyServices['excluding_gerea_and_other_taxes'].toString() ?? "",
              gIAm,
              gdM,
              skyBp,
              gSkyAimedfm,
              gPm,
              skyServices['stars'].toString() ?? "",
              int.tryParse(skyServices['is_liked'].toString()) ?? 0,
              skyServices['baseurl'].toString() ?? "",
              gSkyServImgModel,
              element['rating'].toString() ?? "",
              skyServices['reviewd_by'].toString() ?? "",
              int.tryParse(skyServices['remaining_seats'].toString()) ?? 0,
            );
            // gSkyServicesModel.add(skyServicesModelList);
            allServices.add(skyServicesModelList);
            allSky.add(skyServicesModelList);
          });
          HomeServicesModel skyListHome =
              HomeServicesModel(acc, gSkyServicesModel);
          gAllServices.add(skyListHome);
        } else if (element['category'] == "Water") {
          String acc = element['category'].toString() ?? "";
          List<dynamic> waterList = element['services'];
          waterList.forEach((waterServices) {
            List<AvailabilityPlanModel> gWaterPlanModel = [];
            List<dynamic> availablePlan = waterServices['availability'];
            availablePlan.forEach((ap) {
              AvailabilityPlanModel waterPlan = AvailabilityPlanModel(
                  ap['id'].toString() ?? "", ap['day'].toString() ?? "");
              gWaterPlanModel.add(waterPlan);
            });
            List<AvailabilityModel> gWaterAvaiModel = [];
            List<dynamic> wAvailable = waterServices['availability'];
            wAvailable.forEach((waterAvailable) {
              AvailabilityModel wAM = AvailabilityModel(
                  waterAvailable['start_date'].toString() ?? "",
                  waterAvailable['end_date'].toString() ?? "");
              gWaterAvaiModel.add(wAM);
            });
            List<dynamic> waterBecomePartnerList =
                waterServices['become_partner'];
            waterBecomePartnerList.forEach((waterBecomePartner) {
              BecomePartner waterBp = BecomePartner(
                  waterBecomePartner['cr_name'].toString() ?? "",
                  waterBecomePartner['cr_number'].toString() ?? "",
                  waterBecomePartner['description'].toString() ?? "");
            });
            List<IncludedActivitiesModel> gIAm = [];
            List<dynamic> iActivities = waterServices['included_activities'];
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
            List<dynamic> dependency = waterServices['dependencies'];
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
            List<AimedForModel> gWaterAimedfm = [];
            List<dynamic> waterAimedForList = waterServices['aimed_for'];
            waterAimedForList.forEach((waterAimedFor) {
              AimedForModel waterAimed = AimedForModel(
                int.tryParse(waterAimedFor['id'].toString()) ?? 0,
                waterAimedFor['AimedName'].toString() ?? "",
                waterAimedFor['image'].toString() ?? "",
                waterAimedFor['created_at'].toString() ?? "",
                waterAimedFor['updated_at'].toString() ?? "",
                waterAimedFor['deleted_at'].toString() ?? "",
                int.tryParse(waterAimedFor['service_id'].toString()) ?? 0,
              );
              gWaterAimedfm.add(waterAimed);
            });
            List<ServiceImageModel> gWaterServImgModel = [];
            List<dynamic> waterImages = waterServices['images'];
            waterImages.forEach((waterImages) {
              ServiceImageModel waterServiceImage = ServiceImageModel(
                int.tryParse(waterImages['id'].toString()) ?? 0,
                int.tryParse(waterImages['service_id'].toString()) ?? 0,
                int.tryParse(waterImages['is_default'].toString()) ?? 0,
                waterImages['image_url'].toString() ?? "",
                waterImages['thumbnail'].toString() ?? "",
              );
              gWaterServImgModel.add(waterServiceImage);
            });
            List<ProgrammesModel> gPm = [];
            List<dynamic> programs = waterServices['programs'];
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
                DateTime.tryParse(waterServices['start_date'].toString()) ??
                    DateTime.now();
            DateTime eDate =
                DateTime.tryParse(waterServices['end_date'].toString()) ??
                    DateTime.now();
            ServicesModel waterServicesModelList = ServicesModel(
              int.tryParse(waterServices['id'].toString()) ?? 0,
              int.tryParse(waterServices['owner'].toString()) ?? 0,
              waterServices['adventure_name'].toString() ?? "",
              waterServices['country'].toString() ?? "",
              waterServices['region'].toString() ?? "",
              waterServices['city_id'].toString() ?? "",
              waterServices['service_sector'].toString() ?? "",
              waterServices['service_category'].toString() ?? "",
              waterServices['service_type'].toString() ?? "",
              waterServices['service_level'].toString() ?? "",
              waterServices['duration'].toString() ?? "",
              int.tryParse(waterServices['availability_seats'].toString()) ?? 0,
              sDate,
              eDate,
              waterServices['latitude'].toString() ?? "",
              waterServices['longitude'].toString() ?? "",
              waterServices['write_information'].toString() ?? "",
              int.tryParse(waterServices['service_plan'].toString()) ?? 0,
              int.tryParse(waterServices['sfor_id'].toString()) ?? 0,
              gWaterAvaiModel,
              gWaterPlanModel,
              waterServices['geo_location'].toString() ?? "",
              waterServices['specific_address'].toString() ?? "",
              waterServices['cost_inc'].toString() ?? "",
              waterServices['cost_exc'].toString() ?? "",
              waterServices['currency'].toString() ?? "",
              int.tryParse(waterServices['points'].toString()) ?? 0,
              waterServices['pre_requisites'].toString() ?? "",
              waterServices['minimum_requirements'].toString() ?? "",
              waterServices['terms_conditions'].toString() ?? "",
              int.tryParse(waterServices['recommended'].toString()) ?? 0,
              waterServices['status'].toString() ?? "",
              waterServices['image'].toString() ?? "",
              waterServices['descreption]'].toString() ?? "",
              waterServices['favourite_image'].toString() ?? "",
              waterServices['created_at'].toString() ?? "",
              waterServices['updated_at'].toString() ?? "",
              waterServices['delete_at'].toString() ?? "",
              int.tryParse(waterServices['provider_id'].toString()) ?? 0,
              int.tryParse(waterServices['service_id'].toString()) ?? 0,
              waterServices['provided_name'].toString() ?? "",
              waterServices['provider_profile'].toString() ?? "",
              waterServices['including_gerea_and_other_taxes'].toString() ?? "",
              waterServices['excluding_gerea_and_other_taxes'].toString() ?? "",
              gIAm,
              gdM,
              waterBp,
              gWaterAimedfm,
              gPm,
              waterServices['stars'].toString() ?? "",
              int.tryParse(waterServices['is_liked'].toString()) ?? 0,
              waterServices['baseurl'].toString() ?? "",
              gWaterServImgModel,
              element['rating'].toString() ?? "",
              waterServices['reviewd_by'].toString() ?? "",
              int.tryParse(waterServices['remaining_seats'].toString()) ?? 0,
            );
            // gWaterServicesModel.add(waterServicesModelList);
            allServices.add(waterServicesModelList);
            allWater.add(waterServicesModelList);
          });
          HomeServicesModel waterListHome =
              HomeServicesModel(acc, gWaterServicesModel);
          gAllServices.add(waterListHome);
        } else if (element['category'] == "LAND") {
          String acc = element['category'].toString() ?? "";
          List<dynamic> landList = element['services'];
          landList.forEach((landServices) {
            List<AvailabilityPlanModel> glandPlanModel = [];
            List<dynamic> availablePlan = landServices['availability'];
            availablePlan.forEach((ap) {
              AvailabilityPlanModel landPlan = AvailabilityPlanModel(
                  ap['id'].toString() ?? "", ap['day'].toString() ?? "");
              glandPlanModel.add(landPlan);
            });
            List<AvailabilityModel> gLandAvaiModel = [];
            List<dynamic> lAvailable = landServices['availability'];
            lAvailable.forEach((landAvailable) {
              AvailabilityModel lAM = AvailabilityModel(
                  landAvailable['start_date'].toString() ?? "",
                  landAvailable['end_date'].toString() ?? "");
              gLandAvaiModel.add(lAM);
            });
            List<dynamic> landBecomePartnerList =
                landServices['become_partner'];
            landBecomePartnerList.forEach((landBecomePartner) {
              BecomePartner landBp = BecomePartner(
                  landBecomePartner['cr_name'].toString() ?? "",
                  landBecomePartner['cr_number'].toString() ?? "",
                  landBecomePartner['description'].toString() ?? "");
            });
            List<IncludedActivitiesModel> gIAm = [];
            List<dynamic> iActivities = landServices['included_activities'];
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
            List<dynamic> dependency = landServices['dependencies'];
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
            List<AimedForModel> gLandAimedfm = [];
            List<dynamic> landAimedForList = landServices['aimed_for'];
            landAimedForList.forEach((landAimedFor) {
              AimedForModel landAimed = AimedForModel(
                int.tryParse(landAimedFor['id'].toString()) ?? 0,
                landAimedFor['AimedName'].toString() ?? "",
                landAimedFor['image'].toString() ?? "",
                landAimedFor['created_at'].toString() ?? "",
                landAimedFor['updated_at'].toString() ?? "",
                landAimedFor['deleted_at'].toString() ?? "",
                int.tryParse(landAimedFor['service_id'].toString()) ?? 0,
              );
              gLandAimedfm.add(landAimed);
            });
            List<ServiceImageModel> gLandServImgModel = [];
            List<dynamic> landImages = landServices['images'];
            landImages.forEach((lImages) {
              ServiceImageModel landServiceImage = ServiceImageModel(
                int.tryParse(lImages['id'].toString()) ?? 0,
                int.tryParse(lImages['service_id'].toString()) ?? 0,
                int.tryParse(lImages['is_default'].toString()) ?? 0,
                lImages['image_url'].toString() ?? "",
                lImages['thumbnail'].toString() ?? "",
              );
              gLandServImgModel.add(landServiceImage);
            });
            List<ProgrammesModel> gPm = [];
            List<dynamic> programs = landServices['programs'];
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
                DateTime.tryParse(landServices['start_date'].toString()) ??
                    DateTime.now();
            DateTime eDate =
                DateTime.tryParse(landServices['end_date'].toString()) ??
                    DateTime.now();
            ServicesModel landServicesModelList = ServicesModel(
              int.tryParse(landServices['id'].toString()) ?? 0,
              int.tryParse(landServices['owner'].toString()) ?? 0,
              landServices['adventure_name'].toString() ?? "",
              landServices['country'].toString() ?? "",
              landServices['region'].toString() ?? "",
              landServices['city_id'].toString() ?? "",
              landServices['service_sector'].toString() ?? "",
              landServices['service_category'].toString() ?? "",
              landServices['service_type'].toString() ?? "",
              landServices['service_level'].toString() ?? "",
              landServices['duration'].toString() ?? "",
              int.tryParse(landServices['availability_seats'].toString()) ?? 0,
              sDate,
              eDate,
              landServices['latitude'].toString() ?? "",
              landServices['longitude'].toString() ?? "",
              landServices['write_information'].toString() ?? "",
              int.tryParse(landServices['service_plan'].toString()) ?? 0,
              int.tryParse(landServices['sfor_id'].toString()) ?? 0,
              gLandAvaiModel,
              glandPlanModel,
              landServices['geo_location'].toString() ?? "",
              landServices['specific_address'].toString() ?? "",
              landServices['cost_inc'].toString() ?? "",
              landServices['cost_exc'].toString() ?? "",
              landServices['currency'].toString() ?? "",
              int.tryParse(landServices['points'].toString()) ?? 0,
              landServices['pre_requisites'].toString() ?? "",
              landServices['minimum_requirements'].toString() ?? "",
              landServices['terms_conditions'].toString() ?? "",
              int.tryParse(landServices['recommended'].toString()) ?? 0,
              landServices['status'].toString() ?? "",
              landServices['image'].toString() ?? "",
              landServices['descreption]'].toString() ?? "",
              landServices['favourite_image'].toString() ?? "",
              landServices['created_at'].toString() ?? "",
              landServices['updated_at'].toString() ?? "",
              landServices['delete_at'].toString() ?? "",
              int.tryParse(landServices['provider_id'].toString()) ?? 0,
              int.tryParse(landServices['service_id'].toString()) ?? 0,
              landServices['provided_name'].toString() ?? "",
              landServices['provider_profile'].toString() ?? "",
              landServices['including_gerea_and_other_taxes'].toString() ?? "",
              landServices['excluding_gerea_and_other_taxes'].toString() ?? "",
              gIAm,
              gdM,
              landBp,
              gLandAimedfm,
              gPm,
              landServices['stars'].toString() ?? "",
              int.tryParse(landServices['is_liked'].toString()) ?? 0,
              landServices['baseurl'].toString() ?? "",
              gLandServImgModel,
              element['rating'].toString() ?? "",
              landServices['reviewd_by'].toString() ?? "",
              int.tryParse(landServices['remaining_seats'].toString()) ?? 0,
            );
            // gLandServicesModel.add(landServicesModelList);
            allServices.add(landServicesModelList);
            allLand.add(landServicesModelList);
          });
          HomeServicesModel landListHome =
              HomeServicesModel(acc, gLandServicesModel);
          gAllServices.add(landListHome);
        } else {
          String acc = element['category'].toString() ?? "";
          List<dynamic> other = element['services'];
          other.forEach((otherElement) {
            List<AvailabilityPlanModel> gWaterPlanModel = [];
            List<dynamic> availablePlan = otherElement['availability'];
            availablePlan.forEach((ap) {
              AvailabilityPlanModel waterPlan = AvailabilityPlanModel(
                  ap['id'].toString() ?? "", ap['day'].toString() ?? "");
              gWaterPlanModel.add(waterPlan);
            });
            List<AvailabilityModel> gWaterAvaiModel = [];
            List<dynamic> wAvailable = otherElement['availability'];
            wAvailable.forEach((waterAvailable) {
              AvailabilityModel wAM = AvailabilityModel(
                  waterAvailable['start_date'].toString() ?? "",
                  waterAvailable['end_date'].toString() ?? "");
              gWaterAvaiModel.add(wAM);
            });
            List<dynamic> waterBecomePartnerList =
                otherElement['become_partner'];
            waterBecomePartnerList.forEach((waterBecomePartner) {
              BecomePartner waterBp = BecomePartner(
                  waterBecomePartner['cr_name'].toString() ?? "",
                  waterBecomePartner['cr_number'].toString() ?? "",
                  waterBecomePartner['description'].toString() ?? "");
            });
            List<IncludedActivitiesModel> gIAm = [];
            List<dynamic> iActivities = otherElement['included_activities'];
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
            List<dynamic> dependency = otherElement['dependencies'];
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
            List<AimedForModel> gWaterAimedfm = [];
            List<dynamic> waterAimedForList = otherElement['aimed_for'];
            waterAimedForList.forEach((waterAimedFor) {
              AimedForModel waterAimed = AimedForModel(
                int.tryParse(waterAimedFor['id'].toString()) ?? 0,
                waterAimedFor['AimedName'].toString() ?? "",
                waterAimedFor['image'].toString() ?? "",
                waterAimedFor['created_at'].toString() ?? "",
                waterAimedFor['updated_at'].toString() ?? "",
                waterAimedFor['deleted_at'].toString() ?? "",
                int.tryParse(waterAimedFor['service_id'].toString()) ?? 0,
              );
              gWaterAimedfm.add(waterAimed);
            });
            List<ServiceImageModel> gWaterServImgModel = [];
            List<dynamic> waterImages = otherElement['images'];
            waterImages.forEach((waterImages) {
              ServiceImageModel waterServiceImage = ServiceImageModel(
                int.tryParse(waterImages['id'].toString()) ?? 0,
                int.tryParse(waterImages['service_id'].toString()) ?? 0,
                int.tryParse(waterImages['is_default'].toString()) ?? 0,
                waterImages['image_url'].toString() ?? "",
                waterImages['thumbnail'].toString() ?? "",
              );
              gWaterServImgModel.add(waterServiceImage);
            });
            List<ProgrammesModel> gPm = [];
            List<dynamic> programs = otherElement['programs'];
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
                DateTime.tryParse(otherElement['start_date'].toString()) ??
                    DateTime.now();
            DateTime eDate =
                DateTime.tryParse(otherElement['end_date'].toString()) ??
                    DateTime.now();
            ServicesModel otherModelList = ServicesModel(
              int.tryParse(otherElement['id'].toString()) ?? 0,
              int.tryParse(otherElement['owner'].toString()) ?? 0,
              otherElement['adventure_name'].toString() ?? "",
              otherElement['country'].toString() ?? "",
              otherElement['region'].toString() ?? "",
              otherElement['city_id'].toString() ?? "",
              otherElement['service_sector'].toString() ?? "",
              otherElement['service_category'].toString() ?? "",
              otherElement['service_type'].toString() ?? "",
              otherElement['service_level'].toString() ?? "",
              otherElement['duration'].toString() ?? "",
              int.tryParse(otherElement['availability_seats'].toString()) ?? 0,
              sDate,
              eDate,
              otherElement['latitude'].toString() ?? "",
              otherElement['longitude'].toString() ?? "",
              otherElement['write_information'].toString() ?? "",
              int.tryParse(otherElement['service_plan'].toString()) ?? 0,
              int.tryParse(otherElement['sfor_id'].toString()) ?? 0,
              gWaterAvaiModel,
              gWaterPlanModel,
              otherElement['geo_location'].toString() ?? "",
              otherElement['specific_address'].toString() ?? "",
              otherElement['cost_inc'].toString() ?? "",
              otherElement['cost_exc'].toString() ?? "",
              otherElement['currency'].toString() ?? "",
              int.tryParse(otherElement['points'].toString()) ?? 0,
              otherElement['pre_requisites'].toString() ?? "",
              otherElement['minimum_requirements'].toString() ?? "",
              otherElement['terms_conditions'].toString() ?? "",
              int.tryParse(otherElement['recommended'].toString()) ?? 0,
              otherElement['status'].toString() ?? "",
              otherElement['image'].toString() ?? "",
              otherElement['descreption]'].toString() ?? "",
              otherElement['favourite_image'].toString() ?? "",
              otherElement['created_at'].toString() ?? "",
              otherElement['updated_at'].toString() ?? "",
              otherElement['delete_at'].toString() ?? "",
              int.tryParse(otherElement['provider_id'].toString()) ?? 0,
              int.tryParse(otherElement['service_id'].toString()) ?? 0,
              otherElement['provided_name'].toString() ?? "",
              otherElement['provider_profile'].toString() ?? "",
              otherElement['including_gerea_and_other_taxes'].toString() ?? "",
              otherElement['excluding_gerea_and_other_taxes'].toString() ?? "",
              gIAm,
              gdM,
              waterBp,
              gWaterAimedfm,
              gPm,
              otherElement['stars'].toString() ?? "",
              int.tryParse(otherElement['is_liked'].toString()) ?? 0,
              otherElement['baseurl'].toString() ?? "",
              gWaterServImgModel,
              element['rating'].toString() ?? "",
              otherElement['reviewd_by'].toString() ?? "",
              int.tryParse(otherElement['remaining_seats'].toString()) ?? 0,
            );
            // gWaterServicesModel.add(waterServicesModelList);
            allServices.add(otherModelList);
          });
          HomeServicesModel otherHome = HomeServicesModel(acc, allServices);
          gAllServices.add(otherHome);
        }
      });
    }
    notifyListeners();
  }
}

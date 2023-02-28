import 'dart:developer';
import 'dart:io';
import 'package:adventuresclub/complete_profile/description.dart';
import 'package:adventuresclub/complete_profile/cost.dart';
import 'package:adventuresclub/complete_profile/banner_page.dart';
import 'package:adventuresclub/complete_profile/program.dart';
import 'package:adventuresclub/home_Screens/navigation_screens/bottom_navigation.dart';
import 'package:adventuresclub/models/category/category_model.dart';
import 'package:flutter/material.dart';

class CompleteProfileProvider with ChangeNotifier {
  CompleteProfileProvider({Key? key});
  int currentIndex = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController workPlaceController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController iLiveInController = TextEditingController();
  List<CategoryModel> pCM = [];
  String locationMessage = "Getting location ...";
  String userLocation = "";
  bool loading = false;
  double lat = 0;
  double lng = 0;
  File adventureOne = File("");
  File adventureTwo = File("");
  DateTime? selectedDate;
  String name = "";
  int countryId = 0;
  int id = 0;
  // var dateFormat = DateFormat.yMMMMd('en_US');
  List<String> mediaFiles = [];
  //

  int selectedRegionId = 0;
  String selectedRegion = "";
  int selectedSectorId = 0;
  String selectedSector = "";
  final List<Map<String, dynamic>> steps = [
    {
      'heading': 'Just follow simple four steps to list up your adventure',
      'child': const BannerPage()
    },
    {
      'heading': 'Just follow simple four steps to list up your adventure',
      'child': const Description()
    },
    {
      'heading': 'Just follow simple four steps to list up your adventure',
      'child': const Program()
    },
    {
      'heading': 'Just follow simple four steps to list up your adventure',
      'child': const Cost()
    },
  ];

  get lastStep => steps.length - 1;
  int currentStep = 0;
  int currentGenderIndex = 0;
  String selectedGender = '';

  void regionSelection(String region, int id) {
    selectedRegion = region;
    selectedRegionId = id;
    notifyListeners();
  }

  void sectorSelection(String region, int id) {
    selectedSector = region;
    selectedRegionId = id;
    notifyListeners();
  }

  void selectGender(
    int index,
    String gender,
  ) {
    currentGenderIndex = index;
    selectedGender = gender;
    notifyListeners();
  }
  // void nextScreen(BuildContext context) {
  //   if (currentIndex == 7) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => AddPhotos(),
  //       ),
  //     );
  //     currentIndex++;
  //   } else if (currentIndex == steps.length - 1) {
  //     // Navigator.push(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (_) => AddPhotos(),
  //     //   ),
  //     // );
  //   } else {
  //     currentIndex++;
  //   }
  //   notifyListeners();
  // }

  void nextStep(BuildContext context) {
    if (currentStep == 0) {
      currentStep++;
    } else if (currentStep == 1) {
      currentStep++;
    } else if (currentStep == 2) {
      currentStep++;
    } else if (currentStep == 3) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return const BottomNavigation();
      }));
    } else {
      currentStep--;
    }
    notifyListeners();
  }

  void back(BuildContext context) {
    if (currentStep == 3) {
      currentStep--;
    } else if (currentStep == 2) {
      currentStep--;
    } else if (currentStep == 1) {
      currentStep--;
    } else if (currentStep == 0) {
      Navigator.of(context).pop();
    } else {
      currentStep--;
    }
    notifyListeners();
  }
}
// void previousStep(BuildContext context) {
//     if (currentStep == 0) {
//       Navigator.pop(context);
//     } else {
//       currentStep--;
//     }
//     notifyListeners();
 
// }
  // Future<void> nextStep(BuildContext context) async {
  //   if (currentStep == 0) {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null &&
  //         profileURL.url != '' &&
  //         nameController.text.isNotEmpty &&
  //         dobController.text.isNotEmpty &&
  //         workPlaceController.text.isNotEmpty &&
  //         jobTitleController.text.isNotEmpty &&
  //         //aboutController.text.isNotEmpty &&
  //         selectedGender.isNotEmpty) {
  //       await FirebaseFirestore.instance
  //           .collection('profile')
  //           .doc(user.uid)
  //           .set(
  //         { 'profileURL': profileURL.url,
  //           'name': nameController.text.trim(),
  //           'dob': selectedDate,
  //           'workPlace': workPlaceController.text.trim(),
  //           'jobTitle': jobTitleController.text.trim(),
  //           'gender': selectedGender,
  //         },
  //         SetOptions(
  //           merge: true,
  //         ),
  //       ).then(
  //         (value) async {
  //           SharedPreferences prefs = await Constants.getPrefs();
  //           prefs.setString("profileURL", profileURL.url);
  //           prefs.setString('name', nameController.text);
  //           prefs.setString('workPlace', workPlaceController.text);
  //           prefs.setString('jobTitle', jobTitleController.text);
  //           prefs.setString('gender', selectedGender);
  //           prefs.setString('dob', selectedDate.toString());
  //           currentStep++;
  //         },
  //       ).catchError(
  //         (onError) {
  //           log(
  //             onError.toString(),
  //           );
  //         },
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Please fill all required fields!'),
  //       ));
  //     }
  //   } else if (currentStep == 1) {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null && aboutMeController.text.isNotEmpty) {
  //       await FirebaseFirestore.instance
  //           .collection('profile')
  //           .doc(user.uid)
  //           .set(
  //         {
  //           'aboutMe': aboutMeController.text.trim(),
  //         },
  //         SetOptions(
  //           merge: true,
  //         ),
  //       ).then(
  //         (value) async {
  //           SharedPreferences prefs = await Constants.getPrefs();
  //           prefs.setString('aboutMe', aboutMeController.text);
  //           currentStep++;
  //         },
  //       ).catchError(
  //         (onError) {
  //           log(
  //             onError.toString(),
  //           );
  //         },
  //       );
  //     } 
  //   }
  //   else if (currentStep == 2) {
  //       User? _user = FirebaseAuth.instance.currentUser;
  //       if (_user != null && lat != 0.0 && lng != 0.0) {
  //         // setState(() {
  //         //   locationMessage = 'Saving location';
  //         // });
  //         await FirebaseFirestore.instance
  //             .collection('profile')
  //             .doc(_user.uid)
  //             .set(
  //           {
  //             'location': {
  //               'lat': lat,
  //               'lng': lng,
  //             },
  //             'locationText': userLocation,
  //           },
  //           SetOptions(
  //             merge: true,
  //           ),
  //         ).then(
  //           (value) async {
  //             SharedPreferences _pref = await Constants.getPrefs();
  //             _pref.setString('location', locationMessage);
  //             _pref.setDouble('lat', lat);
  //             _pref.setDouble('lng', lng);
  //             _pref.setString('locationText', userLocation);
  //             Navigator.pushNamedAndRemoveUntil(
  //               context,
  //               AppLinks.bottomNavBar,
  //               (r) => r.isCurrent,
  //             );
  //           },
  //         ).catchError((onError) {
  //           log(onError.toString());
  //         });
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Please fill all required fields!'),
  //       ));
  //     }
  //   notifyListeners();
  // }

//   void updateStackIndex(int s) {
//     currentIndex = s;
//     notifyListeners();
//   }

 

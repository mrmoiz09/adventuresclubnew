import 'package:adventuresclub/constants.dart';
import 'package:adventuresclub/home_Screens/accounts/profile/profile_tab.dart';
import 'package:adventuresclub/widgets/buttons/button.dart';
import 'package:adventuresclub/widgets/my_text.dart';
import 'package:adventuresclub/widgets/text_fields/text_fields.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final bool? expired;
  final String? role;
  const Profile(this.expired, this.role, {super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controller = TextEditingController();
  abc() {}
  changePass() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2.3,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: MyText(
                          text: 'Change Password',
                          weight: FontWeight.w400,
                          color: blackColor,
                          size: 20,
                          fontFamily: 'Roboto'),
                    ),
                    const SizedBox(height: 20),
                    TextFields(
                        'Old Password', controller, 15, whiteColor, true),
                    TextFields(
                        'New Password', controller, 15, whiteColor, true),
                    TextFields('Confirm New Password', controller, 15,
                        whiteColor, true),
                    const SizedBox(height: 30),
                    Center(
                        child: Button(
                            'Save',
                            greenishColor,
                            greyColorShade400,
                            whiteColor,
                            16,
                            abc,
                            Icons.add,
                            whiteColor,
                            false,
                            1.5,
                            'Roboto',
                            FontWeight.w600,
                            16)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: greyProfileColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          elevation: 1.5,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset(
              'images/backArrow.png',
              height: 20,
            ),
          ),
          title: MyText(
            text: 'Profile',
            color: bluishColor,
            weight: FontWeight.bold,
          ),
          actions: [
            Icon(
              Icons.lock,
              color: greyColor.withOpacity(0.5),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      "${'https://adventuresclub.net/adventureClub/public/'}${Constants.profile.profileImage}"),
                ),
                const Positioned(
                    bottom: -10,
                    right: -10,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: bluishColor,
                      child: Image(
                        image: ExactAssetImage('images/camera.png'),
                        height: 16,
                        width: 16,
                      ),
                    ))
              ],
            ),
            Expanded(child: ProfileTab(widget.role)),
          ],
        ),

        // body: Center(
        //   child: SingleChildScrollView(
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Stack(
        //           clipBehavior: Clip.none,
        //           children: const [
        //             CircleAvatar(
        //               radius: 60,
        //               backgroundImage: ExactAssetImage('images/avatar2.png'),
        //             ),
        //             Positioned(
        //                 bottom: -10,
        //                 right: -10,
        //                 child: CircleAvatar(
        //                   radius: 25,
        //                   backgroundColor: bluishColor,
        //                   child: Image(
        //                     image: ExactAssetImage('images/camera.png'),
        //                     height: 22,
        //                     width: 22,
        //                   ),
        //                 ))
        //           ],
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.symmetric(
        //               horizontal: 8.0, vertical: 15),
        //           child: Column(
        //             children: [
        //               TextFields('Kenneth Gutierrez', controller, 15,
        //                   greyProfileColor, true),
        //               Divider(
        //                 indent: 4,
        //                 endIndent: 4,
        //                 color: greyColor.withOpacity(0.5),
        //               ),
        //               TextFields('+44-3658789456', controller, 15,
        //                   greyProfileColor, true),
        //               Divider(
        //                 indent: 4,
        //                 endIndent: 4,
        //                 color: greyColor.withOpacity(0.5),
        //               ),
        //               TextFields('demo@xyz.com', controller, 15,
        //                   greyProfileColor, true),
        //               Divider(
        //                 indent: 4,
        //                 endIndent: 4,
        //                 color: greyColor.withOpacity(0.5),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // )),
      ),
    );
  }
}

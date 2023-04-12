import 'package:adventuresclub/constants.dart';
import 'package:adventuresclub/widgets/Lists/reviews_list.dart';
import 'package:adventuresclub/widgets/my_text.dart';
import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  final String id;
  const Reviews(this.id, {super.key});

  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          text: 'Hill Climbing',
          color: bluishColor,
          weight: FontWeight.bold,
        ),
      ),
      backgroundColor: greyProfileColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [ReviewsList(widget.id)],
          ),
        ),
      ),
    );
  }
}

import 'package:adventuresclub/constants.dart';
import 'package:adventuresclub/home_Screens/accounts/client_requests.dart';
import 'package:adventuresclub/home_Screens/accounts/my_services.dart';
import 'package:adventuresclub/home_Screens/accounts/payment_methods.dart';
import 'package:adventuresclub/widgets/my_text.dart';
import 'package:adventuresclub/widgets/buttons/square_button.dart';
import 'package:flutter/material.dart';

class RequestsList extends StatefulWidget {
  const RequestsList({super.key});

  @override
  State<RequestsList> createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  abc(){

  }
  goToMakePayments(){
  Navigator.of(context).push(MaterialPageRoute(builder: (_){
    return const  PaymentMethods();
  }));
}
  goTo(){
  Navigator.of(context).push(MaterialPageRoute(builder: (_){
    return const  ClientsRequests();
  }));
 }
 goTo_(){
  Navigator.of(context).push(MaterialPageRoute(builder: (_){
    return const  MyServices();
  }));
 }
 List text =[
    'Provider Name :',
    'Booking Date :',
    'Activity Date :',
    'Registrations :',
    'Unit Cost :',
    'Total Cost :',
    'Payment Chanel :'
  ];
  List text2 =[
    'John Doe',
    '30 Sep, 2020',
    '05 Oct, 2020',
    '2 Adults, 3 Youngsters',
    '\$ 400.50',
    '\$ 1500.50',
    'Debit/Credit Card'
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 00),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: 7,
        
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return  Card(child: Padding(
               padding: const EdgeInsets.symmetric(vertical:20.0,horizontal: 10),
            child: Column(
              children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(text: 'Location Name',color: blackColor,),
                  
                  MyText(text: 'Confirmed',color: Colors.green,weight: FontWeight.bold,)
                ],
               ),

               const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                 const CircleAvatar(radius: 26,
                      backgroundImage: ExactAssetImage('images/airrides.png'),
                    ),
                     Padding(
          padding: const EdgeInsets.symmetric(horizontal:12.0,vertical: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                direction: Axis.vertical,
                children: List.generate(text.length, (index) {return 
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
           MyText(text: text[index],color: blackColor,weight: FontWeight.w500,size: 12,height: 1.8,),
           
           MyText(text:text2[index],color: greyColor,weight: FontWeight.w400,size: 12,height: 1.8,),
         
          ],);
          }),),
       
          
          const SizedBox(height:10),
           ],),
        ),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SquareButton('View Details', bluishColor, whiteColor, 3.7, 21, 11, goTo),
                  
                  SquareButton('Cancel Requests', Colors.red, whiteColor, 3.7, 21, 11, goTo_),
                  
                  SquareButton('Make Payment', greyShadeColor, whiteColor, 3.7, 21, 11, goToMakePayments),
                ],
              ),
            ],),
          ),);
        });
  }
}
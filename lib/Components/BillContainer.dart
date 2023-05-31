import 'package:Bookstore/Model/Bill.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:Bookstore/Pages/BoughtBooksPage/BoughtBooksPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BillContainer extends StatelessWidget {
  final Bill bill;
  final User user;
  const BillContainer({Key? key, required this.bill, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateTime = DateTime.parse(bill.time!);
    String time = '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BoughtBooksPage(bill: bill, user: user))
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${"bill_id".tr()} #${bill.id}'
              ),
              const SizedBox(
                  height: 5,
              ),
              Text(
                  '${"basket_id".tr()} #${bill.basket!.id}'
              ),
              const SizedBox(
                  height: 5,
              ),
              Text(
                  '${"status".tr()}: ${bill.status!.tr()}'
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                  '${"total".tr()}: ${bill.basket!.total}'
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                  '${"time".tr()}: $time'
              )
            ],
          ),
        ),
      ),
    );
  }
}

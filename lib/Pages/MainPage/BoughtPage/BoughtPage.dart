import 'package:Bookstore/APIs/BasketService.dart';
import 'package:Bookstore/Components/BillContainer.dart';
import 'package:Bookstore/Model/Bill.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BoughtPage extends StatefulWidget {
  final User user;
  const BoughtPage({Key? key, required this.user}) : super(key: key);

  @override
  State<BoughtPage> createState() => _BoughtPageState();
}

class _BoughtPageState extends State<BoughtPage> {

  List<Bill>? boughts;

  getBought() async{
    await BasketService.getAllBillsOfUser(widget.user.token).then(
            (value) => setState((){
          boughts = value;
        })
    );
  }

  @override
  void initState() {
    getBought();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    if(boughts == null) {
      return Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Image.asset(
              'assets/images/loader.gif',
              width: 200,
              height: 200,
            ),
          ),
        ),
      );
    }
    else if(boughts!.isEmpty){
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await getBought();
          },
          child: Container(
            color: Colors.white,
            child: Center(
                child: Text(
                  "there_is_no_bills".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 30
                  ),
                )
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('bills'.tr()),
        backgroundColor: Colors.green,
      ),
      body: Center(
          child: RefreshIndicator(
            onRefresh: () async {
              await getBought();
            },
            child: ListView.builder(
              itemCount: boughts!.length,
              itemBuilder: (BuildContext context, int index) {
                return BillContainer(
                  bill: boughts![index],
                  user: widget.user,
                );},
            ),
          )
      ),
    );
  }
}

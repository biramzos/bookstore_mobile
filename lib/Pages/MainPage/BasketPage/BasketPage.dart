// ignore_for_file: avoid_print
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:translator/translator.dart';
import 'package:Bookstore/APIs/BasketService.dart';
import 'package:Bookstore/APIs/BookService.dart';
import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Components/BookContainer.dart';
import 'package:flutter/material.dart';
import '../../../Model/Basket.dart';
import '../../../Model/Book.dart';
import '../../../Model/User.dart';
import 'package:easy_localization/easy_localization.dart';


class BasketPage extends StatefulWidget {
  final User data;
  const BasketPage({Key? key, required this.data}) : super(key: key);

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  BookService bookService = BookService();
  BasketService basketService = BasketService();
  UserService userService = UserService();
  Basket? basket;
  dynamic paymentIntent;

  @override
  void initState() {
    setState(() {
      getData();
    });
    super.initState();
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent,
              style: ThemeMode.dark,
              merchantDisplayName: 'QazaqBooks')).then((value){
      });
      displayPaymentSheet();
    } catch (e, s) {
      print('exception:$e$s');
    }
  }
  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet(
      ).then((value) async {
        await BasketService.generateBill(basket!.id, paymentIntent, "success", widget.data.token!);
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green,),
                      Text("pay_success".tr()),
                    ],
                  ),
                ],
              ),
            ));
        paymentIntent = null;
      }).onError((error, stackTrace){
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      await BasketService.generateBill(basket!.id, paymentIntent!, "cancel", widget.data.token!);
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("pay_cancel".tr()),
          ));
    } catch (e) {
      print('$e');
    }
  }
  createPaymentIntent() async {
    try {
      var response = await Dio().post(
        'http://localhost:8000/api/v1/baskets/${basket!.id}/create-customer-id',
        options: Options(
          headers: {
            "Authorization":"Bearer ${widget.data.token!}"
          }
        )
      );
      return response.data['clientSecret'];
    } catch (err) {
      print('Err charging user: ${err.toString()}');
    }
  }



  getData() async {
    await BasketService.getCurrentBasket(widget.data.token)
        .then(
            (value) => (setState((){
              basket = value!;
            })));
  }

  @override
  Widget build(BuildContext context) {
    if(basket == null){
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
    else if(basket!.books!.isEmpty){
      return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            getData();
          },
          child: Container(
            color: Colors.white,
            child: Center(
                child: Text(
                  "there_is_no_books".tr(),
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
      body: Column(
        children:[
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0
            ),
            child: Row(
              children: [
                Text(
                  '${'basket_id'.tr()}: #${basket!.id}'
                      '\n${'count_books'.tr()}: ${basket!.books!.length}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                Text(
                  '${'total'.tr()}: ${basket!.total} ₸',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          Container(
            height: 500,
            child: RefreshIndicator(
              onRefresh: () async {
                getData();
              },
              child: Center(
                child: ListView.builder(
                  itemCount: basket!.books!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return BookContainer(
                      book: basket!.books![index],
                      user: widget.data,
                    );},
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
          ),
          TextButton(
            onPressed: () {
              makePayment();
            },
            child: Container(
              width: 400,
              child: Text(
                "pay".tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white
                ),
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green),
              shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(color: Colors.green),
                  )
              ),
            ),
          )
        ]
      ),
    );
  }
}
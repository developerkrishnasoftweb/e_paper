import 'dart:ui';

import 'package:dio/dio.dart';
import '../constant/global.dart';
import '../services/urls.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';
import 'widgets/input.dart';

class EPaperPlans extends StatefulWidget {
  @override
  _EPaperPlansState createState() => _EPaperPlansState();
}

class _EPaperPlansState extends State<EPaperPlans> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<SubscriptionPlans> plans = [];
  SubscriptionPlans selectedPlan;
  Razorpay _razorpay;
  bool isLoading = false;
  String subscriptionPlanId = "", referralCode = "";

  setLoading(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  @override
  void initState() {
    super.initState();
    getSubscriptionPlans();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  getSubscriptionPlans() async {
    plans.clear();
    await Services.checkPlanValidity().then((value) {
      if (value.response) {
        setState(() {
          subscriptionPlanId = value.data[0]["subscription_plan_id"];
        });
      }
    });
    await Services.getSubscription().then((value) {
      for (int i = 0; i < value.data[0].length; i++) {
        setState(() {
          plans.add(SubscriptionPlans(
              title: value.data[0][i]["title"],
              id: value.data[0][i]["id"],
              features: value.data[0][i]["features"],
              planType: value.data[0][i]["plan_type"],
              planValidity: value.data[0][i]["plan_validity"],
              priceINR: value.data[0][i]["price_inr"],
              priceUSD: value.data[0][i]["price_usd"]));
        });
      }
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    FormData formData = FormData.fromMap({
      "razorpay_payment_id": response.paymentId,
      "razorpay_signature": response.signature,
      "reader_id": userdata.id,
      "plan_id": selectedPlan.id,
    });
    await Services.subscribe(formData).then((value) async {
      if (value.response) {
        await Services.getUserData();
        await Services.checkPlanValidity().then((value) {
          if (value.response) {
            setState(() {
              subscriptionPlanId = value.data[0]["subscription_plan_id"];
            });
          }
        });
        setLoading(false);
        showToastMessage(value.message);
      } else {
        setLoading(false);
        showToastMessage(value.message);
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setLoading(false);
    showToastMessage("Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setLoading(false);
    showToastMessage("Something went wrong");
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Subscription Plans",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
      ),
      body: plans.length > 0
          ? Column(
              children: [
                input(
                    text: "Referral Code",
                    margin: EdgeInsets.all(5),
                    onChanged: (v) => referralCode = v),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(5),
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 1 : 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 300 /
                            (orientation == Orientation.portrait ? 360 : 320)),
                    itemBuilder: (BuildContext context, int index) {
                      return buildSubscriptionCard(plans[index]);
                    },
                    itemCount: plans.length,
                    controller: ScrollController(keepScrollOffset: true),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  _buy(SubscriptionPlans plan) async {
    FocusScope.of(context).unfocus();
    setLoading(true);
    if (int.parse(plan.priceINR) == 0) {
      await Services.trialPlan(planId: plan.id).then((value) async {
        if (value.response) {
          await Services.checkPlanValidity().then((value) {
            if (value.response) {
              setState(() {
                subscriptionPlanId = value.data[0]["subscription_plan_id"];
              });
            }
          });
          setLoading(false);
          showToastMessage(value.message);
        } else {
          setLoading(false);
          showToastMessage(value.message);
        }
      });
    } else {
      FormData formData = FormData.fromMap({
        "reader_id": userdata.id,
        "plan_id": plan.id,
        "amount": (double.parse(plan.priceINR) * 100).round(),
        "currency": "INR",
        "referral_code": referralCode
      });
      await Services.generateOrderId(formData).then((value) {
        if (value.response) {
          var options = {
            'key': config.razorpayApiKey,
            'amount': (double.parse(plan.priceINR) * 100).round(),
            'name': 'Vishvasya Vrutantam',
            'order_id': value.data[0]["id"],
            'description': 'Subscription Plan',
            'image': Urls.assetBaseUrl + config.logo,
            'prefill': {'contact': userdata.mobile, 'email': userdata.email},
            'external': {
              'wallets': ['paytm']
            }
          };
          try {
            setState(() {
              selectedPlan = plan;
            });
            _razorpay.open(options);
          } catch (e) {
            setLoading(false);
            setState(() {
              selectedPlan = null;
            });
          }
        } else {
          setLoading(false);
          showToastMessage(value.message);
        }
      });
    }
    getSubscriptionPlans();
  }

  Widget buildSubscriptionCard(SubscriptionPlans plan) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
              color: Colors.black12, width: 1.5, style: BorderStyle.solid)),
      child: Column(
        children: [
          Container(
            height: size.height * 0.1,
            width: size.width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.02),
              border:
                  Border(bottom: BorderSide(color: Colors.black12, width: 1.5)),
            ),
            child: Text(
              "${plan.title}",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RichText(
            text: TextSpan(
                text: "\u20B9\t",
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 50.0,
                ),
                children: [
                  TextSpan(
                    text: "${plan.priceINR}",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 45.0,
                    ),
                  )
                ]),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Container(
                      height: 5,
                      width: 5,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black45),
                    )),
                TextSpan(
                  text: "${plan.planValidity} Days plan",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 20.0,
                  ),
                )
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Container(
                      height: 5,
                      width: 5,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black45),
                    )),
                TextSpan(
                    text: removeHtmlTags(data: plan.features),
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 20.0,
                    ))
              ]),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            alignment: isLoading ? Alignment.center : null,
            child: isLoading
                ? SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor),
                      strokeWidth: 2,
                    ),
                  )
                : FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: primaryColor)),
                    onPressed: subscriptionPlanId == plan.id
                        ? () {}
                        : () => _buy(plan),
                    child: Text(
                      subscriptionPlanId == plan.id ? "Activated" : "Buy Now",
                      style: TextStyle(
                          color: subscriptionPlanId == plan.id
                              ? Colors.white
                              : primaryColor,
                          fontSize: 18),
                    ),
                    splashColor: primarySwatch[100],
                    highlightColor: primarySwatch[100],
                    color: subscriptionPlanId == plan.id ? primaryColor : null,
                  ),
            height: 60,
            width: size.width * 0.7,
          )
        ],
      ),
    );
  }
}

class SubscriptionPlans {
  final String id, title, priceINR, priceUSD, features, planValidity, planType;

  SubscriptionPlans(
      {this.title,
      this.id,
      this.features,
      this.planType,
      this.planValidity,
      this.priceINR,
      this.priceUSD});
}

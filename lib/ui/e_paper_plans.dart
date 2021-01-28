import 'dart:ui';

import 'package:e_paper/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';
import '../constant/global.dart';

class EPaperPlans extends StatefulWidget {
  @override
  _EPaperPlansState createState() => _EPaperPlansState();
}

class _EPaperPlansState extends State<EPaperPlans> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<SubscriptionPlan> plans = [];

  @override
  void initState() {
    super.initState();
    getSubscriptionPlans();
  }

  getSubscriptionPlans() async {
    await Services.getSubscription().then((value) {
      for (int i = 0; i < value.data[0].length; i++) {
        setState(() {
          plans.add(SubscriptionPlan(
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

  @override
  Widget build(BuildContext context) {
    checkConnection(scaffoldKey: _scaffoldKey);
    Size size = MediaQuery.of(context).size;
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
          ? GridView.builder(
              padding: EdgeInsets.all(5),
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      300 / (orientation == Orientation.portrait ? 360 : 320)),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                          color: Colors.black12,
                          width: 1.5,
                          style: BorderStyle.solid)),
                  child: Column(
                    children: [
                      Container(
                        height: size.height * 0.1,
                        width: size.width,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.02),
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black12, width: 1.5)),
                        ),
                        child: Text(
                          "${plans[index].title}",
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
                                text: "${plans[index].priceINR}",
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
                          text: TextSpan(children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45),
                                )),
                            TextSpan(
                              text: "${plans[index].planValidity} Days plan",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 20.0,
                              ),
                            )
                          ]),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  height: 5,
                                  width: 5,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black45),
                                )),
                            TextSpan(
                              text: "${plans[index].features}",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 20.0,
                              ),
                            )
                          ]),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: primaryColor)),
                          onPressed: () {},
                          child: Text(
                            "Buy Now",
                            style: TextStyle(color: primaryColor, fontSize: 18),
                          ),
                          splashColor: primarySwatch[100],
                          highlightColor: primarySwatch[100],
                        ),
                        height: 60,
                        width: size.width * 0.7,
                      )
                    ],
                  ),
                );
              },
              itemCount: plans.length,
              controller: ScrollController(keepScrollOffset: true),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class SubscriptionPlan {
  final String id, title, priceINR, priceUSD, features, planValidity, planType;
  SubscriptionPlan(
      {this.title,
      this.id,
      this.features,
      this.planType,
      this.planValidity,
      this.priceINR,
      this.priceUSD});
}

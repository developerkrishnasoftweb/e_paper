class SubscriptionInfo {
  String id;
  String readerId;
  String subscriptionPlanId;
  String subscriptionPaymentId;
  String referralCode;
  String planTitle;
  String priceInr;
  String priceUsd;
  String features;
  String planType;
  String activatedAt;
  String expiredAt;
  String status;
  String createdAt;
  String updatedAt;

  SubscriptionInfo(
      {this.id,
        this.readerId,
        this.subscriptionPlanId,
        this.subscriptionPaymentId,
        this.referralCode,
        this.planTitle,
        this.priceInr,
        this.priceUsd,
        this.features,
        this.planType,
        this.activatedAt,
        this.expiredAt,
        this.status,
        this.createdAt,
        this.updatedAt});

  SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    readerId = json['reader_id'];
    subscriptionPlanId = json['subscription_plan_id'];
    subscriptionPaymentId = json['subscription_payment_id'];
    referralCode = json['referral_code'];
    planTitle = json['plan_title'];
    priceInr = json['price_inr'];
    priceUsd = json['price_usd'];
    features = json['features'];
    planType = json['plan_type'];
    activatedAt = json['activated_at'];
    expiredAt = json['expired_at'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reader_id'] = this.readerId;
    data['subscription_plan_id'] = this.subscriptionPlanId;
    data['subscription_payment_id'] = this.subscriptionPaymentId;
    data['referral_code'] = this.referralCode;
    data['plan_title'] = this.planTitle;
    data['price_inr'] = this.priceInr;
    data['price_usd'] = this.priceUsd;
    data['features'] = this.features;
    data['plan_type'] = this.planType;
    data['activated_at'] = this.activatedAt;
    data['expired_at'] = this.expiredAt;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
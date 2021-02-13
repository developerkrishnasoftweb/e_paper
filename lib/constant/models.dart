import 'global.dart';

class Config {
  String id,
      title,
      description,
      logo,
      aboutUs,
      aboutUsImage,
      backgroundImage,
      copyrightText,
      privacyPolicy,
      address,
      email,
      phone,
      visitor,
      razorpaySecretKey,
      razorpayApiKey,
      facebookSecretKey,
      facebookAppId,
      googleSecretKey,
      googleClientId;

  Config(
      this.id,
      this.title,
      this.description,
      this.logo,
      this.aboutUs,
      this.aboutUsImage,
      this.backgroundImage,
      this.copyrightText,
      this.privacyPolicy,
      this.address,
      this.email,
      this.phone,
      this.visitor,
      this.razorpaySecretKey,
      this.razorpayApiKey,
      this.facebookSecretKey,
      this.facebookAppId,
      this.googleSecretKey,
      this.googleClientId);

  Config.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.title = json["title"];
    this.description = json["description"];
    this.logo = json["logo"];
    this.aboutUs = json["about_us"];
    this.aboutUsImage = json["about_us_image"];
    this.backgroundImage = json["background_image"];
    this.copyrightText = json["copyright_text"];
    this.privacyPolicy = json["privacy_policy"];
    this.address = json["address"];
    this.email = json["email"];
    this.phone = json["phone"];
    this.visitor = json["visitor"];
    this.razorpaySecretKey = json["razorpay_secret_key"];
    this.razorpayApiKey = json["razorpay_api_key"];
    this.facebookSecretKey = json["facebook_secret_key"];
    this.facebookAppId = json["facebook_app_id"];
    this.googleSecretKey = json["google_secret_key"];
    this.googleClientId = json["google_client_id"];
  }
}

class Userdata {
  final String id,
      username,
      firstName,
      lastName,
      email,
      mobile,
      password,
      profileImage,
      refCode,
      subscriptionId;
  Userdata(
      {this.id,
        this.username,
        this.mobile,
        this.password,
        this.email,
        this.lastName,
        this.firstName,
        this.profileImage,
        this.refCode,
        this.subscriptionId});
  Userdata.fromJSON(Map<String, dynamic> json) : id = json[Params.id],
        username = json[Params.username],
        firstName = json[Params.firstName],
        lastName = json[Params.lastName],
        email = json[Params.email],
        mobile = json[Params.mobile],
        password = json[Params.password],
        profileImage = json[Params.profileImage],
        refCode = json[Params.refCode],
        subscriptionId = json[Params.subscriptionId];
}

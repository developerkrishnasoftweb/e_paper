import '../constant/global.dart';

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
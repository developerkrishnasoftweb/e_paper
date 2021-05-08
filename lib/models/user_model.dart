class Userdata {
  String id,
      firstName,
      lastName,
      username,
      email,
      mobile,
      password,
      profileImage,
      referralCode,
      subscriptionId,
      status,
      logoutAt,
      createdAt,
      updatedAt,
      fcmToken;

  Userdata(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.mobile,
      this.password,
      this.profileImage,
      this.referralCode,
      this.subscriptionId,
      this.status,
      this.logoutAt,
      this.createdAt,
      this.updatedAt,
      this.fcmToken});

  Userdata.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    username = json['username']?.toString();
    email = json['email']?.toString();
    mobile = json['mobile']?.toString();
    password = json['password']?.toString();
    profileImage = json['profile_image']?.toString();
    referralCode = json['referral_code']?.toString();
    subscriptionId = json['subscription_id']?.toString();
    status = json['status']?.toString();
    logoutAt = json['logout_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    fcmToken = json['fcm_token']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['profile_image'] = this.profileImage;
    data['referral_code'] = this.referralCode;
    data['subscription_id'] = this.subscriptionId;
    data['status'] = this.status;
    data['logout_at'] = this.logoutAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['fcm_token'] = this.fcmToken;
    return data;
  }
}

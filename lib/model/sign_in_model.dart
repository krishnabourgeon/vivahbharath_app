
import 'dart:convert';

SignInModel signInModelFromJson(String str) =>
    SignInModel.fromJson(json.decode(str));

String signInModelToJson(SignInModel data) =>
    json.encode(data.toJson());

class SignInModel {
  bool? status;
  String? message;
  SignInData? data;

  SignInModel({
    this.status,
    this.message,
    this.data,
  });

  factory SignInModel.fromJson(Map<String, dynamic> json) =>
      SignInModel(
        status: json['status'],
        message: json['message'],
        data: json['data'] == null
            ? null
            : SignInData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class SignInData {
  String? token;
  String? tokenType;
  SignInUser? user;
  bool? isApproved;
  String? approvalStatus;
  String? approvalMessage;
  String? approvalRemark;
  bool? registrationCompleted;

  /// Whether the member has already chosen a package. Null when the API
  /// doesn't say — the app then works it out (see routeAfterSignIn).
  bool? subscriptionChosen;

  String? mobile;
  int? otpExpiry;

  SignInData({
    this.token,
    this.tokenType,
    this.user,
    this.isApproved,
    this.approvalStatus,
    this.approvalMessage,
    this.approvalRemark,
    this.registrationCompleted,
    this.subscriptionChosen,
    this.mobile,
    this.otpExpiry,
  });

  factory SignInData.fromJson(Map<String, dynamic> json) =>
      SignInData(
        token: json['token'],
        tokenType: json['token_type'],
        user: json['user'] == null
            ? null
            : SignInUser.fromJson(json['user']),
        isApproved: json['is_approved'],
        approvalStatus: json['approval_status'],
        approvalMessage: json['approval_message'],
        approvalRemark: json['approval_remark'],
        registrationCompleted: json['registration_completed'],
        subscriptionChosen: subscriptionChosenFromJson(json),
        mobile: json['mobile'],
        otpExpiry: json['otp_expiry'],
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'token_type': tokenType,
        'user': user?.toJson(),
        'is_approved': isApproved,
        'approval_status': approvalStatus,
        'approval_message': approvalMessage,
        'approval_remark': approvalRemark,
        'registration_completed': registrationCompleted,
        'mobile': mobile,
        'otp_expiry': otpExpiry,
      };
}

class SignInUser {
  int? id;
  String? name;
  String? mobile;

  SignInUser({
    this.id,
    this.name,
    this.mobile,
  });

  factory SignInUser.fromJson(Map<String, dynamic> json) =>
      SignInUser(
        id: json['id'],
        name: json['name'],
        mobile: json['mobile'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'mobile': mobile,
      };
}

/// Reads "has the member picked a package?" from a sign-in response.
/// Returns null when none of the known keys are present.
bool? subscriptionChosenFromJson(Map<String, dynamic> json) {
  for (final k in const [
    'subscription_chosen',
    'has_subscription',
    'is_subscribed',
  ]) {
    final v = json[k];
    if (v is bool) return v;
    if (v is num) return v != 0;
  }
  if (json.containsKey('subscription_id')) {
    return json['subscription_id'] != null;
  }
  if (json.containsKey('subscription')) return json['subscription'] != null;
  return null;
}

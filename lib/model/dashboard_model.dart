
import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) =>
    json.encode(data.toJson());

class DashboardModel {
  String greeting;
  Profile profile;
  ProfileCompletion profileCompletion;
  Stats stats;
  ActivityCounts activityCounts;
  Messages notifications;
  Messages messages;
  Subscription subscription;
  Recommendations recommendations;
  List<DailyMatch> dailyMatches;
  List<DailyMatch> newMatches;
  List<dynamic> premiumMatches;
  List<DailyMatch> recentVisited;
  List<dynamic> fromYourSearch;

  DashboardModel({
    required this.greeting,
    required this.profile,
    required this.profileCompletion,
    required this.stats,
    required this.activityCounts,
    required this.notifications,
    required this.messages,
    required this.subscription,
    required this.recommendations,
    required this.dailyMatches,
    required this.newMatches,
    required this.premiumMatches,
    required this.recentVisited,
    required this.fromYourSearch,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      DashboardModel(
        greeting: json["greeting"],
        profile: Profile.fromJson(json["profile"]),
        profileCompletion:
            ProfileCompletion.fromJson(json["profile_completion"]),
        stats: Stats.fromJson(json["stats"]),
        activityCounts: ActivityCounts.fromJson(json["activity_counts"]),
        notifications: Messages.fromJson(json["notifications"]),
        messages: Messages.fromJson(json["messages"]),
        subscription: Subscription.fromJson(json["subscription"]),
        recommendations: Recommendations.fromJson(json["recommendations"]),
        dailyMatches: List<DailyMatch>.from(
            json["daily_matches"].map((x) => DailyMatch.fromJson(x))),
        newMatches: List<DailyMatch>.from(
            json["new_matches"].map((x) => DailyMatch.fromJson(x))),
        premiumMatches: List<dynamic>.from(json["premium_matches"].map((x) => x)),
        recentVisited: List<DailyMatch>.from(
            json["recent_visited"].map((x) => DailyMatch.fromJson(x))),
        fromYourSearch:
            List<dynamic>.from(json["from_your_search"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "greeting": greeting,
        "profile": profile.toJson(),
        "profile_completion": profileCompletion.toJson(),
        "stats": stats.toJson(),
        "activity_counts": activityCounts.toJson(),
        "notifications": notifications.toJson(),
        "messages": messages.toJson(),
        "subscription": subscription.toJson(),
        "recommendations": recommendations.toJson(),
        "daily_matches":
            List<dynamic>.from(dailyMatches.map((x) => x.toJson())),
        "new_matches": List<dynamic>.from(newMatches.map((x) => x.toJson())),
        "premium_matches": List<dynamic>.from(premiumMatches.map((x) => x)),
        "recent_visited":
            List<dynamic>.from(recentVisited.map((x) => x.toJson())),
        "from_your_search":
            List<dynamic>.from(fromYourSearch.map((x) => x)),
      };
}

class ActivityCounts {
  int whoViewedMe;
  int shortlistedMe;
  int myInterestAccepted;
  int myRequestApproved;
  int viewedByMe;
  int shortlistedByMe;
  int interestYouReceived;
  int requestYouReceived;
  int interestSent;
  int requestSent;

  ActivityCounts({
    required this.whoViewedMe,
    required this.shortlistedMe,
    required this.myInterestAccepted,
    required this.myRequestApproved,
    required this.viewedByMe,
    required this.shortlistedByMe,
    required this.interestYouReceived,
    required this.requestYouReceived,
    required this.interestSent,
    required this.requestSent,
  });

  factory ActivityCounts.fromJson(Map<String, dynamic> json) =>
      ActivityCounts(
        whoViewedMe: json["who_viewed_me"],
        shortlistedMe: json["shortlisted_me"],
        myInterestAccepted: json["my_interest_accepted"],
        myRequestApproved: json["my_request_approved"],
        viewedByMe: json["viewed_by_me"],
        shortlistedByMe: json["shortlisted_by_me"],
        interestYouReceived: json["interest_you_received"],
        requestYouReceived: json["request_you_received"],
        interestSent: json["interest_sent"],
        requestSent: json["request_sent"],
      );

  Map<String, dynamic> toJson() => {
        "who_viewed_me": whoViewedMe,
        "shortlisted_me": shortlistedMe,
        "my_interest_accepted": myInterestAccepted,
        "my_request_approved": myRequestApproved,
        "viewed_by_me": viewedByMe,
        "shortlisted_by_me": shortlistedByMe,
        "interest_you_received": interestYouReceived,
        "request_you_received": requestYouReceived,
        "interest_sent": interestSent,
        "request_sent": requestSent,
      };
}

class DailyMatch {
  int id;
  String profileId;
  String name;
  bool isNameHidden;
  int age;
  String? height;
  String profession;
  String city;
  String motherTongue;
  String? community;
  String location;
  String? imageUrl;
  bool isPhotoHidden;
  int photoCount;
  bool isVerified;
  bool isFeatured;
  bool isPaidMember;
  bool isOnline;
  String lastSeen;
  bool isShortlisted;
  int? interestStatus;
  bool alreadyConnected;
  Privacy privacy;

  DailyMatch({
    required this.id,
    required this.profileId,
    required this.name,
    required this.isNameHidden,
    required this.age,
    required this.height,
    required this.profession,
    required this.city,
    required this.motherTongue,
    required this.community,
    required this.location,
    required this.imageUrl,
    required this.isPhotoHidden,
    required this.photoCount,
    required this.isVerified,
    required this.isFeatured,
    required this.isPaidMember,
    required this.isOnline,
    required this.lastSeen,
    required this.isShortlisted,
    required this.interestStatus,
    required this.alreadyConnected,
    required this.privacy,
  });

  factory DailyMatch.fromJson(Map<String, dynamic> json) => DailyMatch(
        id: json["id"],
        profileId: json["profile_id"],
        name: json["name"],
        isNameHidden: json["is_name_hidden"],
        age: json["age"],
        height: json["height"],
        profession: json["profession"],
        city: json["city"],
        motherTongue: json["mother_tongue"],
        community: json["community"],
        location: json["location"],
        imageUrl: json["image_url"],
        isPhotoHidden: json["is_photo_hidden"],
        photoCount: json["photo_count"],
        isVerified: json["is_verified"],
        isFeatured: json["is_featured"],
        isPaidMember: json["is_paid_member"],
        isOnline: json["is_online"],
        lastSeen: json["last_seen"],
        isShortlisted: json["is_shortlisted"],
        interestStatus: json["interest_status"],
        alreadyConnected: json["already_connected"],
        privacy: Privacy.fromJson(json["privacy"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile_id": profileId,
        "name": name,
        "is_name_hidden": isNameHidden,
        "age": age,
        "height": height,
        "profession": profession,
        "city": city,
        "mother_tongue": motherTongue,
        "community": community,
        "location": location,
        "image_url": imageUrl,
        "is_photo_hidden": isPhotoHidden,
        "photo_count": photoCount,
        "is_verified": isVerified,
        "is_featured": isFeatured,
        "is_paid_member": isPaidMember,
        "is_online": isOnline,
        "last_seen": lastSeen,
        "is_shortlisted": isShortlisted,
        "interest_status": interestStatus,
        "already_connected": alreadyConnected,
        "privacy": privacy.toJson(),
      };
}

class Privacy {
  bool hideName;
  bool hidePhoto;
  bool hideHoroscope;
  bool hideMobile;
  bool canViewName;
  bool canViewPhoto;
  bool canViewHoroscope;
  bool canViewMobile;

  Privacy({
    required this.hideName,
    required this.hidePhoto,
    required this.hideHoroscope,
    required this.hideMobile,
    required this.canViewName,
    required this.canViewPhoto,
    required this.canViewHoroscope,
    required this.canViewMobile,
  });

  factory Privacy.fromJson(Map<String, dynamic> json) => Privacy(
        hideName: json["hide_name"],
        hidePhoto: json["hide_photo"],
        hideHoroscope: json["hide_horoscope"],
        hideMobile: json["hide_mobile"],
        canViewName: json["can_view_name"],
        canViewPhoto: json["can_view_photo"],
        canViewHoroscope: json["can_view_horoscope"],
        canViewMobile: json["can_view_mobile"],
      );

  Map<String, dynamic> toJson() => {
        "hide_name": hideName,
        "hide_photo": hidePhoto,
        "hide_horoscope": hideHoroscope,
        "hide_mobile": hideMobile,
        "can_view_name": canViewName,
        "can_view_photo": canViewPhoto,
        "can_view_horoscope": canViewHoroscope,
        "can_view_mobile": canViewMobile,
      };
}

class Messages {
  int unreadCount;

  Messages({required this.unreadCount});

  factory Messages.fromJson(Map<String, dynamic> json) =>
      Messages(unreadCount: json["unread_count"]);

  Map<String, dynamic> toJson() => {
        "unread_count": unreadCount,
      };
}

class Profile {
  int id;
  String name;
  String initial;
  String profileId;
  String imageUrl;
  bool isPremium;

  Profile({
    required this.id,
    required this.name,
    required this.initial,
    required this.profileId,
    required this.imageUrl,
    required this.isPremium,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        name: json["name"],
        initial: json["initial"],
        profileId: json["profile_id"],
        imageUrl: json["image_url"],
        isPremium: json["is_premium"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "initial": initial,
        "profile_id": profileId,
        "image_url": imageUrl,
        "is_premium": isPremium,
      };
}

class ProfileCompletion {
  int percentage;
  List<String> incompleteSections;

  ProfileCompletion({
    required this.percentage,
    required this.incompleteSections,
  });

  factory ProfileCompletion.fromJson(Map<String, dynamic> json) =>
      ProfileCompletion(
        percentage: json["percentage"],
        incompleteSections: List<String>.from(
            json["incomplete_sections"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "percentage": percentage,
        "incomplete_sections":
            List<dynamic>.from(incompleteSections.map((x) => x)),
      };
}

class Recommendations {
  String title;
  String subtitle;
  bool hasPartnerPreferences;
  List<DailyMatch> profiles;

  Recommendations({
    required this.title,
    required this.subtitle,
    required this.hasPartnerPreferences,
    required this.profiles,
  });

  factory Recommendations.fromJson(Map<String, dynamic> json) =>
      Recommendations(
        title: json["title"],
        subtitle: json["subtitle"],
        hasPartnerPreferences: json["has_partner_preferences"],
        profiles: List<DailyMatch>.from(
            json["profiles"].map((x) => DailyMatch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "has_partner_preferences": hasPartnerPreferences,
        "profiles": List<dynamic>.from(profiles.map((x) => x.toJson())),
      };
}

class Stats {
  int interestReceived;
  int interestAccepted;
  int contactsViewed;

  Stats({
    required this.interestReceived,
    required this.interestAccepted,
    required this.contactsViewed,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        interestReceived: json["interest_received"],
        interestAccepted: json["interest_accepted"],
        contactsViewed: json["contacts_viewed"],
      );

  Map<String, dynamic> toJson() => {
        "interest_received": interestReceived,
        "interest_accepted": interestAccepted,
        "contacts_viewed": contactsViewed,
      };
}

class Subscription {
  bool isPremium;
  String planName;

  Subscription({
    required this.isPremium,
    required this.planName,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        isPremium: json["is_premium"],
        planName: json["plan_name"],
      );

  Map<String, dynamic> toJson() => {
        "is_premium": isPremium,
        "plan_name": planName,
      };
}

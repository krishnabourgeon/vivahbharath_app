import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_config.dart';

class SharedPreferenceHelper {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    AppConfig.accessToken = token;
    log("SAVED TOKEN : $token");
  }

  static Future<void> saveCounterID(String counterID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("counter", counterID);
    AppConfig.counterID = counterID;
    log("SAVED COUNTER : $counterID");
  }

  static Future<String> getCounterID() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("counter") ?? "";
    log('counter $id');
    AppConfig.counterID = id;
    return id;
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    log(token);
    AppConfig.accessToken = token;
    return token;
  }

  static Future<void> clearWholeData() async {
    AppConfig.accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // Clears just the session token so the app treats the user as logged out.
  // Deliberately leaves "registration_complete" alone — a logged-out user on
  // a device that already finished onboarding should land back on the
  // sign-in screen next launch, not the new-user onboarding wizard.
  static Future<void> logout() async {
    AppConfig.accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("subscription_chosen");
    await prefs.remove("is_approved");
  }

  // Whether admin has approved the profile (from the sign-in response).
  // Defaults to true so members who logged in before this flag existed
  // aren't sent to the pending screen.
  static Future<void> saveApproved(bool approved) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("is_approved", approved);
  }

  static Future<bool> isApproved() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("is_approved") ?? true;
  }

  // Remembers that the signed-in member has picked a package, so the next
  // launch / login goes straight to the dashboard.
  static Future<void> saveSubscriptionChosen(bool chosen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("subscription_chosen", chosen);
  }

  static Future<bool> isSubscriptionChosen() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("subscription_chosen") ?? false;
  }

  // Marks that this device has finished the onboarding wizard at least once.
  // Backed by SharedPreferences, which is wiped on uninstall — so a fresh
  // install always starts at onboarding again, never auto-routed to sign-in.
  static Future<void> saveRegistrationComplete() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("registration_complete", true);
  }

  static Future<bool> isRegistrationComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("registration_complete") ?? false;
  }
}

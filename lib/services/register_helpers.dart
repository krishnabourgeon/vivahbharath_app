import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vivahbharath_app/model/dashboard_model.dart';
import 'package:vivahbharath_app/services/service_config.dart';
import 'package:vivahbharath_app/services/shared_preference_helper.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/dashboard_shell.dart';
import 'package:vivahbharath_app/view/register/basic_info_screen.dart';
import 'package:vivahbharath_app/view/register/profile_under_review_screen.dart';
import 'package:vivahbharath_app/view/drawer/subscription_screen.dart';

/// Short toast used for validation messages and API errors.
void showMsg(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 14,
  );
}

/// One dropdown / chip option coming from the API.
class Opt {
  const Opt(this.id, this.name);
  final int id;
  final String name;
}

extension OptList on List<Opt> {
  List<String> get names => map((e) => e.name).toList();

  /// Id of the option called [name] (exact match), or null.
  int? idOf(String? name) {
    if (name == null) return null;
    for (final o in this) {
      if (o.name == name) return o.id;
    }
    return null;
  }

  /// Name of the option with [id], or null.
  String? nameOf(int? id) {
    if (id == null) return null;
    for (final o in this) {
      if (o.id == id) return o.name;
    }
    return null;
  }

  /// Case-insensitive lookup that returns the API's own spelling.
  String? match(String? name) {
    if (name == null) return null;
    final n = name.trim().toLowerCase();
    for (final o in this) {
      if (o.name.trim().toLowerCase() == n) return o.name;
    }
    return null;
  }

  /// A Flutter dropdown asserts if its value isn't in its items, so only
  /// hand it a value that is currently in the list.
  String? valid(String? name) => any((o) => o.name == name) ? name : null;
}

/// Dims the screen and blocks taps while an API call is running.
/// Wrap a whole screen with it; nothing else about the layout changes.
class BusyOverlay extends StatelessWidget {
  const BusyOverlay({super.key, required this.busy, required this.child});

  final bool busy;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          if (busy)
            const Positioned.fill(
              child: AbsorbPointer(
                child: ColoredBox(
                  color: Color(0x33000000),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.tealB),
                  ),
                ),
              ),
            ),
        ],
      );
}

/// Called when the user finishes (or leaves early with "Submit now").
/// New members pick a package next; after that the "profile under review"
/// screen is shown.
Future<void> finishRegistration(BuildContext context) async {
  await SharedPreferenceHelper.saveRegistrationComplete();
  if (!context.mounted) return;
  showMsg('Registration completed');
  // Clear the sign-up steps so Back can't return into the form.
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const SubscriptionScreen(flow: SubscriptionFlow.afterSignUp),
    ),
    (r) => false,
  );
}

/// Has the signed-in member already picked a package?
///
/// Order: the sign-in response (when it says), then the flag saved on this
/// device, then the dashboard API's `subscription.plan_name`. If the
/// dashboard can't be reached we don't block the member — they go on to
/// the dashboard and can pick a plan from the drawer later.
Future<bool> resolveSubscriptionChosen({bool? fromApi}) async {
  if (fromApi != null) {
    await SharedPreferenceHelper.saveSubscriptionChosen(fromApi);
    return fromApi;
  }
  if (await SharedPreferenceHelper.isSubscriptionChosen()) return true;
  try {
    final res = await ServiceConfig().getDashboard();
    if (!res.isValue) return true;
    final sub = (res.asValue!.value as DashboardModel).subscription;
    final plan = sub?.planName?.toString().trim() ?? '';
    final chosen = (sub?.isPremium ?? false) || plan.isNotEmpty;
    await SharedPreferenceHelper.saveSubscriptionChosen(chosen);
    return chosen;
  } catch (e) {
    debugPrint('resolveSubscriptionChosen: $e');
    return true;
  }
}

/// Where to go after a successful sign in (OTP or password):
/// unfinished profiles resume registration, profiles still waiting for
/// admin approval see the "profile under review" screen, members without a
/// package go to the subscription screen, everyone else lands on the
/// dashboard.
Future<void> routeAfterSignIn(
  BuildContext context, {
  required bool registrationCompleted,
  bool? isApproved,
  bool? subscriptionChosen,
}) async {
  Widget next;
  if (isApproved != null) {
    await SharedPreferenceHelper.saveApproved(isApproved);
  }
  if (!registrationCompleted) {
    next = BasicInfoScreen();
  } else if (isApproved == false) {
    await SharedPreferenceHelper.saveRegistrationComplete();
    next = const ProfileUnderReviewScreen();
  } else {
    await SharedPreferenceHelper.saveRegistrationComplete();
    final chosen = await resolveSubscriptionChosen(fromApi: subscriptionChosen);
    next = chosen
        ? const DashboardShell()
        : const SubscriptionScreen(flow: SubscriptionFlow.afterLogin);
  }
  if (!context.mounted) return;
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => next),
    (r) => false,
  );
}

import 'package:flutter/material.dart';
import 'package:vivahbharath_app/function.dart';
import 'package:vivahbharath_app/model/chat_model.dart';
import 'package:vivahbharath_app/model/contacts_viewed_by_me_model.dart';
import 'package:vivahbharath_app/model/contacts_viewed_you_model.dart';
import 'package:vivahbharath_app/model/dashboard_model.dart';
import 'package:vivahbharath_app/model/all_matches_model.dart';
import 'package:vivahbharath_app/model/dont_show_matches_model.dart';
import 'package:vivahbharath_app/model/education_matches_model.dart';
import 'package:vivahbharath_app/model/error_response_model.dart';
import 'package:vivahbharath_app/model/family_matches_model.dart';
import 'package:vivahbharath_app/model/interest_received_all.dart';
import 'package:vivahbharath_app/model/interest_recevied_model.dart';
import 'package:vivahbharath_app/model/interest_send_model.dart';
import 'package:vivahbharath_app/model/match_profile.dart';
import 'package:vivahbharath_app/model/new_matches_model.dart';
import 'package:vivahbharath_app/model/online_matches_model.dart';
import 'package:vivahbharath_app/model/privacy_settings_body.dart';
import 'package:vivahbharath_app/model/privacy_settings_model.dart';
import 'package:vivahbharath_app/model/profession_matches_model.dart';
import 'package:vivahbharath_app/model/religion_match_model.dart';
import 'package:vivahbharath_app/model/request_model.dart';
import 'package:vivahbharath_app/model/request_send_model.dart';
import 'package:vivahbharath_app/model/respond_interest_model.dart';
import 'package:vivahbharath_app/model/respond_request_model.dart';
import 'package:vivahbharath_app/model/shortlist_model.dart';
import 'package:vivahbharath_app/model/shortlisted_by_you_model.dart';
import 'package:vivahbharath_app/model/shortlisted_you_model.dart';
import 'package:vivahbharath_app/model/viewed_by_me_model.dart';
import 'package:vivahbharath_app/model/viewed_me_model.dart';
import 'package:vivahbharath_app/services/provider_helper_class.dart';

class HomeProvider extends ProviderHelperClass with ChangeNotifier {
  DashboardModel? dashboardModel;
  AllMatchesModel? allMatchesModel;
  NewMatchesModel? newMatchesModel;
  ViewedByMeModel? viewedByMeModel;
  ViewedMeModel? viewedMeModel;
  ShortlistedByYouModel? shortlistedByYouModel;
  ShortlistedYouModel? shortlistedYouModel;
  ChatModel? chatModel;
  InterestReceivedAllModel? interestReceivedAllModel;
  InterestReceivedModel? interestReceivedModel;
  InterestSentModel? interestSendModel;
  RespondInterestModel? respondInterestModel;
  RequestModel? requestModel;
  RespondRequestModel? respondRequestModel;
  ShortListModel? shortListModel;
  RequestSendModel? requestSendModel;
  ContactsViewedByMeModel? contactsViewedByMeModel;
  ContactsViewedYouModel? contactsViewedYouModel;
  OnlineMatchesModel? onlineMatchesModel;
  ProfessionMatchesModel? professionMatchesModel;
  EducationMatchesModel? educationMatchesModel;
  FamilyMatchesModel? familyMatchesModel;
  ReligionMatchesModel? religionMatchesModel;
  DontShowMatchesModel? dontshowMatchesModel;

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  // ── Home dashboard (GET home) ─────────────────────────────────────────────
  // The home screen uses its own flags instead of [loaderState], which every
  // other call in this provider also flips.

  bool dashboardLoading = false;

  /// Message to show when the last dashboard fetch failed (null = no error).
  String? dashboardError;

  Future<void>? _dashboardInFlight;

  /// Loads the home dashboard. Concurrent calls share one request; the
  /// previous data stays on screen while a refresh is running.
  Future<void> getDashboard() => _dashboardInFlight ??= _fetchDashboard().whenComplete(() => _dashboardInFlight = null);

  Future<void> _fetchDashboard() async {
    dashboardLoading = true;
    dashboardError = null;
    notifyListeners();
    try {
      final network = await CommonFunctions.checkInternetConnection();
      if (!network) {
        dashboardError = 'No internet connection';
        return;
      }
      final res = await serviceConfig.getDashboard();
      final value = res.asValue?.value;
      if (value is DashboardModel) {
        dashboardModel = value;
      } else {
        final err = res.asError?.error;
        dashboardError = err is ErrorResponseModel ? (err.errorMessage ?? 'Something went wrong') : 'Something went wrong';
      }
    } catch (e) {
      debugPrint('exception in dashboard: $e');
      dashboardError = 'Something went wrong. Please try again';
    } finally {
      dashboardLoading = false;
      notifyListeners();
    }
  }

  final Set<String> _homeShortlistBusy = {};

  /// Toggles shortlist for a member card on the home screen.
  /// Returns the new state, or null if the request failed (state reverted).
  Future<bool?> toggleHomeShortlist(MatchProfile p) async {
    final id = p.apiId;
    if (id == null) return null;
    if (!_homeShortlistBusy.add(p.key)) return p.shortlisted;
    final before = p.shortlisted;
    _setHomeShortlisted(p, !before);
    try {
      final res = await serviceConfig.shorlist(id);
      final value = res.asValue?.value;
      if (value is ShortListModel) {
        final now = value.shortlisted ?? !before;
        _setHomeShortlisted(p, now);
        final counts = dashboardModel?.activityCounts;
        if (counts != null && now != before) {
          counts.shortlistedByMe = (counts.shortlistedByMe + (now ? 1 : -1)).clamp(0, 1 << 30);
          notifyListeners();
        }
        return now;
      }
    } catch (e) {
      debugPrint('exception in home shortlist: $e');
    } finally {
      _homeShortlistBusy.remove(p.key);
    }
    _setHomeShortlisted(p, before);
    return null;
  }

  /// The same member can appear in several home sections; keep them in sync.
  void _setHomeShortlisted(MatchProfile p, bool value) {
    for (final q in _allHomeProfiles()) {
      if (q.key == p.key) q.shortlisted = value;
    }
    p.shortlisted = value;
    notifyListeners();
  }

  /// Marks an interest as sent on every home card for this member.
  // TODO: call the send-interest endpoint once it exists in ServiceConfig
  // (the Matches tab only updates local state today as well).
  void markHomeInterestSent(MatchProfile p) {
    for (final q in _allHomeProfiles()) {
      if (q.key == p.key) q.status = InterestStatus.awaiting;
    }
    p.status = InterestStatus.awaiting;
    notifyListeners();
  }

  Iterable<MatchProfile> _allHomeProfiles() sync* {
    final d = dashboardModel;
    if (d == null) return;
    yield* d.recommendations.profiles;
    yield* d.premiumMatches;
    yield* d.fromYourSearch;
    yield* d.dailyMatches;
    yield* d.newMatches;
    yield* d.recentVisited;
  }

  Future<void> getAllMatches() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.getAllMatches();
        if (res.isValue) {
          allMatchesModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in all matches: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> getNewMatches() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.getNewMatches();
        if (res.isValue) {
          newMatchesModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in new matches: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> getViewedMe() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.getViewedMe();
        if (res.isValue) {
          viewedMeModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in viewed me: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> getViewedByMe() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.getViewedByMe();
        if (res.isValue) {
          viewedByMeModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in viewed by me: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> getShortlistedByYou() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.getShortlistedByYou();
        if (res.isValue) {
          shortlistedByYouModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in shortlisted by you: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> getShortlistedYou() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.getShortlistedYou();
        if (res.isValue) {
          shortlistedYouModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in shortlisted: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> getChat() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.getChat();
        if (res.isValue) {
          chatModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in chat: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> interestReceivedAll() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.interestReceivedAll();
        if (res.isValue) {
          interestReceivedAllModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in interest received all: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> interestReceived(int status) async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.interestReceived(status);
        if (res.isValue) {
          interestReceivedModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in interest received: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> interestSend(int status) async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.interestSend(status);
        if (res.isValue) {
          interestSendModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in interest send: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> respondInterest(int interestid, String status) async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.respondInterest(interestid, status);
        if (res.isValue) {
          respondInterestModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in interest respond: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> request(String type) async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.request(type);
        if (res.isValue) {
          requestModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in request: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> respondRequest(int requestid, String status) async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.requestRespond(requestid, status);
        if (res.isValue) {
          respondRequestModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in request respond: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> shortlist(int id) async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.shorlist(id);
        if (res.isValue) {
          shortListModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
          await getShortlistedByYou();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in shortlist: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> requestSend(String type) async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.requestSend(type);
        if (res.isValue) {
          requestSendModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in request send: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }


  Future<void> contactsViewedByMe() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.contactsViewedByMe();
        if (res.isValue) {
          contactsViewedByMeModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in contacts viewed by me: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }


  Future<void> contactsViewedByYou() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.contactsViewedByYou();
        if (res.isValue) {
          contactsViewedYouModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in contacts viewed by you: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

Future<void> onlineMatches() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.onlineMatches();
        if (res.isValue) {
          onlineMatchesModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in online matches: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }


  Future<void> professionMatches() async { 
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (network) {
      try {
        var res = await serviceConfig.professionMatches();
        if (res.isValue) {
          professionMatchesModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in profession matches: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
    
  }


  Future<void> educationMatches() async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if(network){
      try{
        var res = await serviceConfig.educationMatches();
        if (res.isValue) {
          educationMatchesModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in education matches: $e');
        updateLoadState(LoaderState.loaded);
      }
    }
  }

  Future<void> familyMatches() async{
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if(network){
      try{
        var res = await serviceConfig.familyMatches();
        if(res.isValue){
          familyMatchesModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in family matches: $e');
        updateLoadState(LoaderState.loaded);
        
      }
    }
  }



    Future<void> religionMatches() async{
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if(network){
      try{
        var res = await serviceConfig.religionMatches();
        if(res.isValue){
          religionMatchesModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in religion matches: $e');
        updateLoadState(LoaderState.loaded);
        
      }
    }
  }


  Future<void> dontShowMatches() async{
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if(network){
      try{
        var res = await serviceConfig.dontshowMatches();
        if(res.isValue){
          dontshowMatchesModel = res.asValue!.value;
          updateLoadState(LoaderState.loaded);

          notifyListeners();
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        debugPrint('exception in religion matches: $e');
        updateLoadState(LoaderState.loaded);
        
      }
    }
  }



  

  

  PrivacySettingsModel? privacySettingsModel;
  String? privacySettingsError;

  /// Saves the member's privacy flags (POST privacy-settings). On success
  /// [privacySettingsModel] holds the server's saved state; on failure
  /// [privacySettingsError] holds a message to show.
  ///
  /// TODO: there is no known endpoint to READ the current settings (GET
  /// privacy-settings returns 405). Add a fetch here once the backend
  /// exposes one; until then the screen seeds from [privacySettingsModel].
  Future<bool> privacySettings(PrivacySettingsBody body) async {
    updateLoadState(LoaderState.loading);
    final network = await CommonFunctions.checkInternetConnection();
    if (!network) {
      privacySettingsError = 'No internet connection';
      updateLoadState(LoaderState.loaded);
      return false;
    }
    try {
      var res = await serviceConfig.privacySettings(body);
      final result = res.asValue?.value ?? res.asError?.error;
      if (result is PrivacySettingsModel) {
        privacySettingsModel = result;
        privacySettingsError = null;
      } else if (result is ErrorResponseModel) {
        privacySettingsError = result.errorMessage ?? 'Something went wrong';
      }
      updateLoadState(LoaderState.loaded);
      notifyListeners();
      return res.isValue;
    } catch (e) {
      debugPrint('exception in privacySettings: $e');
      privacySettingsError = 'Something went wrong. Please try again';
      updateLoadState(LoaderState.loaded);
      return false;
    }
  }
}

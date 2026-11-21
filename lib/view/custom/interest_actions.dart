import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:vivahbharath_app/model/delete_withdraw_model.dart';
import 'package:vivahbharath_app/model/error_response_model.dart';
import 'package:vivahbharath_app/model/inbox_interest_model.dart';
import 'package:vivahbharath_app/model/match_profile.dart';
import 'package:vivahbharath_app/model/send_interest_model.dart';
import 'package:vivahbharath_app/model/withdraw_model.dart';
import 'package:vivahbharath_app/services/service_config.dart';

// Interest actions, called straight on the existing [ServiceConfig] methods
// so each screen gets the server's real result. Every function returns null
// on success, or a message to show the member.

final ServiceConfig _service = ServiceConfig();

/// Interests sent or withdrawn in this session, by member (user) id, so every
/// screen shows the same button for a member without waiting for a reload.
/// Wrap a Send Interest button in a `ListenableBuilder` on [sentInterests]
/// and read [interestStatusOf] / [sentInterests.stateOf] to stay in sync.
class SentInterests extends ChangeNotifier {
  final Map<int, bool> _sent = {};

  /// true = sent (awaiting response), false = withdrawn, null = no change
  /// in this session (use the status the API gave).
  bool? stateOf(int? memberId) => memberId == null ? null : _sent[memberId];

  void markSent(int memberId) => _set(memberId, true);
  void markWithdrawn(int memberId) => _set(memberId, false);

  void _set(int id, bool sent) {
    if (_sent[id] == sent) return;
    _sent[id] = sent;
    notifyListeners();
  }
}

final SentInterests sentInterests = SentInterests();

/// [p]'s interest status with this session's sends / withdraws applied.
InterestStatus interestStatusOf(MatchProfile p) =>
    applySentState(p.status, sentInterests.stateOf(p.apiId));

/// Applies a [SentInterests.stateOf] value to an API [status].
InterestStatus applySentState(InterestStatus status, bool? sent) {
  if (status == InterestStatus.accepted || sent == null) return status;
  if (sent) return InterestStatus.awaiting;
  return status == InterestStatus.awaiting ? InterestStatus.resend : status;
}

/// Receiver ids with a send in flight (stops double taps).
final Set<int> _sending = {};

/// `POST interests` — sends an interest to member [receiverId]. On success
/// every screen showing that member switches to "Awaiting Response".
Future<String?> sendInterestApi(int? receiverId) async {
  if (receiverId == null) return 'Could not send interest to this profile';
  if (!_sending.add(receiverId)) return 'Sending your interest…';
  try {
    final error = await _call(() => _service.sendInterest(receiverId),
        'Could not send interest. Please try again');
    if (error == null) sentInterests.markSent(receiverId);
    return error;
  } finally {
    _sending.remove(receiverId);
  }
}

/// `POST inbox/interests/{id}/respond` — accepts or declines a received interest.
Future<String?> respondInterestApi(Interest i, {required bool accept}) => _call(
      () => _service.respondInterest(
          accept ? 'accepted' : 'declined', '${i.interestId}'),
      accept
          ? 'Could not accept this interest. Please try again'
          : 'Could not decline this interest. Please try again',
    );

/// `POST inbox/interests/{id}/withdraw` — withdraws a sent, pending interest.
/// On success every screen showing that member offers "Resend interest".
Future<String?> withdrawInterestApi(Interest i) async {
  final error = await _call(
    () => _service.withdraw('${i.interestId}'),
    'Could not withdraw this interest. Please try again',
  );
  if (error == null && i.id != 0) sentInterests.markWithdrawn(i.id);
  return error;
}

/// `DELETE inbox/interests/withdrawn/{id}` — removes a withdrawn interest.
/// The withdraw response names withdrawn entries by log id, so that is used
/// when the list sends one.
Future<String?> deleteWithdrawnApi(Interest i) async {
  final error = await _call(
    () => _service.deleteWithdraw('${i.logId ?? i.interestId}'),
    'Could not delete this interest. Please try again',
  );
  if (error == null) _deleted.add(i.interestId);
  return error;
}

/// Withdrawn interests deleted in this session (by interest id), so their
/// Delete button stays hidden even if a reload still lists them.
final Set<int> _deleted = {};

/// Whether withdrawn interest [i] can still be deleted: not already removed
/// (by the server or in this session), and the member is allowed to.
bool canDeleteWithdrawn(Interest i) =>
    !i.isRemoved &&
    !_deleted.contains(i.interestId) &&
    (i.canDelete || i.isSent);

Future<String?> _call(Future<Result> Function() request, String fallback) async {
  try {
    final res = await request();
    if (res.isError) {
      final e = res.asError!.error;
      return e is ErrorResponseModel ? (e.errorMessage ?? fallback) : fallback;
    }
    final (ok, message) = switch (res.asValue!.value) {
      SendInterestModel m => (m.success, m.message),
      WithdrawModel m => (m.success, m.message),
      DeleteWithdrawModel m => (m.success, m.message),
      _ => (true, ''),
    };
    if (ok) return null;
    return message.isEmpty ? fallback : message;
  } catch (e) {
    debugPrint('interest action failed: $e');
    return fallback;
  }
}

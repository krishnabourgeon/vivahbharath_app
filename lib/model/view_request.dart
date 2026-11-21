/// What a member can ask another member to reveal (`POST requests/send`).
///
/// [apiValue] is sent as `request_type`; it matches the keys of the
/// `privacy` block in match responses (`can_view_name`, `can_view_photo`…).
enum ViewRequestType {
  name('name', 'Name', 'name'),
  photo('photo', 'Photo', 'photos'),
  horoscope('horoscope', 'Horoscope', 'horoscope'),
  mobile('mobile', 'Number', 'mobile number');

  const ViewRequestType(this.apiValue, this.label, this.noun);

  /// Value for the API's `request_type` field.
  final String apiValue;

  /// Button label, e.g. "Request Photo".
  final String label;

  /// Used in sentences, e.g. "your request to view this photos".
  final String noun;
}

/// The viewer's access to a member's private details, from the `privacy`
/// block of a match:
///
/// ```json
/// "privacy": {
///   "hide_name": false, "hide_photo": true, ...
///   "can_view_name": true, "can_view_photo": false, ...
/// }
/// ```
///
/// A section is locked when `can_view_*` is false. If the API leaves out a
/// `can_view_*` flag it falls back to "visible unless `hide_*` is true", so
/// lists without a privacy block show everything as before.
class ProfilePrivacy {
  const ProfilePrivacy({
    this.canViewName = true,
    this.canViewPhoto = true,
    this.canViewHoroscope = true,
    this.canViewMobile = true,
  });

  /// Everything visible — used when the API sends no privacy block.
  static const open = ProfilePrivacy();

  final bool canViewName;
  final bool canViewPhoto;
  final bool canViewHoroscope;
  final bool canViewMobile;

  factory ProfilePrivacy.fromJson(dynamic json) {
    if (json is! Map) return open;
    bool flag(String key) {
      final can = _bool(json['can_view_$key']);
      if (can != null) return can;
      return !(_bool(json['hide_$key']) ?? false);
    }

    return ProfilePrivacy(
      canViewName: flag('name'),
      canViewPhoto: flag('photo'),
      canViewHoroscope: flag('horoscope'),
      canViewMobile: flag('mobile'),
    );
  }

  bool canView(ViewRequestType t) => switch (t) {
    ViewRequestType.name => canViewName,
    ViewRequestType.photo => canViewPhoto,
    ViewRequestType.horoscope => canViewHoroscope,
    ViewRequestType.mobile => canViewMobile,
  };

  bool isLocked(ViewRequestType t) => !canView(t);

  static bool? _bool(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    return null;
  }
}

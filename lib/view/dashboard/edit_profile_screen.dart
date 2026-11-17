// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/custom/app_colors.dart';
// import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
// import 'package:vivahbharath_app/view/dashboard/search_screen.dart';


// // ─────────────────────────────────────────────────────────────────────────────
// //  Sample option lists — replace with values from your API.
// // ─────────────────────────────────────────────────────────────────────────────
// const kCreatedFor = ['Myself', 'Son', 'Daughter', 'Brother', 'Sister', 'Relative', 'Friend'];
// const kMarital = ['Never married', 'Divorced', 'Widow / Widower', 'Awaiting divorce', 'Annulled'];
// const kChildren = ['0', '1', '2', '3', '4', '5'];
// const kDiet = ['Vegetarian', 'Non-vegetarian', 'Eggetarian'];
// const kHabit = ['No', 'Occasionally', 'Yes'];
// const kYesNo = ['No', 'Yes'];
// const kHobbies = [
//   'Writing', 'Reading', 'Badminton', 'Cricket', 'Football', 'Tennis',
//   'Chess', 'Kabaddi', 'Carroms', 'Billiards', 'Swimming', 'Travelling',
//   'Trekking', 'Cinema', 'Watching TV', 'Gaming', 'Music', 'Cooking',
// ];
// const kBodyType = ['Slim', 'Average', 'Athletic', 'Heavy'];
// const kSkinType = ['Very fair', 'Fair', 'Wheatish', 'Dark'];
// const kBloodGroup = ['A+', 'A−', 'B+', 'B−', 'AB+', 'AB−', 'O+', 'O−'];
// const kReligion = ['Hindu', 'Muslim', 'Christian', 'Sikh', 'Jain', 'Buddhist'];
// const kCaste = ['Nair', 'Thiyya', 'Ezhava', 'Other'];
// const kSubCaste = ['Nambiar', 'Menon', 'Pillai', 'Kurup', 'Other'];
// const kGotra = ['Bharadwaj', 'Kashyap', 'Vasishtha', 'Other', "Don't know"];
// const kCountry = ['India', 'UAE', 'Saudi Arabia', 'Qatar', 'USA', 'UK'];
// const kState = ['Kerala', 'Tamil Nadu', 'Karnataka'];
// const kDistrict = [
//   'Thiruvananthapuram', 'Kollam', 'Pathanamthitta', 'Alappuzha', 'Kottayam',
//   'Idukki', 'Ernakulam', 'Thrissur', 'Palakkad', 'Malappuram', 'Kozhikode',
//   'Wayanad', 'Kannur', 'Kasaragod',
// ];
// const kQualification = ['Higher Secondary', 'Diploma', 'Bachelors Degree', 'Master Degree', 'Doctorate'];
// const kEmployment = [
//   'Healthcare', 'Information Technology', 'Farmer', 'Defence',
//   'Government / PSU', 'Private', 'Business', 'Self employed', 'Not working',
// ];
// const kOccupation = ['Software Engineer', 'Software Developer', 'Doctor', 'Teacher', 'Accountant', 'Designer', 'Business'];
// const kResidential = ['Citizen', 'Permanent Resident', 'Work Permit', 'Student Visa', 'Temporary Visa'];
// const kIncome = ['Below ₹3 Lakh', '₹3 – 5 Lakh', '₹5 – 10 Lakh', '₹10 – 20 Lakh', 'Above ₹20 Lakh'];
// const kLanguages = ['Malayalam', 'English', 'Hindi', 'Tamil', 'Kannada', 'Telugu', 'Arabic'];
// const kFamilyStatus = ['Middle class', 'Upper middle class', 'Rich', 'Affluent'];
// const kFamilyType = ['Nuclear family', 'Joint family'];
// const kFamilyValues = ['Traditional', 'Moderate', 'Liberal'];
// const kFamilyProperty = ['Below ₹25 Lakh', '₹25 – 50 Lakh', '₹50 Lakh – 1 Crore', 'Above ₹1 Crore'];
// final kTotalMembers = [for (var i = 1; i <= 15; i++) '$i'];
// const kParentOccupation = ['Employed', 'Business', 'Retired', 'Homemaker', 'Not employed', 'Passed away'];
// const kBirthStars = [
//   'Ashwathi', 'Bharani', 'Karthika', 'Rohini', 'Makayiram', 'Thiruvathira',
//   'Punartham', 'Pooyam', 'Ayilyam', 'Makam', 'Pooram', 'Uthram', 'Atham',
//   'Chithira', 'Chothi', 'Vishakham', 'Anizham', 'Thrikketta', 'Moolam',
//   'Pooradam', 'Uthradam', 'Thiruvonam', 'Avittam', 'Chathayam',
//   'Pooruruttathi', 'Uthrattathi', 'Revathi',
// ];
// const kHoroscopeMatch = ['Important', 'Preferable', 'Not Necessary', "Don't Want"];

// /// Sample profile — replace with the logged-in member's data.
// Map<String, Object?> sampleProfile() => {
//       'name': 'Ahana S Nair',
//       'createdFor': 'Myself',
//       'phone': '+91 [Mobile number]',
//       'phoneVerified': true,
//       'about':
//           'I am a simple and family-oriented individual with a positive outlook on life. '
//               'Enjoy music, travel, and spending time with close ones. '
//               'Looking for a genuine and understanding life partner.',
//       'dob': DateTime(2002, 5, 8),
//       'children': '0',
//       'pet': 'No',
//       'hobbies': <String>{},
//       'surgery': 'No',
//       'disability': 'No',
//       'religion': 'Hindu',
//       'caste': 'Nair',
//       'subCaste': 'Nambiar',
//       'nativeCountry': 'India',
//       'nativeState': 'Kerala',
//       'permCountry': 'India',
//       'permState': 'Kerala',
//       'permCity': 'Kozhikode',
//       'curCountry': 'India',
//       'curState': 'Kerala',
//       'qualification': 'Bachelors Degree',
//       'occupation': 'Software Developer',
//       'languages': <String>{},
//       'brothers': 0,
//       'brothersMarried': 0,
//       'sisters': 0,
//       'sistersMarried': 0,
//       'horoDob': DateTime(2002, 5, 8),
//     };

// // ─────────────────────────────────────────────────────────────────────────────
// //  Sections
// // ─────────────────────────────────────────────────────────────────────────────
// enum ProfileSection {
//   about('A few words about you', Icons.edit_outlined, 'about', ['about'], []),
//   basic('Basic details', Icons.person_outline_rounded, 'basic', [
//     'name', 'dob', 'height', 'weight', 'marital', 'children', 'diet',
//     'smoking', 'drinking', 'pet', 'hobbies',
//   ], ['dob', 'height', 'weight', 'marital']),
//   physical('Physical details', Icons.accessibility_new_rounded, 'physical', [
//     'bodyType', 'skinType', 'bloodGroup', 'surgery', 'disability',
//     'physicalNote',
//   ], []),
//   religion('Religion details', Icons.temple_hindu_outlined, 'religion',
//       ['religion', 'caste', 'subCaste', 'gotra'],
//       ['religion', 'caste', 'subCaste', 'gotra']),
//   location('Community & Location', Icons.location_on_outlined, 'location', [
//     'nativeCountry', 'nativeState', 'nativeCity',
//     'permCountry', 'permState', 'permCity',
//     'curCountry', 'curState', 'curCity',
//   ], []),
//   career('Education and career details', Icons.school_outlined, 'education', [
//     'qualification', 'educationNote', 'employment', 'occupation',
//     'workCountry', 'workState', 'workCity', 'residential', 'income',
//     'languages',
//   ], []),
//   family('Family details', Icons.home_outlined, 'family', [
//     'familyStatus', 'familyType', 'familyValues', 'familyProperty',
//     'totalMembers', 'fatherJob', 'motherJob',
//     'brothers', 'brothersMarried', 'sisters', 'sistersMarried',
//   ], []),
//   horoscope('Horoscope details', Icons.auto_awesome_outlined, 'horoscope', [
//     'horoDob', 'birthTime', 'birthPlace', 'birthStar', 'sudha', 'dosha',
//     'starMatchOnly', 'horoMatch',
//   ], []);

//   const ProfileSection(
//       this.title, this.icon, this.iconName, this.keys, this.requiredKeys);
//   final String title;
//   final IconData icon;
//   final String iconName;
//   final List<String> keys;
//   final List<String> requiredKeys;
// }

// const _sectionTint = <ProfileSection, Color>{
//   ProfileSection.about: AppColors.link,
//   ProfileSection.basic: AppColors.brown,
//   ProfileSection.physical: AppColors.purple,
//   ProfileSection.religion: AppColors.coral,
//   ProfileSection.location: AppColors.link,
//   ProfileSection.career: AppColors.brown,
//   ProfileSection.family: AppColors.purple,
//   ProfileSection.horoscope: AppColors.coral,
// };

// // ─────────────────────────────────────────────────────────────────────────────
// //  Edit Profile screen
// // ─────────────────────────────────────────────────────────────────────────────
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({
//     super.key,
//     this.initial,
//     this.onManagePhotos,
//     this.showBottomNav = true,
//   });

//   final Map<String, Object?>? initial;
//   final VoidCallback? onManagePhotos;
//   final bool showBottomNav;

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   late final Map<String, Object?> _saved = _clone(widget.initial ?? sampleProfile());
//   late final Map<String, Object?> _draft = _clone(_saved);
//   ProfileSection? _open = ProfileSection.about;
//   final Map<String, TextEditingController> _text = {};

//   static Map<String, Object?> _clone(Map<String, Object?> m) => {
//         for (final e in m.entries)
//           e.key: e.value is Set<String> ? {...(e.value as Set<String>)} : e.value,
//       };

//   @override
//   void dispose() {
//     for (final c in _text.values) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   T? _v<T>(String k) => _draft[k] as T?;
//   void _set(String k, Object? v) => setState(() => _draft[k] = v);

//   TextEditingController _ctrl(String k) => _text.putIfAbsent(
//       k, () => TextEditingController(text: (_draft[k] as String?) ?? ''));

//   void _cancel(ProfileSection s) {
//     setState(() {
//       for (final k in s.keys) {
//         final v = _saved[k];
//         _draft[k] = v is Set<String> ? {...v} : v;
//         _text[k]?.text = (v is String) ? v : '';
//       }
//       _open = null;
//     });
//   }

//   void _save(ProfileSection s) {
//     final missing = [
//       for (final k in s.requiredKeys)
//         if (_draft[k] == null || _draft[k] == '') k,
//     ];
//     if (missing.isNotEmpty) {
//       _snack('Please fill the fields marked *');
//       return;
//     }
//     setState(() {
//       for (final k in s.keys) {
//         final v = _draft[k];
//         _saved[k] = v is Set<String> ? {...v} : v;
//       }
//       _open = null;
//     });
//     // TODO: send the section's keys to your API.
//     _snack('${s.title} saved');
//   }

//   void _snack(String msg) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: AppColors.navy,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         content: Text(msg, style: const TextStyle(fontSize: 13)),
//       ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgBottom,
//       // bottomNavigationBar:
//       //     widget.showBottomNav ? const AppBottomNav(currentIndex: 4) : null,
//       body: DecoratedBox(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [AppColors.bgTop, AppColors.bgBottom],
//             stops: [0, 0.4],
//           ),
//         ),
//         child: SafeArea(
//           bottom: false,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SearchTopBar(title: 'Edit Profile'),
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
//                   children: [
//                     ProfileHeaderCard(
//                       data: _saved,
//                       buttonLabel: 'Add / Edit Photos',
//                       buttonIcon: Icons.photo_camera_outlined,
//                       onButton: widget.onManagePhotos ?? () {/* TODO */},
//                     ),
//                     const SizedBox(height: 14),
//                     for (final s in ProfileSection.values) ...[
//                       _Accordion(
//                         title: s.title,
//                         icon: s.icon,
//                         iconName: s.iconName,
//                         accent: _sectionTint[s]!,
//                         open: _open == s,
//                         onToggle: () =>
//                             setState(() => _open = _open == s ? null : s),
//                         onCancel: () => _cancel(s),
//                         onSave: () => _save(s),
//                         child: _sectionBody(s),
//                       ),
//                       const SizedBox(height: 10),
//                     ],
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ── Section bodies ───────────────────────────────────────────────────────
//   Widget _sectionBody(ProfileSection s) {
//     switch (s) {
//       case ProfileSection.about:
//         return _textArea('about', 'Tell matches about yourself, your family and what you are looking for',
//             maxLength: 1000, lines: 6);

//       case ProfileSection.basic:
//         final dob = _v<DateTime>('dob');
//         return _col([
//           _field('Name', _textField('name', 'Your name')),
//           _field(
//             'Age / Date of birth',
//             Row(
//               children: [
//                 Container(
//                   width: 76,
//                   height: 48,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: AppColors.bgBottom,
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: AppColors.fieldBorder),
//                   ),
//                   child: Text(
//                     dob == null ? '–' : '${_age(dob)} yrs',
//                     style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.navy),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: _DateField(
//                     value: dob,
//                     hint: 'DD-MM-YYYY',
//                     firstDate: DateTime(1950),
//                     lastDate: DateTime(DateTime.now().year - 18,
//                         DateTime.now().month, DateTime.now().day),
//                     onChanged: (d) => _set('dob', d),
//                   ),
//                 ),
//               ],
//             ),
//             isRequired: true,
//           ),
//           _select('Height', 'height', kHeightOptions, isRequired: true),
//           _select('Weight', 'weight', kWeightOptions, isRequired: true),
//           _select('Marital Status', 'marital', kMarital, isRequired: true),
//           _select('Number of Children', 'children', kChildren),
//           _select('Diet', 'diet', kDiet),
//           _select('Smoking', 'smoking', kHabit),
//           _select('Drinking', 'drinking', kHabit),
//           _select('Have Pet', 'pet', kYesNo),
//           _field(
//             'Hobbies & Interests',
//             MultiSelectField(
//               hint: 'Select hobbies',
//               title: 'Hobbies & Interests',
//               options: kHobbies,
//               values: _v<Set<String>>('hobbies') ?? {},
//               onChanged: (v) => _set('hobbies', v),
//             ),
//           ),
//         ]);

//       case ProfileSection.physical:
//         return _col([
//           _select('Body Type', 'bodyType', kBodyType),
//           _select('Skin Type', 'skinType', kSkinType),
//           _select('Blood Group', 'bloodGroup', kBloodGroup),
//           _select('Had Surgery', 'surgery', kYesNo),
//           _select('Have Disability', 'disability', kYesNo),
//           _field('Brief description',
//               _textArea('physicalNote', 'Anything you would like to mention', lines: 3)),
//         ]);

//       case ProfileSection.religion:
//         return _col([
//           _select('Religion', 'religion', kReligion, isRequired: true),
//           _select('Caste', 'caste', kCaste, isRequired: true),
//           _select('Sub Caste', 'subCaste', kSubCaste, isRequired: true),
//           _select('Gotra', 'gotra', kGotra, isRequired: true),
//         ]);

//       case ProfileSection.location:
//         Widget group(String title, String p) => Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _GroupTitle(title),
//                 _select('Country', '${p}Country', kCountry),
//                 _select('State', '${p}State', kState),
//                 _select('City', '${p}City', kDistrict, hint: 'Select district'),
//               ],
//             );
//         return _col([
//           group('Native Residence', 'native'),
//           group('Permanent Residence', 'perm'),
//           group('Current Residence', 'cur'),
//         ]);

//       case ProfileSection.career:
//         return _col([
//           _select('Qualification', 'qualification', kQualification),
//           _field('Education description',
//               _textArea('educationNote', 'College, specialisation, year', lines: 3)),
//           _select('Employment type', 'employment', kEmployment),
//           _select('Occupation', 'occupation', kOccupation),
//           _select('Working Country', 'workCountry', kCountry),
//           _select('Working State', 'workState', kState),
//           _select('Working City', 'workCity', kDistrict),
//           _select('Residential Status', 'residential', kResidential),
//           _select('Annual Income', 'income', kIncome),
//           _field(
//             'Languages Known',
//             MultiSelectField(
//               hint: 'Select languages',
//               title: 'Languages Known',
//               options: kLanguages,
//               values: _v<Set<String>>('languages') ?? {},
//               onChanged: (v) => _set('languages', v),
//             ),
//           ),
//         ]);

//       case ProfileSection.family:
//         int n(String k) => _v<int>(k) ?? 0;
//         return _col([
//           _select('Family Status', 'familyStatus', kFamilyStatus),
//           _select('Family Type', 'familyType', kFamilyType),
//           _select('Family Values', 'familyValues', kFamilyValues),
//           _select('Family Property', 'familyProperty', kFamilyProperty),
//           _select('Total Members', 'totalMembers', kTotalMembers,
//               hint: 'Total family members'),
//           _select("Father's Occupation", 'fatherJob', kParentOccupation),
//           _select("Mother's Occupation", 'motherJob', kParentOccupation),
//           const _GroupTitle('Siblings'),
//           _Counter(
//             label: 'Brothers',
//             value: n('brothers'),
//             onChanged: (v) => setState(() {
//               _draft['brothers'] = v;
//               if (n('brothersMarried') > v) _draft['brothersMarried'] = v;
//             }),
//           ),
//           _Counter(
//             label: 'Brothers married',
//             value: n('brothersMarried'),
//             max: n('brothers'),
//             onChanged: (v) => _set('brothersMarried', v),
//           ),
//           _Counter(
//             label: 'Sisters',
//             value: n('sisters'),
//             onChanged: (v) => setState(() {
//               _draft['sisters'] = v;
//               if (n('sistersMarried') > v) _draft['sistersMarried'] = v;
//             }),
//           ),
//           _Counter(
//             label: 'Sisters married',
//             value: n('sistersMarried'),
//             max: n('sisters'),
//             onChanged: (v) => _set('sistersMarried', v),
//           ),
//         ]);

//       case ProfileSection.horoscope:
//         return _col([
//           _field(
//             'DOB as per horoscope',
//             _DateField(
//               value: _v<DateTime>('horoDob'),
//               hint: 'DD-MM-YYYY',
//               firstDate: DateTime(1950),
//               lastDate: DateTime.now(),
//               onChanged: (d) => _set('horoDob', d),
//             ),
//           ),
//           _field(
//             'Time of birth',
//             _TimeField(
//               value: _v<TimeOfDay>('birthTime'),
//               onChanged: (t) => _set('birthTime', t),
//             ),
//           ),
//           _field('Location of birth', _textField('birthPlace', 'Enter the location')),
//           _select('Birth Star', 'birthStar', kBirthStars, hint: 'Select birth star'),
//           _field('Profile with sudha jathakam', _choice('sudha', const ['Yes', 'No'])),
//           _field('Profile with dosha jathakam', _choice('dosha', const ['Yes', 'No'])),
//           _field('Looking for star match only',
//               _choice('starMatchOnly', const ['Yes', 'No'])),
//           _field('Horoscope Matches', _choice('horoMatch', kHoroscopeMatch)),
//         ]);
//     }
//   }

//   // ── Field helpers ────────────────────────────────────────────────────────
//   Widget _col(List<Widget> c) => Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: c,
//       );

//   Widget _field(String label, Widget child, {bool isRequired = false}) => Padding(
//         padding: const EdgeInsets.only(bottom: 12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 6),
//               child: Text.rich(
//                 TextSpan(
//                   text: label,
//                   children: [
//                     if (isRequired)
//                       const TextSpan(
//                           text: ' *', style: TextStyle(color: AppColors.coral)),
//                   ],
//                 ),
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.navy,
//                 ),
//               ),
//             ),
//             child,
//           ],
//         ),
//       );

//   Widget _select(String label, String key, List<String> options,
//           {bool isRequired = false, String? hint}) =>
//       _field(
//         label,
//         SelectField(
//           hint: hint ?? 'Select',
//           title: label,
//           options: options,
//           value: _v<String>(key),
//           onChanged: (v) => _set(key, v),
//         ),
//         isRequired: isRequired,
//       );

//   Widget _textField(String key, String hint) => TextField(
//         controller: _ctrl(key),
//         onChanged: (v) => _draft[key] = v,
//         style: const TextStyle(fontSize: 14, color: AppColors.navy),
//         decoration: searchInputDecoration(hint),
//       );

//   Widget _textArea(String key, String hint, {int lines = 4, int? maxLength}) =>
//       TextField(
//         controller: _ctrl(key),
//         onChanged: (v) => _draft[key] = v,
//         minLines: lines,
//         maxLines: lines + 4,
//         maxLength: maxLength,
//         style: const TextStyle(fontSize: 14, height: 1.45, color: AppColors.navy),
//         decoration: searchInputDecoration(hint),
//       );

//   Widget _choice(String key, List<String> options) => _ChoiceGroup(
//         options: options,
//         value: _v<String>(key),
//         onChanged: (v) => _set(key, v),
//       );
// }

// int _age(DateTime dob) {
//   final now = DateTime.now();
//   var a = now.year - dob.year;
//   if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
//     a--;
//   }
//   return a;
// }

// String _ddmmyyyy(DateTime d) =>
//     '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

// // ─────────────────────────────────────────────────────────────────────────────
// //  Header card (also used on the Profile tab)
// // ─────────────────────────────────────────────────────────────────────────────
// class ProfileHeaderCard extends StatelessWidget {
//   const ProfileHeaderCard({
//     super.key,
//     required this.data,
//     required this.buttonLabel,
//     required this.buttonIcon,
//     required this.onButton,
//     this.footer,
//   });

//   final Map<String, Object?> data;
//   final String buttonLabel;
//   final IconData buttonIcon;
//   final VoidCallback onButton;

//   /// Extra content under the phone row (e.g. profile completion).
//   final Widget? footer;

//   @override
//   Widget build(BuildContext context) {
//     final dob = data['dob'] as DateTime?;
//     final age = dob == null ? null : _age(dob);
//     final line1 = [if (age != null) '$age Yrs', data['religion']]
//         .whereType<String>()
//         .join(' · ');
//     final city = data['permCity'] as String?;
//     final state = data['permState'] as String?;
//     final place = [city, state].whereType<String>().join(' | ');
//     final gold = AppColors.sparkleGold;

//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [AppColors.tealB, AppColors.tealC],
//         ),
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: 92,
//                 height: 100,
//                 decoration: BoxDecoration(
//                   color: AppColors.blueTint,
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 clipBehavior: Clip.antiAlias,
//                 child: data['photoUrl'] is String
//                     ? Image.network(data['photoUrl'] as String, fit: BoxFit.cover)
//                     : const CustomPaint(painter: AvatarPainter()),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       (data['name'] as String?) ?? '',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'Profile created for ${data['createdFor'] ?? '–'}',
//                       style: TextStyle(
//                           fontSize: 12.5,
//                           color: Colors.white.withValues(alpha: 0.85)),
//                     ),
//                     const SizedBox(height: 8),
//                     for (final l in [line1, data['qualification'], place])
//                       if (l is String && l.isNotEmpty)
//                         Text(
//                           l,
//                           style: TextStyle(
//                             fontSize: 13,
//                             height: 1.4,
//                             fontWeight: FontWeight.w600,
//                             color: gold,
//                           ),
//                         ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           if (data['phone'] is String)
//             Container(
//               height: 44,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               decoration: BoxDecoration(
//                 color: Colors.white.withValues(alpha: 0.1),
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
//               ),
//               child: Row(
//                 children: [
//                   matchIcon(Icons.call_outlined, 'call',
//                       size: 17, color: Colors.white),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       data['phone'] as String,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   if (data['phoneVerified'] == true)
//                     Semantics(
//                       label: 'Verified number',
//                       child: matchIcon(Icons.check_circle_rounded, 'verified',
//                           size: 18, color: AppColors.online),
//                     ),
//                 ],
//               ),
//             ),
//           if (footer != null) ...[
//             const SizedBox(height: 12),
//             footer!,
//           ],
//           const SizedBox(height: 12),
//           PillButton(
//             label: buttonLabel,
//             icon: matchIcon(buttonIcon, 'button',
//                 size: 17, color: AppColors.goldDark),
//             foreground: AppColors.goldDark,
//             gradient: const LinearGradient(
//                 colors: [AppColors.loginA, AppColors.loginB]),
//             borderColor: AppColors.goldBorder,
//             onTap: onButton,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// //  Pieces
// // ─────────────────────────────────────────────────────────────────────────────
// class _Accordion extends StatelessWidget {
//   const _Accordion({
//     required this.title,
//     required this.icon,
//     required this.iconName,
//     required this.accent,
//     required this.open,
//     required this.onToggle,
//     required this.onCancel,
//     required this.onSave,
//     required this.child,
//   });

//   final String title;
//   final IconData icon;
//   final String iconName;
//   final Color accent;
//   final bool open;
//   final VoidCallback onToggle;
//   final VoidCallback onCancel;
//   final VoidCallback onSave;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       decoration: BoxDecoration(
//         gradient: open
//             ? const LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.white, AppColors.cream],
//               )
//             : null,
//         color: open ? null : Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: open ? AppColors.goldBorder : AppColors.blueTintBorder,
//           width: open ? 1.4 : 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.tealDark.withValues(alpha: 0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Semantics(
//             button: true,
//             expanded: open,
//             child: InkWell(
//               borderRadius: BorderRadius.circular(18),
//               onTap: onToggle,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 36,
//                       height: 36,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: accent.withValues(alpha: 0.12),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: matchIcon(icon, iconName, size: 19, color: accent),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.navy,
//                         ),
//                       ),
//                     ),
//                     AnimatedRotation(
//                       turns: open ? 0.5 : 0,
//                       duration: const Duration(milliseconds: 200),
//                       child: matchIcon(Icons.keyboard_arrow_down_rounded,
//                           'arrow_down',
//                           size: 24, color: AppColors.textMuted),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           AnimatedSize(
//             duration: const Duration(milliseconds: 220),
//             curve: Curves.easeOut,
//             alignment: Alignment.topCenter,
//             child: open
//                 ? Padding(
//                     padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         child,
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: PillButton(
//                                 label: 'Cancel',
//                                 icon: const SizedBox.shrink(),
//                                 foreground: AppColors.navy,
//                                 background: Colors.white,
//                                 borderColor: AppColors.fieldBorder,
//                                 onTap: onCancel,
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                             Expanded(
//                               child: PillButton(
//                                 label: 'Save changes',
//                                 icon: const SizedBox.shrink(),
//                                 foreground: Colors.white,
//                                 gradient: kTealGradient,
//                                 onTap: onSave,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                 : const SizedBox(width: double.infinity),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _GroupTitle extends StatelessWidget {
//   const _GroupTitle(this.text);
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 4, bottom: 10),
//       child: Row(
//         children: [
//           Text(
//             text,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w700,
//               color: AppColors.tealMid,
//             ),
//           ),
//           const SizedBox(width: 10),
//           const Expanded(child: Divider(color: AppColors.fieldBorder)),
//         ],
//       ),
//     );
//   }
// }

// /// Field that opens a date picker.
// class _DateField extends StatelessWidget {
//   const _DateField({
//     required this.value,
//     required this.hint,
//     required this.firstDate,
//     required this.lastDate,
//     required this.onChanged,
//   });

//   final DateTime? value;
//   final String hint;
//   final DateTime firstDate;
//   final DateTime lastDate;
//   final ValueChanged<DateTime> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return _TapField(
//       text: value == null ? null : _ddmmyyyy(value!),
//       hint: hint,
//       icon: Icons.calendar_today_outlined,
//       onTap: () async {
//         final d = await showDatePicker(
//           context: context,
//           initialDate: value ?? lastDate,
//           firstDate: firstDate,
//           lastDate: lastDate,
//           builder: _pickerTheme,
//         );
//         if (d != null) onChanged(d);
//       },
//     );
//   }
// }

// /// Field that opens a time picker (gives hour, minute and AM/PM).
// class _TimeField extends StatelessWidget {
//   const _TimeField({required this.value, required this.onChanged});

//   final TimeOfDay? value;
//   final ValueChanged<TimeOfDay> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return _TapField(
//       text: value?.format(context),
//       hint: 'HH : MM  AM/PM',
//       icon: Icons.schedule_rounded,
//       onTap: () async {
//         final t = await showTimePicker(
//           context: context,
//           initialTime: value ?? const TimeOfDay(hour: 6, minute: 0),
//           builder: _pickerTheme,
//         );
//         if (t != null) onChanged(t);
//       },
//     );
//   }
// }

// Widget _pickerTheme(BuildContext context, Widget? child) => Theme(
//       data: Theme.of(context).copyWith(
//         colorScheme: Theme.of(context).colorScheme.copyWith(
//               primary: AppColors.tealMid,
//               onPrimary: Colors.white,
//               surface: Colors.white,
//               onSurface: AppColors.navy,
//             ),
//       ),
//       child: child!,
//     );

// class _TapField extends StatelessWidget {
//   const _TapField({
//     required this.text,
//     required this.hint,
//     required this.icon,
//     required this.onTap,
//   });

//   final String? text;
//   final String hint;
//   final IconData icon;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final has = text != null;
//     return Material(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(14),
//         side: BorderSide(color: has ? AppColors.tealMid : AppColors.fieldBorder),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: onTap,
//         child: SizedBox(
//           height: 48,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 14),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     text ?? hint,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: has ? FontWeight.w600 : FontWeight.w400,
//                       color: has ? AppColors.navy : AppColors.hint,
//                     ),
//                   ),
//                 ),
//                 matchIcon(icon, 'calendar', size: 18, color: AppColors.textMuted),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Multi-select dropdown (hobbies, languages).
// class MultiSelectField extends StatelessWidget {
//   const MultiSelectField({
//     super.key,
//     required this.hint,
//     required this.title,
//     required this.options,
//     required this.values,
//     required this.onChanged,
//   });

//   final String hint;
//   final String title;
//   final List<String> options;
//   final Set<String> values;
//   final ValueChanged<Set<String>> onChanged;

//   Future<void> _pick(BuildContext context) async {
//     final picked = await showModalBottomSheet<Set<String>>(
//       context: context,
//       backgroundColor: Colors.white,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (ctx) {
//         final sel = {...values};
//         return StatefulBuilder(
//           builder: (ctx, setSheet) => ConstrainedBox(
//             constraints: BoxConstraints(
//                 maxHeight: MediaQuery.of(ctx).size.height * 0.75),
//             child: SafeArea(
//               top: false,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: AppColors.fieldBorder,
//                           borderRadius: BorderRadius.circular(999),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             title,
//                             style: const TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.navy,
//                             ),
//                           ),
//                         ),
//                         Text('${sel.length} selected',
//                             style: const TextStyle(
//                                 fontSize: 12, color: AppColors.textMuted)),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Flexible(
//                       child: SingleChildScrollView(
//                         child: Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: [
//                             for (final o in options)
//                               FilterPill(
//                                 label: o,
//                                 selected: sel.contains(o),
//                                 onTap: () => setSheet(() =>
//                                     sel.contains(o) ? sel.remove(o) : sel.add(o)),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     PillButton(
//                       label: 'Done',
//                       icon: matchIcon(Icons.check_rounded, 'check',
//                           size: 18, color: Colors.white),
//                       foreground: Colors.white,
//                       gradient: kTealGradient,
//                       onTap: () => Navigator.pop(ctx, sel),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//     if (picked != null) onChanged(picked);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final has = values.isNotEmpty;
//     return Material(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(14),
//         side: BorderSide(color: has ? AppColors.tealMid : AppColors.fieldBorder),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: () => _pick(context),
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(minHeight: 48),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: has
//                       ? Wrap(
//                           spacing: 6,
//                           runSpacing: 6,
//                           children: [
//                             for (final v in values)
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.tealMid.withValues(alpha: 0.1),
//                                   borderRadius: BorderRadius.circular(999),
//                                 ),
//                                 child: Text(
//                                   v,
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w600,
//                                     color: AppColors.tealMid,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         )
//                       : Text(hint,
//                           style: const TextStyle(
//                               fontSize: 14, color: AppColors.hint)),
//                 ),
//                 matchIcon(Icons.keyboard_arrow_down_rounded, 'arrow_down',
//                     size: 20, color: AppColors.textMuted),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Single-choice options shown as radio pills.
// class _ChoiceGroup extends StatelessWidget {
//   const _ChoiceGroup({
//     required this.options,
//     required this.value,
//     required this.onChanged,
//   });

//   final List<String> options;
//   final String? value;
//   final ValueChanged<String> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children: [
//         for (final o in options)
//           Semantics(
//             inMutuallyExclusiveGroup: true,
//             checked: o == value,
//             child: Material(
//               color: o == value
//                   ? AppColors.tealMid.withValues(alpha: 0.08)
//                   : Colors.white,
//               shape: StadiumBorder(
//                 side: BorderSide(
//                     color: o == value ? AppColors.tealMid : AppColors.fieldBorder),
//               ),
//               child: InkWell(
//                 customBorder: const StadiumBorder(),
//                 onTap: () => onChanged(o),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       matchIcon(
//                         o == value
//                             ? Icons.radio_button_checked_rounded
//                             : Icons.radio_button_unchecked_rounded,
//                         'radio',
//                         size: 18,
//                         color: o == value ? AppColors.tealMid : AppColors.hint,
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         o,
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight:
//                               o == value ? FontWeight.w700 : FontWeight.w500,
//                           color: AppColors.navy,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// /// − n + stepper used for siblings.
// class _Counter extends StatelessWidget {
//   const _Counter({
//     required this.label,
//     required this.value,
//     required this.onChanged,
//     this.max = 10,
//   });

//   final String label;
//   final int value;
//   final int max;
//   final ValueChanged<int> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     Widget btn(IconData i, String tip, VoidCallback? onTap) => IconButton(
//           tooltip: tip,
//           onPressed: onTap,
//           style: IconButton.styleFrom(
//             backgroundColor: onTap == null ? AppColors.bgBottom : AppColors.toggleBg,
//             fixedSize: const Size(40, 40),
//           ),
//           icon: matchIcon(i, 'counter',
//               size: 18,
//               color: onTap == null ? AppColors.hint : AppColors.goldDark),
//         );

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.navy,
//               ),
//             ),
//           ),
//           btn(Icons.remove_rounded, 'Fewer $label',
//               value > 0 ? () => onChanged(value - 1) : null),
//           SizedBox(
//             width: 36,
//             child: Text(
//               '$value',
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.navy,
//               ),
//             ),
//           ),
//           btn(Icons.add_rounded, 'More $label',
//               value < max ? () => onChanged(value + 1) : null),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:vivahbharath_app/services/search_options.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/drawer/manage_photo_screen.dart';
import 'search_screen.dart'; // SearchTopBar, SelectField, MultiSelectField, searchInputDecoration, kHeightOptions, kWeightOptions

// ─────────────────────────────────────────────────────────────────────────────
//  Fixed option lists (no API for these). Every other dropdown on this screen
//  gets its options from the API — see _EditProfileScreenState._sources.
// ─────────────────────────────────────────────────────────────────────────────
const kChildren = ['0', '1', '2', '3', '4', '5'];
const kYesNo = ['No', 'Yes'];
final kTotalMembers = [for (var i = 1; i <= 15; i++) '$i'];
const kParentOccupation = ['Employed', 'Business', 'Retired', 'Homemaker', 'Not employed', 'Passed away'];
const kHoroscopeMatch = ['Important', 'Preferable', 'Not Necessary', "Don't Want"];

/// Sample profile — replace with the logged-in member's data.
Map<String, Object?> sampleProfile() => {
      'name': 'Ahana S Nair',
      'createdFor': 'Myself',
      'phone': '+91 [Mobile number]',
      'phoneVerified': true,
      'about':
          'I am a simple and family-oriented individual with a positive outlook on life. '
              'Enjoy music, travel, and spending time with close ones. '
              'Looking for a genuine and understanding life partner.',
      'dob': DateTime(2002, 5, 8),
      'children': '0',
      'pet': 'No',
      'hobbies': <String>{},
      'surgery': 'No',
      'disability': 'No',
      'religion': 'Hindu',
      'caste': 'Nair',
      'subCaste': 'Nambiar',
      'nativeCountry': 'India',
      'nativeState': 'Kerala',
      'permCountry': 'India',
      'permState': 'Kerala',
      'permCity': 'Kozhikode',
      'curCountry': 'India',
      'curState': 'Kerala',
      'qualification': 'Bachelors Degree',
      'occupation': 'Software Developer',
      'languages': <String>{},
      'brothers': 0,
      'brothersMarried': 0,
      'sisters': 0,
      'sistersMarried': 0,
      'horoDob': DateTime(2002, 5, 8),
    };

// ─────────────────────────────────────────────────────────────────────────────
//  Sections
// ─────────────────────────────────────────────────────────────────────────────
enum ProfileSection {
  about('A few words about you', Icons.edit_outlined, 'about', ['about'], []),
  basic('Basic details', Icons.person_outline_rounded, 'basic', [
    'name', 'dob', 'height', 'weight', 'marital', 'children', 'diet',
    'smoking', 'drinking', 'pet', 'hobbies',
  ], ['dob', 'height', 'weight', 'marital']),
  physical('Physical details', Icons.accessibility_new_rounded, 'physical', [
    'bodyType', 'skinType', 'bloodGroup', 'surgery', 'disability',
    'physicalNote',
  ], []),
  religion('Religion details', Icons.temple_hindu_outlined, 'religion',
      ['religion', 'caste', 'subCaste', 'gotra'],
      ['religion', 'caste', 'subCaste', 'gotra']),
  location('Community & Location', Icons.location_on_outlined, 'location', [
    'nativeCountry', 'nativeState', 'nativeCity',
    'permCountry', 'permState', 'permCity',
    'curCountry', 'curState', 'curCity',
  ], []),
  career('Education and career details', Icons.school_outlined, 'education', [
    'qualification', 'educationNote', 'employment', 'occupation',
    'workCountry', 'workState', 'workCity', 'residential', 'income',
    'languages',
  ], []),
  family('Family details', Icons.home_outlined, 'family', [
    'familyStatus', 'familyType', 'familyValues', 'familyProperty',
    'totalMembers', 'fatherJob', 'motherJob',
    'brothers', 'brothersMarried', 'sisters', 'sistersMarried',
  ], []),
  horoscope('Horoscope details', Icons.auto_awesome_outlined, 'horoscope', [
    'horoDob', 'birthTime', 'birthPlace', 'birthStar', 'sudha', 'dosha',
    'starMatchOnly', 'horoMatch',
  ], []);

  const ProfileSection(
      this.title, this.icon, this.iconName, this.keys, this.requiredKeys);
  final String title;
  final IconData icon;
  final String iconName;
  final List<String> keys;
  final List<String> requiredKeys;
}

const _sectionTint = <ProfileSection, Color>{
  ProfileSection.about: AppColors.link,
  ProfileSection.basic: AppColors.brown,
  ProfileSection.physical: AppColors.purple,
  ProfileSection.religion: AppColors.coral,
  ProfileSection.location: AppColors.link,
  ProfileSection.career: AppColors.brown,
  ProfileSection.family: AppColors.purple,
  ProfileSection.horoscope: AppColors.coral,
};

// ─────────────────────────────────────────────────────────────────────────────
//  Edit Profile screen
// ─────────────────────────────────────────────────────────────────────────────
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.initial,
    this.onManagePhotos,
    this.showBottomNav = true,
  });

  final Map<String, Object?>? initial;
  final VoidCallback? onManagePhotos;
  final bool showBottomNav;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with ApiOptionsState {
  late final Map<String, Object?> _saved = _clone(widget.initial ?? sampleProfile());
  late final Map<String, Object?> _draft = _clone(_saved);
  ProfileSection? _open = ProfileSection.about;
  final Map<String, TextEditingController> _text = {};

  /// Location groups: each has its own country → state → city chain.
  static const _places = ['native', 'perm', 'cur', 'work'];

  /// Form key → API list (see SearchOptions). Dependent lists get a
  /// `profile.` key so they don't clash with other screens.
  static final _sources = <String, String>{
    'marital': 'marital',
    'diet': 'foodType',
    'smoking': 'smoking',
    'drinking': 'drinking',
    'hobbies': 'hobbies',
    'bodyType': 'bodyType',
    'skinType': 'skinTone',
    'bloodGroup': 'bloodGroup',
    'religion': 'religion',
    'caste': 'profile.caste',
    'subCaste': 'profile.subCaste',
    'gotra': 'gotra',
    'qualification': 'education',
    'employment': 'employment',
    'occupation': 'occupation',
    'residential': 'residential',
    'income': 'income',
    'languages': 'languages',
    'familyStatus': 'familyStatus',
    'familyType': 'familyType',
    'familyValues': 'familyValues',
    'familyProperty': 'familyProperty',
    'birthStar': 'birthStar',
    for (final p in _places) ...{
      '${p}Country': 'country',
      '${p}State': 'profile.${p}State',
      '${p}City': 'profile.${p}City',
    },
  };

  static final _deps = <String, (String, String)>{
    'caste': ('caste', 'religion'),
    'subCaste': ('subCaste', 'caste'),
    for (final p in _places) ...{
      '${p}State': ('state', '${p}Country'),
      '${p}City': ('city', '${p}State'),
    },
  };

  static String _parentLabel(String key) => switch (key) {
        'caste' => 'Religion',
        'subCaste' => 'Caste',
        _ when key.endsWith('State') => 'Country',
        _ when key.endsWith('City') => 'State',
        _ => 'the field above',
      };

  @override
  Map<String, String> get optionSources => _sources;

  @override
  Map<String, (String, String)> get optionDeps => _deps;

  @override
  Object? optionValue(String key) => _draft[key];

  @override
  void setOptionValue(String key, Object? value) => _draft[key] = value;

  static Map<String, Object?> _clone(Map<String, Object?> m) => {
        for (final e in m.entries)
          e.key: e.value is Set<String> ? {...(e.value as Set<String>)} : e.value,
      };

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  T? _v<T>(String k) => _draft[k] as T?;
  void _set(String k, Object? v) {
    setState(() => _draft[k] = v);
    optionPicked(k);
  }

  TextEditingController _ctrl(String k) => _text.putIfAbsent(
      k, () => TextEditingController(text: (_draft[k] as String?) ?? ''));

  void _cancel(ProfileSection s) {
    setState(() {
      for (final k in s.keys) {
        final v = _saved[k];
        _draft[k] = v is Set<String> ? {...v} : v;
        _text[k]?.text = (v is String) ? v : '';
      }
      _open = null;
    });
    syncOptionValues();
  }

  void _save(ProfileSection s) {
    final missing = [
      for (final k in s.requiredKeys)
        if (_draft[k] == null || _draft[k] == '') k,
    ];
    if (missing.isNotEmpty) {
      _snack('Please fill the fields marked *');
      return;
    }
    setState(() {
      for (final k in s.keys) {
        final v = _draft[k];
        _saved[k] = v is Set<String> ? {...v} : v;
      }
      _open = null;
    });
    // TODO: send the section's keys to your API.
    _snack('${s.title} saved');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(msg, style: const TextStyle(fontSize: 13)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom],
            stops: [0, 0.4],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SearchTopBar(title: 'Edit Profile'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    ProfileHeaderCard(
                      data: _saved,
                      buttonLabel: 'Add / Edit Photos',
                      buttonIcon: Icons.photo_camera_outlined,
                      onButton: widget.onManagePhotos ??
                          () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ManagePhotosScreen(
                                  name: (_saved['name'] as String?) ?? ''))),
                    ),
                    const SizedBox(height: 14),
                    for (final s in ProfileSection.values) ...[
                      _Accordion(
                        title: s.title,
                        icon: s.icon,
                        iconName: s.iconName,
                        accent: _sectionTint[s]!,
                        open: _open == s,
                        onToggle: () =>
                            setState(() => _open = _open == s ? null : s),
                        onCancel: () => _cancel(s),
                        onSave: () => _save(s),
                        child: _sectionBody(s),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Section bodies ───────────────────────────────────────────────────────
  Widget _sectionBody(ProfileSection s) {
    switch (s) {
      case ProfileSection.about:
        return _textArea('about', 'Tell matches about yourself, your family and what you are looking for',
            maxLength: 1000, lines: 6);

      case ProfileSection.basic:
        final dob = _v<DateTime>('dob');
        return _col([
          _field('Name', _textField('name', 'Your name')),
          _field(
            'Age / Date of birth',
            Row(
              children: [
                Container(
                  width: 76,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.bgBottom,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.fieldBorder),
                  ),
                  child: Text(
                    dob == null ? '–' : '${_age(dob)} yrs',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DateField(
                    value: dob,
                    hint: 'DD-MM-YYYY',
                    firstDate: DateTime(1950),
                    lastDate: DateTime(DateTime.now().year - 18,
                        DateTime.now().month, DateTime.now().day),
                    onChanged: (d) => _set('dob', d),
                  ),
                ),
              ],
            ),
            isRequired: true,
          ),
          _select('Height', 'height', options: kHeightOptions, isRequired: true),
          _select('Weight', 'weight', options: kWeightOptions, isRequired: true),
          _select('Marital Status', 'marital', isRequired: true),
          _select('Number of Children', 'children', options: kChildren),
          _select('Diet', 'diet'),
          _select('Smoking', 'smoking'),
          _select('Drinking', 'drinking'),
          _select('Have Pet', 'pet', options: kYesNo),
          _multiSelect('Hobbies & Interests', 'hobbies', 'Select hobbies'),
        ]);

      case ProfileSection.physical:
        return _col([
          _select('Body Type', 'bodyType'),
          _select('Skin Type', 'skinType'),
          _select('Blood Group', 'bloodGroup'),
          _select('Had Surgery', 'surgery', options: kYesNo),
          _select('Have Disability', 'disability', options: kYesNo),
          _field('Brief description',
              _textArea('physicalNote', 'Anything you would like to mention', lines: 3)),
        ]);

      case ProfileSection.religion:
        return _col([
          _select('Religion', 'religion', isRequired: true),
          _select('Caste', 'caste', isRequired: true),
          _select('Sub Caste', 'subCaste', isRequired: true),
          _select('Gotra', 'gotra', isRequired: true),
        ]);

      case ProfileSection.location:
        Widget group(String title, String p) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _GroupTitle(title),
                _select('Country', '${p}Country'),
                _select('State', '${p}State'),
                _select('City', '${p}City', hint: 'Select district'),
              ],
            );
        return _col([
          group('Native Residence', 'native'),
          group('Permanent Residence', 'perm'),
          group('Current Residence', 'cur'),
        ]);

      case ProfileSection.career:
        return _col([
          _select('Qualification', 'qualification'),
          _field('Education description',
              _textArea('educationNote', 'College, specialisation, year', lines: 3)),
          _select('Employment type', 'employment'),
          _select('Occupation', 'occupation'),
          _select('Working Country', 'workCountry'),
          _select('Working State', 'workState'),
          _select('Working City', 'workCity'),
          _select('Residential Status', 'residential'),
          _select('Annual Income', 'income'),
          _multiSelect('Languages Known', 'languages', 'Select languages'),
        ]);

      case ProfileSection.family:
        int n(String k) => _v<int>(k) ?? 0;
        return _col([
          _select('Family Status', 'familyStatus'),
          _select('Family Type', 'familyType'),
          _select('Family Values', 'familyValues'),
          _select('Family Property', 'familyProperty'),
          _select('Total Members', 'totalMembers', options: kTotalMembers,
              hint: 'Total family members'),
          _select("Father's Occupation", 'fatherJob', options: kParentOccupation),
          _select("Mother's Occupation", 'motherJob', options: kParentOccupation),
          const _GroupTitle('Siblings'),
          _Counter(
            label: 'Brothers',
            value: n('brothers'),
            onChanged: (v) => setState(() {
              _draft['brothers'] = v;
              if (n('brothersMarried') > v) _draft['brothersMarried'] = v;
            }),
          ),
          _Counter(
            label: 'Brothers married',
            value: n('brothersMarried'),
            max: n('brothers'),
            onChanged: (v) => _set('brothersMarried', v),
          ),
          _Counter(
            label: 'Sisters',
            value: n('sisters'),
            onChanged: (v) => setState(() {
              _draft['sisters'] = v;
              if (n('sistersMarried') > v) _draft['sistersMarried'] = v;
            }),
          ),
          _Counter(
            label: 'Sisters married',
            value: n('sistersMarried'),
            max: n('sisters'),
            onChanged: (v) => _set('sistersMarried', v),
          ),
        ]);

      case ProfileSection.horoscope:
        return _col([
          _field(
            'DOB as per horoscope',
            _DateField(
              value: _v<DateTime>('horoDob'),
              hint: 'DD-MM-YYYY',
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
              onChanged: (d) => _set('horoDob', d),
            ),
          ),
          _field(
            'Time of birth',
            _TimeField(
              value: _v<TimeOfDay>('birthTime'),
              onChanged: (t) => _set('birthTime', t),
            ),
          ),
          _field('Location of birth', _textField('birthPlace', 'Enter the location')),
          _select('Birth Star', 'birthStar', hint: 'Select birth star'),
          _field('Profile with sudha jathakam', _choice('sudha', const ['Yes', 'No'])),
          _field('Profile with dosha jathakam', _choice('dosha', const ['Yes', 'No'])),
          _field('Looking for star match only',
              _choice('starMatchOnly', const ['Yes', 'No'])),
          _field('Horoscope Matches', _choice('horoMatch', kHoroscopeMatch)),
        ]);
    }
  }

  // ── Field helpers ────────────────────────────────────────────────────────
  Widget _col(List<Widget> c) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: c,
      );

  Widget _field(String label, Widget child, {bool isRequired = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text.rich(
                TextSpan(
                  text: label,
                  children: [
                    if (isRequired)
                      const TextSpan(
                          text: ' *', style: TextStyle(color: AppColors.coral)),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
            child,
          ],
        ),
      );

  /// Dropdown for [key]. Uses [options] when given, otherwise the API list
  /// (with a loading / "select … first" placeholder while it is empty).
  Widget _select(String label, String key,
          {List<String>? options, bool isRequired = false, String? hint}) =>
      _field(
        label,
        _apiOr(
          key,
          options,
          (opts) => SelectField(
            hint: hint ?? 'Select',
            title: label,
            options: opts,
            value: _v<String>(key),
            onChanged: (v) => _set(key, v),
          ),
        ),
        isRequired: isRequired,
      );

  Widget _multiSelect(String label, String key, String hint) => _field(
        label,
        _apiOr(
          key,
          null,
          (opts) => MultiSelectField(
            hint: hint,
            title: label,
            options: opts,
            values: _v<Set<String>>(key) ?? {},
            onChanged: (v) => _set(key, v),
          ),
        ),
      );

  Widget _apiOr(String key, List<String>? fixed,
      Widget Function(List<String> options) build) {
    if (fixed != null) return build(fixed);
    final empty = emptyOptionsText(key, parentLabel: _parentLabel(key));
    if (empty == null) return build(optionsFor(key));
    return OptionsPlaceholderField(text: empty, loading: optionsLoading(key));
  }

  Widget _textField(String key, String hint) => TextField(
        controller: _ctrl(key),
        onChanged: (v) => _draft[key] = v,
        style: const TextStyle(fontSize: 14, color: AppColors.navy),
        decoration: searchInputDecoration(hint),
      );

  Widget _textArea(String key, String hint, {int lines = 4, int? maxLength}) =>
      TextField(
        controller: _ctrl(key),
        onChanged: (v) => _draft[key] = v,
        minLines: lines,
        maxLines: lines + 4,
        maxLength: maxLength,
        style: const TextStyle(fontSize: 14, height: 1.45, color: AppColors.navy),
        decoration: searchInputDecoration(hint),
      );

  Widget _choice(String key, List<String> options) => _ChoiceGroup(
        options: options,
        value: _v<String>(key),
        onChanged: (v) => _set(key, v),
      );
}

int _age(DateTime dob) {
  final now = DateTime.now();
  var a = now.year - dob.year;
  if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
    a--;
  }
  return a;
}

String _ddmmyyyy(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}-${d.month.toString().padLeft(2, '0')}-${d.year}';

// ─────────────────────────────────────────────────────────────────────────────
//  Header card (also used on the Profile tab)
// ─────────────────────────────────────────────────────────────────────────────
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.data,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onButton,
    this.footer,
  });

  final Map<String, Object?> data;
  final String buttonLabel;
  final IconData buttonIcon;
  final VoidCallback onButton;

  /// Extra content under the phone row (e.g. profile completion).
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final dob = data['dob'] as DateTime?;
    final age = dob == null ? null : _age(dob);
    final line1 = [if (age != null) '$age Yrs', data['religion']]
        .whereType<String>()
        .join(' · ');
    final city = data['permCity'] as String?;
    final state = data['permState'] as String?;
    final place = [city, state].whereType<String>().join(' | ');
    final gold = AppColors.sparkleGold;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tealB, AppColors.tealC],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 92,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                clipBehavior: Clip.antiAlias,
                child: data['photoUrl'] is String
                    ? Image.network(data['photoUrl'] as String, fit: BoxFit.cover)
                    : const CustomPaint(painter: AvatarPainter()),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (data['name'] as String?) ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Profile created for ${data['createdFor'] ?? '–'}',
                      style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white.withValues(alpha: 0.85)),
                    ),
                    const SizedBox(height: 8),
                    for (final l in [line1, data['qualification'], place])
                      if (l is String && l.isNotEmpty)
                        Text(
                          l,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: gold,
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (data['phone'] is String)
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
              ),
              child: Row(
                children: [
                  matchIcon(Icons.call_outlined, 'call',
                      size: 17, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data['phone'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (data['phoneVerified'] == true)
                    Semantics(
                      label: 'Verified number',
                      child: matchIcon(Icons.check_circle_rounded, 'verified',
                          size: 18, color: AppColors.online),
                    ),
                ],
              ),
            ),
          if (footer != null) ...[
            const SizedBox(height: 12),
            footer!,
          ],
          const SizedBox(height: 12),
          PillButton(
            label: buttonLabel,
            icon: matchIcon(buttonIcon, 'button',
                size: 17, color: AppColors.goldDark),
            foreground: AppColors.goldDark,
            gradient: const LinearGradient(
                colors: [AppColors.loginA, AppColors.loginB]),
            borderColor: AppColors.goldBorder,
            onTap: onButton,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Pieces
// ─────────────────────────────────────────────────────────────────────────────
class _Accordion extends StatelessWidget {
  const _Accordion({
    required this.title,
    required this.icon,
    required this.iconName,
    required this.accent,
    required this.open,
    required this.onToggle,
    required this.onCancel,
    required this.onSave,
    required this.child,
  });

  final String title;
  final IconData icon;
  final String iconName;
  final Color accent;
  final bool open;
  final VoidCallback onToggle;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        gradient: open
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, AppColors.cream],
              )
            : null,
        color: open ? null : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: open ? AppColors.goldBorder : AppColors.blueTintBorder,
          width: open ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealDark.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            expanded: open,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onToggle,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: matchIcon(icon, iconName, size: 19, color: accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: matchIcon(Icons.keyboard_arrow_down_rounded,
                          'arrow_down',
                          size: 24, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: Alignment.topCenter,
            child: open
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        child,
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: PillButton(
                                label: 'Cancel',
                                icon: const SizedBox.shrink(),
                                foreground: AppColors.navy,
                                background: Colors.white,
                                borderColor: AppColors.fieldBorder,
                                onTap: onCancel,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: PillButton(
                                label: 'Save changes',
                                icon: const SizedBox.shrink(),
                                foreground: Colors.white,
                                gradient: kTealGradient,
                                onTap: onSave,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 10),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.tealMid,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Divider(color: AppColors.fieldBorder)),
        ],
      ),
    );
  }
}

/// Field that opens a date picker.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.value,
    required this.hint,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
  });

  final DateTime? value;
  final String hint;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TapField(
      text: value == null ? null : _ddmmyyyy(value!),
      hint: hint,
      icon: Icons.calendar_today_outlined,
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: value ?? lastDate,
          firstDate: firstDate,
          lastDate: lastDate,
          builder: _pickerTheme,
        );
        if (d != null) onChanged(d);
      },
    );
  }
}

/// Field that opens a time picker (gives hour, minute and AM/PM).
class _TimeField extends StatelessWidget {
  const _TimeField({required this.value, required this.onChanged});

  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    return _TapField(
      text: value?.format(context),
      hint: 'HH : MM  AM/PM',
      icon: Icons.schedule_rounded,
      onTap: () async {
        final t = await showTimePicker(
          context: context,
          initialTime: value ?? const TimeOfDay(hour: 6, minute: 0),
          builder: _pickerTheme,
        );
        if (t != null) onChanged(t);
      },
    );
  }
}

Widget _pickerTheme(BuildContext context, Widget? child) => Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.tealMid,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.navy,
            ),
      ),
      child: child!,
    );

class _TapField extends StatelessWidget {
  const _TapField({
    required this.text,
    required this.hint,
    required this.icon,
    required this.onTap,
  });

  final String? text;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final has = text != null;
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: has ? AppColors.tealMid : AppColors.fieldBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 48,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    text ?? hint,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: has ? FontWeight.w600 : FontWeight.w400,
                      color: has ? AppColors.navy : AppColors.hint,
                    ),
                  ),
                ),
                matchIcon(icon, 'calendar', size: 18, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// MultiSelectField now lives in search_screen.dart (shared with Search).

/// Single-choice options shown as radio pills.
class _ChoiceGroup extends StatelessWidget {
  const _ChoiceGroup({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<String> options;
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          Semantics(
            inMutuallyExclusiveGroup: true,
            checked: o == value,
            child: Material(
              color: o == value
                  ? AppColors.tealMid.withValues(alpha: 0.08)
                  : Colors.white,
              shape: StadiumBorder(
                side: BorderSide(
                    color: o == value ? AppColors.tealMid : AppColors.fieldBorder),
              ),
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: () => onChanged(o),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      matchIcon(
                        o == value
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_unchecked_rounded,
                        'radio',
                        size: 18,
                        color: o == value ? AppColors.tealMid : AppColors.hint,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        o,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              o == value ? FontWeight.w700 : FontWeight.w500,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// − n + stepper used for siblings.
class _Counter extends StatelessWidget {
  const _Counter({
    required this.label,
    required this.value,
    required this.onChanged,
    this.max = 10,
  });

  final String label;
  final int value;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData i, String tip, VoidCallback? onTap) => IconButton(
          tooltip: tip,
          onPressed: onTap,
          style: IconButton.styleFrom(
            backgroundColor: onTap == null ? AppColors.bgBottom : AppColors.toggleBg,
            fixedSize: const Size(40, 40),
          ),
          icon: matchIcon(i, 'counter',
              size: 18,
              color: onTap == null ? AppColors.hint : AppColors.goldDark),
        );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
          btn(Icons.remove_rounded, 'Fewer $label',
              value > 0 ? () => onChanged(value - 1) : null),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          btn(Icons.add_rounded, 'More $label',
              value < max ? () => onChanged(value + 1) : null),
        ],
      ),
    );
  }
}
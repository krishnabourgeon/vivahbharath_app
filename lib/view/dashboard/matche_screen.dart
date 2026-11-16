// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/custom/app_colors.dart';
// // ─────────────────────────────────────────────────────────────────────────────
// //  Icons
// //  Every icon on this screen goes through [_icon]. To switch to your PNG set,
// //  replace its body with:  return AppIcon(name, size: size, color: color);
// //  (the `name` argument is already the asset name you'd use).
// // ─────────────────────────────────────────────────────────────────────────────
// Widget _icon(IconData data, String name, {double size = 18, Color? color}) =>
//     Icon(data, size: size, color: color);


// // ─────────────────────────────────────────────────────────────────────────────
// //  Model
// // ─────────────────────────────────────────────────────────────────────────────
// enum InterestStatus { send, awaiting, resend }

// enum MatchTab {
//   all('All Matches'),
//   newlyJoined('Newly Joined'),
//   shortlistedYou('Shortlisted You'),
//   viewedYou('Viewed You'),
//   shortlistedByYou('Shortlisted By You'),
//   viewedByYou('Viewed By You'),
//   online('Online'),
//   professionMatches('Profession Matches'),
//   // Shown under "More"
//   educationMatches('Education Matches', inMore: true),
//   familyMatches('Family Matches', inMore: true),
//   religiousMatches('Religious Matches', inMore: true),
//   dontShow("Marked as Don't Show", inMore: true);

//   const MatchTab(this.label, {this.inMore = false});
//   final String label;
//   final bool inMore;
// }

// class MatchProfile {
//   MatchProfile({
//     required this.id,
//     required this.name,
//     required this.lastSeen,
//     required this.age,
//     required this.height,
//     required this.caste,
//     required this.education,
//     required this.profession,
//     required this.city,
//     this.photoUrl,
//     this.nameHidden = false,
//     this.verified = true,
//     this.featured = false,
//     this.shortlisted = false,
//     this.photoRequested = false,
//     this.status = InterestStatus.send,
//     this.hidden = false,
//   });

//   final String id;
//   final String name;
//   final String lastSeen;
//   final int age;
//   final String height;
//   final String caste;
//   final String education;
//   final String profession;
//   final String city;
//   final String? photoUrl;
//   final bool nameHidden;
//   final bool verified;
//   final bool featured;

//   // Mutable UI state
//   bool shortlisted;
//   bool photoRequested;
//   InterestStatus status;
//   bool hidden;
// }

// List<MatchProfile> sampleMatches() => [
//       MatchProfile(
//         id: 'VM2760',
//         name: 'Raxxxxxxxx',
//         nameHidden: true,
//         lastSeen: 'Last seen 4 hours ago',
//         age: 36,
//         height: '5\'8"',
//         caste: 'Nair',
//         education: 'Bachelors Degree',
//         profession: 'Software Engineer',
//         city: 'Kozhikode',
//         featured: true,
//         shortlisted: true,
//         photoRequested: true,
//         status: InterestStatus.awaiting,
//       ),
//       MatchProfile(
//         id: 'VBM26532747M',
//         name: 'Harikrishna',
//         lastSeen: 'Last seen 2 hours ago',
//         age: 33,
//         height: '5\'7"',
//         caste: 'Nair',
//         education: 'Bachelors Degree',
//         profession: 'Software Engineer',
//         city: 'Kozhikode',
//         featured: true,
//       ),
//       MatchProfile(
//         id: 'VM2382',
//         name: 'Rahul CK',
//         lastSeen: 'Last seen 1 month ago',
//         age: 26,
//         height: '5\'4"',
//         caste: 'Thiyya',
//         education: 'Master Degree',
//         profession: 'Software Developer',
//         city: 'Kozhikode',
//         shortlisted: true,
//         photoRequested: true,
//         status: InterestStatus.resend,
//       ),
//       MatchProfile(
//         id: 'VM4858',
//         name: 'Arun V',
//         lastSeen: 'Recently no activity',
//         age: 23,
//         height: '5\'10"',
//         caste: 'Nair',
//         education: 'Bachelors Degree',
//         profession: 'Software Engineer',
//         city: 'Kozhikode',
//         status: InterestStatus.awaiting,
//       ),
//       MatchProfile(
//         id: 'VBM26339257M',
//         name: 'Anirudh',
//         lastSeen: 'Last seen 1 month ago',
//         age: 26,
//         height: '5\'2"',
//         caste: 'Nair',
//         education: 'Bachelors Degree',
//         profession: 'Software Engineer',
//         city: 'Kozhikode',
//       ),
//       MatchProfile(
//         id: 'VBM26932389M',
//         name: 'Priyesh',
//         lastSeen: 'Last seen 1 month ago',
//         age: 41,
//         height: '5\'9"',
//         caste: 'Nair',
//         education: 'Master Degree',
//         profession: 'Teacher',
//         city: 'Kozhikode',
//         hidden: true,
//       ),
//     ];

// // ─────────────────────────────────────────────────────────────────────────────
// //  Screen
// // ─────────────────────────────────────────────────────────────────────────────
// class MatchesScreen extends StatefulWidget {
//   const MatchesScreen({
//     super.key,
//     this.initialTab = MatchTab.all,
//   });

//   final MatchTab initialTab;

//   @override
//   State<MatchesScreen> createState() => _MatchesScreenState();
// }

// class _MatchesScreenState extends State<MatchesScreen> {
//   late MatchTab _tab = widget.initialTab;
//   final List<MatchProfile> _profiles = sampleMatches();
//   final _searchCtrl = TextEditingController();

//   bool get _isDontShow => _tab == MatchTab.dontShow;
//   int get _hiddenCount => _profiles.where((p) => p.hidden).length;

//   // TODO: replace with your API call per tab. Here every tab except
//   // "Marked as Don't Show" lists the non-hidden profiles.
//   List<MatchProfile> get _visible => _profiles
//       .where((p) => _isDontShow ? p.hidden : !p.hidden)
//       .toList(growable: false);

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   // ── Actions ────────────────────────────────────────────────────────────────
//   void _toast(String msg, {VoidCallback? onUndo}) {
//     final m = ScaffoldMessenger.of(context);
//     m.hideCurrentSnackBar();
//     m.showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: AppColors.navy,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//         duration: const Duration(milliseconds: 3500),
//         content: Text(msg, style: const TextStyle(fontSize: 13)),
//         action: onUndo == null
//             ? null
//             : SnackBarAction(
//                 label: 'Undo',
//                 textColor: AppColors.goldBorder,
//                 onPressed: onUndo,
//               ),
//       ),
//     );
//   }

//   void _toggleShortlist(MatchProfile p) {
//     setState(() => p.shortlisted = !p.shortlisted);
//     _toast(p.shortlisted
//         ? 'Added to your shortlist'
//         : 'Removed from your shortlist');
//   }

//   void _sendInterest(MatchProfile p) {
//     setState(() => p.status = InterestStatus.awaiting);
//     _toast('Interest sent to ${p.name}');
//   }

//   void _hide(MatchProfile p) {
//     setState(() => p.hidden = true);
//     _toast('Hidden from your matches',
//         onUndo: () => setState(() => p.hidden = false));
//   }

//   void _unhide(MatchProfile p) {
//     setState(() => p.hidden = false);
//     _toast('${p.name} is back in your matches');
//   }

//   Future<void> _openMore() async {
//     final picked = await showModalBottomSheet<MatchTab>(
//       context: context,
//       backgroundColor: Colors.white,
//       showDragHandle: false,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (_) => _MoreSheet(current: _tab, hiddenCount: _hiddenCount),
//     );
//     if (picked != null && mounted) setState(() => _tab = picked);
//   }

//   // ── Build ──────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final rows = _visible;

//     return Scaffold(
//       backgroundColor: AppColors.bgBottom,
//       body: DecoratedBox(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [AppColors.bgTop, AppColors.bgBottom],
//             stops: [0, 0.45],
//           ),
//         ),
//         child: SafeArea(
//           bottom: false,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const _Header(),
//               _SearchRow(
//                 controller: _searchCtrl,
//                 onSearch: () {/* TODO: search */},
//                 onSavedSearch: () {/* TODO: new / saved search */},
//               ),
//               const SizedBox(height: 12),
//               _FilterChips(
//                 current: _tab,
//                 onPick: (t) => setState(() => _tab = t),
//                 onMore: _openMore,
//               ),
//               const SizedBox(height: 6),
//               Expanded(
//                 child: ListView(
//                   padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.baseline,
//                       textBaseline: TextBaseline.alphabetic,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             _tab.label,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.navy,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           '${rows.length} ${rows.length == 1 ? 'profile' : 'profiles'}',
//                           style: const TextStyle(
//                               fontSize: 13, color: AppColors.textMuted),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 14),
//                     if (_isDontShow) ...[
//                       const _DontShowInfo(),
//                       const SizedBox(height: 14),
//                     ],
//                     if (rows.isEmpty)
//                       const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 48),
//                         child: Text(
//                           'No profiles here right now.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               fontSize: 14, color: AppColors.textMuted),
//                         ),
//                       ),
//                     for (final p in rows) ...[
//                       MatchCard(
//                         profile: p,
//                         dontShowMode: _isDontShow,
//                         onShortlist: () => _toggleShortlist(p),
//                         onHide: () => _hide(p),
//                         onUnhide: () => _unhide(p),
//                         onInterest: () => _sendInterest(p),
//                         onShare: () {/* TODO */},
//                         onCall: () {/* TODO */},
//                         onWhatsApp: () {/* TODO */},
//                         onTap: () {/* TODO: open profile */},
//                       ),
//                       const SizedBox(height: 18),
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
// }

// // ─────────────────────────────────────────────────────────────────────────────
// //  Header + search
// // ─────────────────────────────────────────────────────────────────────────────
// class _Header extends StatelessWidget {
//   const _Header();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
//       child: Row(
//         children: [
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Matches',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.w700,
//                     letterSpacing: -0.3,
//                     color: AppColors.navy,
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'Based on your partner preferences',
//                   style: TextStyle(fontSize: 13, color: AppColors.textMuted),
//                 ),
//               ],
//             ),
//           ),
//           _CircleIconButton(
//             tooltip: 'Chats',
//             icon: _icon(Icons.chat_bubble_outline_rounded, 'chat',
//                 size: 20, color: AppColors.goldDark),
//             onTap: () {},
//           ),
//           const SizedBox(width: 8),
//           _CircleIconButton(
//             tooltip: 'Notifications',
//             badge: '2',
//             icon: _icon(Icons.notifications_none_rounded, 'notification',
//                 size: 21, color: AppColors.goldDark),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _SearchRow extends StatelessWidget {
//   const _SearchRow({
//     required this.controller,
//     required this.onSearch,
//     required this.onSavedSearch,
//   });

//   final TextEditingController controller;
//   final VoidCallback onSearch;
//   final VoidCallback onSavedSearch;

//   @override
//   Widget build(BuildContext context) {
//     final border = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(999),
//       borderSide: const BorderSide(color: AppColors.fieldBorder),
//     );
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Row(
//         children: [
//           Expanded(
//             child: SizedBox(
//               height: 46,
//               child: TextField(
//                 controller: controller,
//                 textInputAction: TextInputAction.search,
//                 onSubmitted: (_) => onSearch(),
//                 style: const TextStyle(fontSize: 14, color: AppColors.navy),
//                 decoration: InputDecoration(
//                   hintText: 'Search profiles or ID…',
//                   hintStyle:
//                       const TextStyle(fontSize: 14, color: AppColors.hint),
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsets.only(left: 18),
//                   border: border,
//                   enabledBorder: border,
//                   focusedBorder: border.copyWith(
//                     borderSide: const BorderSide(
//                         color: AppColors.tealMid, width: 1.4),
//                   ),
//                   suffixIcon: Padding(
//                     padding: const EdgeInsets.all(6),
//                     child: Material(
//                       color: AppColors.tealMid,
//                       shape: const CircleBorder(),
//                       child: InkWell(
//                         customBorder: const CircleBorder(),
//                         onTap: onSearch,
//                         child: SizedBox(
//                           width: 34,
//                           height: 34,
//                           child: Center(
//                             child: _icon(Icons.search_rounded, 'search',
//                                 size: 18, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           _CircleIconButton(
//             tooltip: 'New or saved search',
//             size: 46,
//             background: Colors.white,
//             borderColor: AppColors.fieldBorder,
//             icon: _icon(Icons.tune_rounded, 'filter',
//                 size: 20, color: AppColors.tealMid),
//             onTap: onSavedSearch,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// //  Filter chips
// // ─────────────────────────────────────────────────────────────────────────────
// class _FilterChips extends StatelessWidget {
//   const _FilterChips({
//     required this.current,
//     required this.onPick,
//     required this.onMore,
//   });

//   final MatchTab current;
//   final ValueChanged<MatchTab> onPick;
//   final VoidCallback onMore;

//   @override
//   Widget build(BuildContext context) {
//     final main = MatchTab.values.where((t) => !t.inMore).toList();
//     final moreActive = current.inMore;

//     return SizedBox(
//       height: 38,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         itemCount: main.length + 1,
//         separatorBuilder: (_, _) => const SizedBox(width: 8),
//         itemBuilder: (_, i) {
//           if (i == main.length) {
//             return _Chip(
//               label: moreActive ? current.label : 'More',
//               selected: moreActive,
//               trailing: Icons.keyboard_arrow_down_rounded,
//               onTap: onMore,
//             );
//           }
//           final t = main[i];
//           return _Chip(
//             label: t.label,
//             selected: t == current,
//             onTap: () => onPick(t),
//           );
//         },
//       ),
//     );
//   }
// }

// class _Chip extends StatelessWidget {
//   const _Chip({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//     this.trailing,
//   });

//   final String label;
//   final bool selected;
//   final VoidCallback onTap;
//   final IconData? trailing;

//   @override
//   Widget build(BuildContext context) {
//     final fg = selected ? Colors.white : AppColors.navy;
//     return Material(
//       color: selected ? AppColors.tealMid : Colors.white,
//       shape: StadiumBorder(
//         side: BorderSide(
//           color: selected ? AppColors.tealMid : AppColors.fieldBorder,
//         ),
//       ),
//       child: InkWell(
//         customBorder: const StadiumBorder(),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: fg,
//                 ),
//               ),
//               if (trailing != null) ...[
//                 const SizedBox(width: 2),
//                 _icon(trailing!, 'arrow_down', size: 18, color: fg),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// //  Match card
// // ─────────────────────────────────────────────────────────────────────────────
// class MatchCard extends StatelessWidget {
//   const MatchCard({
//     super.key,
//     required this.profile,
//     required this.onShortlist,
//     required this.onHide,
//     required this.onUnhide,
//     required this.onInterest,
//     required this.onShare,
//     required this.onCall,
//     required this.onWhatsApp,
//     required this.onTap,
//     this.dontShowMode = false,
//   });

//   final MatchProfile profile;
//   final bool dontShowMode;
//   final VoidCallback onShortlist;
//   final VoidCallback onHide;
//   final VoidCallback onUnhide;
//   final VoidCallback onInterest;
//   final VoidCallback onShare;
//   final VoidCallback onCall;
//   final VoidCallback onWhatsApp;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     final p = profile;
//     final featured = p.featured && !dontShowMode;

//     final card = Container(
//       margin: EdgeInsets.only(top: featured ? 10 : 0),
//       decoration: BoxDecoration(
//         color: featured ? null : Colors.white,
//         gradient: featured
//             ? const LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [AppColors.loginA, Colors.white],
//                 stops: [0, 0.45],
//               )
//             : null,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: featured ? AppColors.goldBorder : AppColors.blueTintBorder,
//           width: featured ? 1.4 : 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.tealDark.withValues(alpha: 0.06),
//             blurRadius: 12,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Material(
//         type: MaterialType.transparency,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(20),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 IntrinsicHeight(
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       _Photo(profile: p, onShortlist: onShortlist),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: _Info(
//                           profile: p,
//                           onShare: onShare,
//                           onCall: onCall,
//                           onWhatsApp: onWhatsApp,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 if (dontShowMode)
//                   _PillButton(
//                     label: 'Show in matches',
//                     icon: _icon(Icons.visibility_outlined, 'eye',
//                         size: 17, color: Colors.white),
//                     foreground: Colors.white,
//                     gradient: _tealGradient,
//                     onTap: onUnhide,
//                   )
//                 else
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _PillButton(
//                           label: "Don't show",
//                           icon: _icon(Icons.visibility_off_outlined, 'eye_off',
//                               size: 17, color: AppColors.navy),
//                           foreground: AppColors.navy,
//                           background: Colors.white,
//                           borderColor: AppColors.fieldBorder,
//                           onTap: onHide,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(child: _statusButton(p)),
//                     ],
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     if (!featured) return card;

//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         card,
//         const Positioned(top: 0, left: 14, child: _FeaturedRibbon()),
//       ],
//     );
//   }

//   Widget _statusButton(MatchProfile p) {
//     switch (p.status) {
//       case InterestStatus.send:
//         return _PillButton(
//           label: 'Send interest',
//           icon: _icon(Icons.send_rounded, 'send',
//               size: 16, color: Colors.white),
//           foreground: Colors.white,
//           gradient: _tealGradient,
//           onTap: onInterest,
//         );
//       case InterestStatus.awaiting:
//         return _PillButton(
//           label: 'Awaiting Response',
//           icon: _icon(Icons.schedule_rounded, 'clock',
//               size: 16, color: AppColors.goldDark),
//           foreground: AppColors.goldDark,
//           background: AppColors.toggleBg,
//           onTap: null, // disabled
//         );
//       case InterestStatus.resend:
//         return _PillButton(
//           label: 'Resend interest',
//           icon: _icon(Icons.refresh_rounded, 'refresh',
//               size: 17, color: AppColors.tealMid),
//           foreground: AppColors.tealMid,
//           background: Colors.white,
//           borderColor: AppColors.tealMid,
//           borderWidth: 1.5,
//           onTap: onInterest,
//         );
//     }
//   }
// }

// const _tealGradient = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [AppColors.tealA, AppColors.tealC],
// );

// class _FeaturedRibbon extends StatelessWidget {
//   const _FeaturedRibbon();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(8, 3, 10, 3),
//       decoration: BoxDecoration(
//         color: AppColors.goldSoft,
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(color: AppColors.goldBorder),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _icon(Icons.workspace_premium_rounded, 'crown',
//               size: 13, color: AppColors.goldDark),
//           const SizedBox(width: 4),
//           const Text(
//             'Featured profile',
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: AppColors.goldDark,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Photo extends StatelessWidget {
//   const _Photo({required this.profile, required this.onShortlist});

//   final MatchProfile profile;
//   final VoidCallback onShortlist;

//   @override
//   Widget build(BuildContext context) {
//     final p = profile;
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         width: 112,
//         constraints: const BoxConstraints(minHeight: 150),
//         color: AppColors.blueTint,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             if (p.photoUrl != null)
//               Image.network(
//                 p.photoUrl!,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, _, _) =>
//                     const CustomPaint(painter: _AvatarPainter()),
//               )
//             else
//               const Align(
//                 alignment: Alignment.bottomCenter,
//                 child: SizedBox(
//                   width: 112,
//                   height: 150,
//                   child: CustomPaint(painter: _AvatarPainter()),
//                 ),
//               ),

//             // Shortlist heart
//             Positioned(
//               top: 6,
//               left: 6,
//               child: Semantics(
//                 button: true,
//                 label: p.shortlisted ? 'Remove from shortlist' : 'Shortlist',
//                 child: Material(
//                   color: Colors.white.withValues(alpha: 0.92),
//                   shape: const CircleBorder(),
//                   child: InkWell(
//                     customBorder: const CircleBorder(),
//                     onTap: onShortlist,
//                     child: SizedBox(
//                       width: 32,
//                       height: 32,
//                       child: Center(
//                         child: _icon(
//                           p.shortlisted
//                               ? Icons.favorite_rounded
//                               : Icons.favorite_border_rounded,
//                           p.shortlisted ? 'heart_filled' : 'heart',
//                           size: 18,
//                           color: p.shortlisted
//                               ? AppColors.coral
//                               : AppColors.navy,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             // Photo request pending
//             if (p.photoRequested)
//               Positioned(
//                 left: 6,
//                 right: 6,
//                 bottom: 6,
//                 child: Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: AppColors.navy.withValues(alpha: 0.8),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       _icon(Icons.camera_alt_outlined, 'camera',
//                           size: 12, color: Colors.white),
//                       const SizedBox(width: 4),
//                       const Expanded(
//                         child: Text(
//                           'Awaiting Response',
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             fontSize: 10,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Info extends StatelessWidget {
//   const _Info({
//     required this.profile,
//     required this.onShare,
//     required this.onCall,
//     required this.onWhatsApp,
//   });

//   final MatchProfile profile;
//   final VoidCallback onShare;
//   final VoidCallback onCall;
//   final VoidCallback onWhatsApp;

//   @override
//   Widget build(BuildContext context) {
//     final p = profile;
//     const detail = TextStyle(fontSize: 13, height: 1.45, color: AppColors.navy);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (p.verified) const _VerifiedPill(),
//         const SizedBox(height: 6),
//         Row(
//           children: [
//             Flexible(
//               child: Text(
//                 p.name,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.navy,
//                 ),
//               ),
//             ),
//             if (p.nameHidden) ...[
//               const SizedBox(width: 6),
//               Semantics(
//                 label: 'Name hidden',
//                 child: _icon(Icons.visibility_off_outlined, 'eye_off',
//                     size: 16, color: AppColors.coral),
//               ),
//             ],
//           ],
//         ),
//         const SizedBox(height: 2),
//         Text(
//           '${p.id} · ${p.lastSeen}',
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
//         ),
//         const SizedBox(height: 4),
//         Text('${p.age} yrs · ${p.height} · ${p.caste}', style: detail),
//         Text(p.education, style: detail),
//         Text('${p.profession} · ${p.city}',
//             style: detail, maxLines: 1, overflow: TextOverflow.ellipsis),
//         const Spacer(),
//         const SizedBox(height: 6),
//         Row(
//           children: [
//             _CircleIconButton(
//               tooltip: 'Share profile',
//               size: 36,
//               icon: _icon(Icons.shortcut_rounded, 'share',
//                   size: 17, color: AppColors.goldDark),
//               onTap: onShare,
//             ),
//             const SizedBox(width: 8),
//             _CircleIconButton(
//               tooltip: 'Call',
//               size: 36,
//               icon: _icon(Icons.call_rounded, 'call',
//                   size: 17, color: AppColors.goldDark),
//               onTap: onCall,
//             ),
//             const SizedBox(width: 8),
//             _CircleIconButton(
//               tooltip: 'WhatsApp',
//               size: 36,
//               icon: _icon(Icons.chat_rounded, 'whatsapp',
//                   size: 17, color: AppColors.goldDark),
//               onTap: onWhatsApp,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _VerifiedPill extends StatelessWidget {
//   const _VerifiedPill();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(4, 3, 8, 3),
//       decoration: BoxDecoration(
//         color: AppColors.verified.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _icon(Icons.verified_rounded, 'verified',
//               size: 14, color: AppColors.verified),
//           const SizedBox(width: 4),
//           const Text(
//             'Verified',
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w700,
//               color: AppColors.verified,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DontShowInfo extends StatelessWidget {
//   const _DontShowInfo();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.blueTintBorder),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _icon(Icons.visibility_off_outlined, 'eye_off',
//               size: 20, color: AppColors.tealMid),
//           const SizedBox(width: 10),
//           const Expanded(
//             child: Text.rich(
//               TextSpan(
//                 text: "Profiles you hide won't appear in your matches. Tap ",
//                 children: [
//                   TextSpan(
//                     text: 'Show in matches',
//                     style: TextStyle(fontWeight: FontWeight.w700),
//                   ),
//                   TextSpan(text: ' to bring one back.'),
//                 ],
//               ),
//               style: TextStyle(
//                   fontSize: 13, height: 1.45, color: AppColors.textMuted),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// //  "More" bottom sheet
// // ─────────────────────────────────────────────────────────────────────────────
// class _MoreSheet extends StatelessWidget {
//   const _MoreSheet({required this.current, required this.hiddenCount});

//   final MatchTab current;
//   final int hiddenCount;

//   static const _icons = <MatchTab, (IconData, String)>{
//     MatchTab.educationMatches: (Icons.school_outlined, 'education'),
//     MatchTab.familyMatches: (Icons.family_restroom_rounded, 'family'),
//     MatchTab.religiousMatches: (Icons.temple_hindu_outlined, 'religion'),
//     MatchTab.dontShow: (Icons.visibility_off_outlined, 'eye_off'),
//   };

//   @override
//   Widget build(BuildContext context) {
//     final options = MatchTab.values.where((t) => t.inMore);

//     return SafeArea(
//       top: false,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.fieldBorder,
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 const Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 4),
//                     child: Text(
//                       'More matches',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.navy,
//                       ),
//                     ),
//                   ),
//                 ),
//                 _CircleIconButton(
//                   tooltip: 'Close',
//                   size: 40,
//                   background: AppColors.bgBottom,
//                   icon: _icon(Icons.close_rounded, 'close',
//                       size: 20, color: AppColors.navy),
//                   onTap: () => Navigator.of(context).pop(),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             for (final t in options) ...[
//               _MoreOption(
//                 tab: t,
//                 icon: _icons[t]!,
//                 selected: t == current,
//                 count: t == MatchTab.dontShow ? hiddenCount : null,
//                 onTap: () => Navigator.of(context).pop(t),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _MoreOption extends StatelessWidget {
//   const _MoreOption({
//     required this.tab,
//     required this.icon,
//     required this.selected,
//     required this.onTap,
//     this.count,
//   });

//   final MatchTab tab;
//   final (IconData, String) icon;
//   final bool selected;
//   final int? count;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(14),
//         side: BorderSide(
//           color: selected ? AppColors.tealMid : AppColors.blueTintBorder,
//         ),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(14),
//         onTap: onTap,
//         child: SizedBox(
//           height: 56,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: Row(
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: AppColors.tealMid.withValues(alpha: 0.1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   alignment: Alignment.center,
//                   child: _icon(icon.$1, icon.$2,
//                       size: 19, color: AppColors.tealMid),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Text(
//                     tab.label,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.navy,
//                     ),
//                   ),
//                 ),
//                 if (count != null && count! > 0)
//                   Container(
//                     constraints: const BoxConstraints(minWidth: 24),
//                     height: 24,
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: AppColors.toggleBg,
//                       borderRadius: BorderRadius.circular(999),
//                     ),
//                     child: Text(
//                       '$count',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.goldDark,
//                       ),
//                     ),
//                   ),
//                 if (selected) ...[
//                   const SizedBox(width: 6),
//                   _icon(Icons.check_rounded, 'check',
//                       size: 20, color: AppColors.tealMid),
//                 ],
//                 const SizedBox(width: 4),
//                 _icon(Icons.chevron_right_rounded, 'arrow_right',
//                     size: 20, color: AppColors.hint),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// //  Small reusable widgets
// // ─────────────────────────────────────────────────────────────────────────────
// class _CircleIconButton extends StatelessWidget {
//   const _CircleIconButton({
//     required this.icon,
//     required this.onTap,
//     required this.tooltip,
//     this.size = 44,
//     this.background = AppColors.toggleBg,
//     this.borderColor,
//     this.badge,
//   });

//   final Widget icon;
//   final VoidCallback onTap;
//   final String tooltip;
//   final double size;
//   final Color background;
//   final Color? borderColor;
//   final String? badge;

//   @override
//   Widget build(BuildContext context) {
//     return Tooltip(
//       message: tooltip,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Material(
//             color: background,
//             shape: CircleBorder(
//               side: borderColor == null
//                   ? BorderSide.none
//                   : BorderSide(color: borderColor!),
//             ),
//             child: InkWell(
//               customBorder: const CircleBorder(),
//               onTap: onTap,
//               child: SizedBox(
//                 width: size,
//                 height: size,
//                 child: Center(child: icon),
//               ),
//             ),
//           ),
//           if (badge != null)
//             Positioned(
//               top: 2,
//               right: 2,
//               child: IgnorePointer(
//                 child: Container(
//                   constraints:
//                       const BoxConstraints(minWidth: 16, minHeight: 16),
//                   padding: const EdgeInsets.symmetric(horizontal: 4),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: AppColors.coral,
//                     borderRadius: BorderRadius.circular(999),
//                     border: Border.all(color: Colors.white, width: 1.5),
//                   ),
//                   child: Text(
//                     badge!,
//                     style: const TextStyle(
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _PillButton extends StatelessWidget {
//   const _PillButton({
//     required this.label,
//     required this.icon,
//     required this.foreground,
//     required this.onTap,
//     this.background,
//     this.gradient,
//     this.borderColor,
//     this.borderWidth = 1,
//   });

//   final String label;
//   final Widget icon;
//   final Color foreground;
//   final VoidCallback? onTap;
//   final Color? background;
//   final Gradient? gradient;
//   final Color? borderColor;
//   final double borderWidth;

//   @override
//   Widget build(BuildContext context) {
//     return Semantics(
//       button: true,
//       enabled: onTap != null,
//       child: DecoratedBox(
//         decoration: BoxDecoration(
//           color: gradient == null ? background : null,
//           gradient: gradient,
//           borderRadius: BorderRadius.circular(999),
//           border: borderColor == null
//               ? null
//               : Border.all(color: borderColor!, width: borderWidth),
//         ),
//         child: Material(
//           type: MaterialType.transparency,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(999),
//             onTap: onTap,
//             child: SizedBox(
//               height: 44,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   icon,
//                   const SizedBox(width: 6),
//                   Flexible(
//                     child: Text(
//                       label,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: foreground,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Illustrated placeholder avatar (used when a profile has no photo).
// class _AvatarPainter extends CustomPainter {
//   const _AvatarPainter();

//   @override
//   void paint(Canvas canvas, Size size) {
//     // Drawn on a 112 × 150 grid, scaled to fit.
//     final s = size.width / 112;
//     canvas.save();
//     canvas.translate(0, size.height - 150 * s);
//     canvas.scale(s);

//     final paint = Paint()..isAntiAlias = true;

//     // Shoulders
//     paint.color = AppColors.kShirt;
//     canvas.drawPath(
//       Path()
//         ..moveTo(6, 150)
//         ..cubicTo(8, 120, 28, 108, 56, 108)
//         ..cubicTo(84, 108, 104, 120, 106, 150)
//         ..close(),
//       paint,
//     );

//     // Neck
//     paint.color = AppColors.kNeck;
//     canvas.drawRRect(
//       RRect.fromRectAndRadius(
//           const Rect.fromLTWH(46, 86, 20, 26), const Radius.circular(8)),
//       paint,
//     );

//     // Face
//     paint.color = AppColors.kSkin;
//     canvas.drawOval(
//       Rect.fromCenter(center: const Offset(56, 64), width: 52, height: 60),
//       paint,
//     );

//     // Hair
//     paint.color = AppColors.kHair;
//     canvas.drawPath(
//       Path()
//         ..moveTo(29, 64)
//         ..cubicTo(26, 36, 41, 26, 57, 26)
//         ..cubicTo(75, 26, 88, 36, 84, 64)
//         ..cubicTo(81, 52, 74, 45, 61, 45)
//         ..cubicTo(48, 45, 35, 48, 29, 64)
//         ..close(),
//       paint,
//     );

//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }



import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Icons
//  Every icon on these screens goes through [matchIcon]. To switch to your PNG set,
//  replace its body with:  return AppIcon(name, size: size, color: color);
//  (the `name` argument is already the asset name you'd use).
// ─────────────────────────────────────────────────────────────────────────────
Widget matchIcon(IconData data, String name, {double size = 18, Color? color}) =>
    Icon(data, size: size, color: color);

// Avatar placeholder colours (match the illustrated avatars in the app).
const _kShirt = Color(0xFF2B3A4A);
const _kSkin = Color(0xFFF6C3A0);
const _kNeck = Color(0xFFEAB08A);
const _kHair = Color(0xFF4A2C22);

// ─────────────────────────────────────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────────────────────────────────────
enum InterestStatus { send, awaiting, resend }

enum MatchTab {
  all('All Matches'),
  newlyJoined('Newly Joined'),
  shortlistedYou('Shortlisted You'),
  viewedYou('Viewed You'),
  shortlistedByYou('Shortlisted By You'),
  viewedByYou('Viewed By You'),
  online('Online'),
  professionMatches('Profession Matches'),
  // Shown under "More"
  educationMatches('Education Matches', inMore: true),
  familyMatches('Family Matches', inMore: true),
  religiousMatches('Religious Matches', inMore: true),
  dontShow("Marked as Don't Show", inMore: true);

  const MatchTab(this.label, {this.inMore = false});
  final String label;
  final bool inMore;
}

class MatchProfile {
  MatchProfile({
    required this.id,
    required this.name,
    required this.lastSeen,
    required this.age,
    required this.height,
    required this.caste,
    required this.education,
    required this.profession,
    required this.city,
    this.photoUrl,
    this.nameHidden = false,
    this.verified = true,
    this.featured = false,
    this.shortlisted = false,
    this.photoRequested = false,
    this.status = InterestStatus.send,
    this.hidden = false,
  });

  final String id;
  final String name;
  final String lastSeen;
  final int age;
  final String height;
  final String caste;
  final String education;
  final String profession;
  final String city;
  final String? photoUrl;
  final bool nameHidden;
  final bool verified;
  final bool featured;

  // Mutable UI state
  bool shortlisted;
  bool photoRequested;
  InterestStatus status;
  bool hidden;
}

List<MatchProfile> sampleMatches() => [
      MatchProfile(
        id: 'VM2760',
        name: 'Raxxxxxxxx',
        nameHidden: true,
        lastSeen: 'Last seen 4 hours ago',
        age: 36,
        height: '5\'8"',
        caste: 'Nair',
        education: 'Bachelors Degree',
        profession: 'Software Engineer',
        city: 'Kozhikode',
        featured: true,
        shortlisted: true,
        photoRequested: true,
        status: InterestStatus.awaiting,
      ),
      MatchProfile(
        id: 'VBM26532747M',
        name: 'Harikrishna',
        lastSeen: 'Last seen 2 hours ago',
        age: 33,
        height: '5\'7"',
        caste: 'Nair',
        education: 'Bachelors Degree',
        profession: 'Software Engineer',
        city: 'Kozhikode',
        featured: true,
      ),
      MatchProfile(
        id: 'VM2382',
        name: 'Rahul CK',
        lastSeen: 'Last seen 1 month ago',
        age: 26,
        height: '5\'4"',
        caste: 'Thiyya',
        education: 'Master Degree',
        profession: 'Software Developer',
        city: 'Kozhikode',
        shortlisted: true,
        photoRequested: true,
        status: InterestStatus.resend,
      ),
      MatchProfile(
        id: 'VM4858',
        name: 'Arun V',
        lastSeen: 'Recently no activity',
        age: 23,
        height: '5\'10"',
        caste: 'Nair',
        education: 'Bachelors Degree',
        profession: 'Software Engineer',
        city: 'Kozhikode',
        status: InterestStatus.awaiting,
      ),
      MatchProfile(
        id: 'VBM26339257M',
        name: 'Anirudh',
        lastSeen: 'Last seen 1 month ago',
        age: 26,
        height: '5\'2"',
        caste: 'Nair',
        education: 'Bachelors Degree',
        profession: 'Software Engineer',
        city: 'Kozhikode',
      ),
      MatchProfile(
        id: 'VBM26932389M',
        name: 'Priyesh',
        lastSeen: 'Last seen 1 month ago',
        age: 41,
        height: '5\'9"',
        caste: 'Nair',
        education: 'Master Degree',
        profession: 'Teacher',
        city: 'Kozhikode',
        hidden: true,
      ),
    ];

// ─────────────────────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────────────────────
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({
    super.key,
    this.initialTab = MatchTab.all,
  });

  final MatchTab initialTab;


  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late MatchTab _tab = widget.initialTab;
  final List<MatchProfile> _profiles = sampleMatches();
  final _searchCtrl = TextEditingController();

  bool get _isDontShow => _tab == MatchTab.dontShow;
  int get _hiddenCount => _profiles.where((p) => p.hidden).length;

  // TODO: replace with your API call per tab. Here every tab except
  // "Marked as Don't Show" lists the non-hidden profiles.
  List<MatchProfile> get _visible => _profiles
      .where((p) => _isDontShow ? p.hidden : !p.hidden)
      .toList(growable: false);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  void _toast(String msg, {VoidCallback? onUndo}) {
    final m = ScaffoldMessenger.of(context);
    m.hideCurrentSnackBar();
    m.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(milliseconds: 3500),
        content: Text(msg, style: const TextStyle(fontSize: 13)),
        action: onUndo == null
            ? null
            : SnackBarAction(
                label: 'Undo',
                textColor: AppColors.goldBorder,
                onPressed: onUndo,
              ),
      ),
    );
  }

  void _toggleShortlist(MatchProfile p) {
    setState(() => p.shortlisted = !p.shortlisted);
    _toast(p.shortlisted
        ? 'Added to your shortlist'
        : 'Removed from your shortlist');
  }

  void _sendInterest(MatchProfile p) {
    setState(() => p.status = InterestStatus.awaiting);
    _toast('Interest sent to ${p.name}');
  }

  void _hide(MatchProfile p) {
    setState(() => p.hidden = true);
    _toast('Hidden from your matches',
        onUndo: () => setState(() => p.hidden = false));
  }

  void _unhide(MatchProfile p) {
    setState(() => p.hidden = false);
    _toast('${p.name} is back in your matches');
  }

  Future<void> _openMore() async {
    final picked = await showModalBottomSheet<MatchTab>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _MoreSheet(current: _tab, hiddenCount: _hiddenCount),
    );
    if (picked != null && mounted) setState(() => _tab = picked);
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final rows = _visible;

    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom],
            stops: [0, 0.45],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              _SearchRow(
                controller: _searchCtrl,
                onSearch: () {/* TODO: search */},
                onSavedSearch: () {/* TODO: new / saved search */},
              ),
              const SizedBox(height: 12),
              _FilterChips(
                current: _tab,
                onPick: (t) => setState(() => _tab = t),
                onMore: _openMore,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            _tab.label,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        Text(
                          '${rows.length} ${rows.length == 1 ? 'profile' : 'profiles'}',
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (_isDontShow) ...[
                      const DontShowInfo(),
                      const SizedBox(height: 14),
                    ],
                    if (rows.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          'No profiles here right now.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, color: AppColors.textMuted),
                        ),
                      ),
                    for (final p in rows) ...[
                      MatchCard(
                        profile: p,
                        dontShowMode: _isDontShow,
                        onShortlist: () => _toggleShortlist(p),
                        onHide: () => _hide(p),
                        onUnhide: () => _unhide(p),
                        onInterest: () => _sendInterest(p),
                        onShare: () {/* TODO */},
                        onCall: () {/* TODO */},
                        onWhatsApp: () {/* TODO */},
                        onTap: () {/* TODO: open profile */},
                      ),
                      const SizedBox(height: 18),
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
}

// ─────────────────────────────────────────────────────────────────────────────
//  Header + search
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Matches',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Based on your partner preferences',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          CircleIconButton(
            tooltip: 'Chats',
            icon: matchIcon(Icons.chat_bubble_outline_rounded, 'chat',
                size: 20, color: AppColors.goldDark),
            onTap: () {},
          ),
          const SizedBox(width: 8),
          CircleIconButton(
            tooltip: 'Notifications',
            badge: '2',
            icon: matchIcon(Icons.notifications_none_rounded, 'notification',
                size: 21, color: AppColors.goldDark),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.controller,
    required this.onSearch,
    required this.onSavedSearch,
  });

  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onSavedSearch;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: AppColors.fieldBorder),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 46,
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => onSearch(),
                style: const TextStyle(fontSize: 14, color: AppColors.navy),
                decoration: InputDecoration(
                  hintText: 'Search profiles or ID…',
                  hintStyle:
                      const TextStyle(fontSize: 14, color: AppColors.hint),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.only(left: 18),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: const BorderSide(
                        color: AppColors.tealMid, width: 1.4),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Material(
                      color: AppColors.tealMid,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onSearch,
                        child: SizedBox(
                          width: 34,
                          height: 34,
                          child: Center(
                            child: matchIcon(Icons.search_rounded, 'search',
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleIconButton(
            tooltip: 'New or saved search',
            size: 46,
            background: Colors.white,
            borderColor: AppColors.fieldBorder,
            icon: matchIcon(Icons.tune_rounded, 'filter',
                size: 20, color: AppColors.tealMid),
            onTap: onSavedSearch,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Filter chips
// ─────────────────────────────────────────────────────────────────────────────
class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.current,
    required this.onPick,
    required this.onMore,
  });

  final MatchTab current;
  final ValueChanged<MatchTab> onPick;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final main = MatchTab.values.where((t) => !t.inMore).toList();
    final moreActive = current.inMore;

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: main.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i == main.length) {
            return FilterPill(
              label: moreActive ? current.label : 'More',
              selected: moreActive,
              trailing: Icons.keyboard_arrow_down_rounded,
              onTap: onMore,
            );
          }
          final t = main[i];
          return FilterPill(
            label: t.label,
            selected: t == current,
            onTap: () => onPick(t),
          );
        },
      ),
    );
  }
}

class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.navy;
    return Material(
      color: selected ? AppColors.tealMid : Colors.white,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.tealMid : AppColors.fieldBorder,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: fg,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 2),
                matchIcon(trailing!, 'arrow_down', size: 18, color: fg),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Match card
// ─────────────────────────────────────────────────────────────────────────────
class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.profile,
    required this.onShortlist,
    required this.onHide,
    required this.onUnhide,
    required this.onInterest,
    required this.onShare,
    required this.onCall,
    required this.onWhatsApp,
    required this.onTap,
    this.dontShowMode = false,
  });

  final MatchProfile profile;
  final bool dontShowMode;
  final VoidCallback onShortlist;
  final VoidCallback onHide;
  final VoidCallback onUnhide;
  final VoidCallback onInterest;
  final VoidCallback onShare;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    final featured = p.featured && !dontShowMode;

    final card = Container(
      margin: EdgeInsets.only(top: featured ? 10 : 0),
      decoration: BoxDecoration(
        color: featured ? null : Colors.white,
        gradient: featured
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.loginA, Colors.white],
                stops: [0, 0.45],
              )
            : null,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: featured ? AppColors.goldBorder : AppColors.blueTintBorder,
          width: featured ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.tealDark.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Photo(profile: p, onShortlist: onShortlist),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _Info(
                          profile: p,
                          onShare: onShare,
                          onCall: onCall,
                          onWhatsApp: onWhatsApp,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (dontShowMode)
                  PillButton(
                    label: 'Show in matches',
                    icon: matchIcon(Icons.visibility_outlined, 'eye',
                        size: 17, color: Colors.white),
                    foreground: Colors.white,
                    gradient: kTealGradient,
                    onTap: onUnhide,
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: PillButton(
                          label: "Don't show",
                          icon: matchIcon(Icons.visibility_off_outlined, 'eye_off',
                              size: 17, color: AppColors.navy),
                          foreground: AppColors.navy,
                          background: Colors.white,
                          borderColor: AppColors.fieldBorder,
                          onTap: onHide,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _statusButton(p)),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!featured) return card;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        const Positioned(top: 0, left: 14, child: _FeaturedRibbon()),
      ],
    );
  }

  Widget _statusButton(MatchProfile p) {
    switch (p.status) {
      case InterestStatus.send:
        return PillButton(
          label: 'Send interest',
          icon: matchIcon(Icons.send_rounded, 'send',
              size: 16, color: Colors.white),
          foreground: Colors.white,
          gradient: kTealGradient,
          onTap: onInterest,
        );
      case InterestStatus.awaiting:
        return PillButton(
          label: 'Awaiting Response',
          icon: matchIcon(Icons.schedule_rounded, 'clock',
              size: 16, color: AppColors.goldDark),
          foreground: AppColors.goldDark,
          background: AppColors.toggleBg,
          onTap: null, // disabled
        );
      case InterestStatus.resend:
        return PillButton(
          label: 'Resend interest',
          icon: matchIcon(Icons.refresh_rounded, 'refresh',
              size: 17, color: AppColors.tealMid),
          foreground: AppColors.tealMid,
          background: Colors.white,
          borderColor: AppColors.tealMid,
          borderWidth: 1.5,
          onTap: onInterest,
        );
    }
  }
}

const kTealGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [AppColors.tealA, AppColors.tealC],
);

class _FeaturedRibbon extends StatelessWidget {
  const _FeaturedRibbon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 3, 10, 3),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          matchIcon(Icons.workspace_premium_rounded, 'crown',
              size: 13, color: AppColors.goldDark),
          const SizedBox(width: 4),
          const Text(
            'Featured profile',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.goldDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.profile, required this.onShortlist});

  final MatchProfile profile;
  final VoidCallback onShortlist;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 112,
        constraints: const BoxConstraints(minHeight: 150),
        color: AppColors.blueTint,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (p.photoUrl != null)
              Image.network(
                p.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const CustomPaint(painter: AvatarPainter()),
              )
            else
              const Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 112,
                  height: 150,
                  child: CustomPaint(painter: AvatarPainter()),
                ),
              ),

            // Shortlist heart
            Positioned(
              top: 6,
              left: 6,
              child: Semantics(
                button: true,
                label: p.shortlisted ? 'Remove from shortlist' : 'Shortlist',
                child: Material(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onShortlist,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: matchIcon(
                          p.shortlisted
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          p.shortlisted ? 'heart_filled' : 'heart',
                          size: 18,
                          color: p.shortlisted
                              ? AppColors.coral
                              : AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Photo request pending
            if (p.photoRequested)
              Positioned(
                left: 6,
                right: 6,
                bottom: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      matchIcon(Icons.camera_alt_outlined, 'camera',
                          size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          'Awaiting Response',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.profile,
    required this.onShare,
    required this.onCall,
    required this.onWhatsApp,
  });

  final MatchProfile profile;
  final VoidCallback onShare;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final p = profile;
    const detail = TextStyle(fontSize: 13, height: 1.45, color: AppColors.navy);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (p.verified) const _VerifiedPill(),
        const SizedBox(height: 6),
        Row(
          children: [
            Flexible(
              child: Text(
                p.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
            if (p.nameHidden) ...[
              const SizedBox(width: 6),
              Semantics(
                label: 'Name hidden',
                child: matchIcon(Icons.visibility_off_outlined, 'eye_off',
                    size: 16, color: AppColors.coral),
              ),
            ],
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '${p.id} · ${p.lastSeen}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 4),
        Text('${p.age} yrs · ${p.height} · ${p.caste}', style: detail),
        Text(p.education, style: detail),
        Text('${p.profession} · ${p.city}',
            style: detail, maxLines: 1, overflow: TextOverflow.ellipsis),
        const Spacer(),
        const SizedBox(height: 6),
        Row(
          children: [
            CircleIconButton(
              tooltip: 'Share profile',
              size: 36,
              icon: matchIcon(Icons.shortcut_rounded, 'share',
                  size: 17, color: AppColors.goldDark),
              onTap: onShare,
            ),
            const SizedBox(width: 8),
            CircleIconButton(
              tooltip: 'Call',
              size: 36,
              icon: matchIcon(Icons.call_rounded, 'call',
                  size: 17, color: AppColors.goldDark),
              onTap: onCall,
            ),
            const SizedBox(width: 8),
            CircleIconButton(
              tooltip: 'WhatsApp',
              size: 36,
              icon: matchIcon(Icons.chat_rounded, 'whatsapp',
                  size: 17, color: AppColors.goldDark),
              onTap: onWhatsApp,
            ),
          ],
        ),
      ],
    );
  }
}

class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 3, 8, 3),
      decoration: BoxDecoration(
        color: AppColors.verified.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          matchIcon(Icons.verified_rounded, 'verified',
              size: 14, color: AppColors.verified),
          const SizedBox(width: 4),
          const Text(
            'Verified',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.verified,
            ),
          ),
        ],
      ),
    );
  }
}

class DontShowInfo extends StatelessWidget {
  const DontShowInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          matchIcon(Icons.visibility_off_outlined, 'eye_off',
              size: 20, color: AppColors.tealMid),
          const SizedBox(width: 10),
          const Expanded(
            child: Text.rich(
              TextSpan(
                text: "Profiles you hide won't appear in your matches. Tap ",
                children: [
                  TextSpan(
                    text: 'Show in matches',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' to bring one back.'),
                ],
              ),
              style: TextStyle(
                  fontSize: 13, height: 1.45, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  "More" bottom sheet
// ─────────────────────────────────────────────────────────────────────────────
class _MoreSheet extends StatelessWidget {
  const _MoreSheet({required this.current, required this.hiddenCount});

  final MatchTab current;
  final int hiddenCount;

  static const _icons = <MatchTab, (IconData, String)>{
    MatchTab.educationMatches: (Icons.school_outlined, 'education'),
    MatchTab.familyMatches: (Icons.family_restroom_rounded, 'family'),
    MatchTab.religiousMatches: (Icons.temple_hindu_outlined, 'religion'),
    MatchTab.dontShow: (Icons.visibility_off_outlined, 'eye_off'),
  };

  @override
  Widget build(BuildContext context) {
    final options = MatchTab.values.where((t) => t.inMore);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.fieldBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      'More matches',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
                CircleIconButton(
                  tooltip: 'Close',
                  size: 40,
                  background: AppColors.bgBottom,
                  icon: matchIcon(Icons.close_rounded, 'close',
                      size: 20, color: AppColors.navy),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final t in options) ...[
              _MoreOption(
                tab: t,
                icon: _icons[t]!,
                selected: t == current,
                count: t == MatchTab.dontShow ? hiddenCount : null,
                onTap: () => Navigator.of(context).pop(t),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _MoreOption extends StatelessWidget {
  const _MoreOption({
    required this.tab,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final MatchTab tab;
  final (IconData, String) icon;
  final bool selected;
  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? AppColors.tealMid : AppColors.blueTintBorder,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.tealMid.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: matchIcon(icon.$1, icon.$2,
                      size: 19, color: AppColors.tealMid),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tab.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                if (count != null && count! > 0)
                  Container(
                    constraints: const BoxConstraints(minWidth: 24),
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.toggleBg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldDark,
                      ),
                    ),
                  ),
                if (selected) ...[
                  const SizedBox(width: 6),
                  matchIcon(Icons.check_rounded, 'check',
                      size: 20, color: AppColors.tealMid),
                ],
                const SizedBox(width: 4),
                matchIcon(Icons.chevron_right_rounded, 'arrow_right',
                    size: 20, color: AppColors.hint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Shared widgets (also used by the search screens)
// ─────────────────────────────────────────────────────────────────────────────
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.size = 44,
    this.background = AppColors.toggleBg,
    this.borderColor,
    this.badge,
  });

  final Widget icon;
  final VoidCallback onTap;
  final String tooltip;
  final double size;
  final Color background;
  final Color? borderColor;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: background,
            shape: CircleBorder(
              side: borderColor == null
                  ? BorderSide.none
                  : BorderSide(color: borderColor!),
            ),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(
                width: size,
                height: size,
                child: Center(child: icon),
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: 2,
              right: 2,
              child: IgnorePointer(
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 16, minHeight: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.coral,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.icon,
    required this.foreground,
    required this.onTap,
    this.background,
    this.gradient,
    this.borderColor,
    this.borderWidth = 1,
  });

  final String label;
  final Widget icon;
  final Color foreground;
  final VoidCallback? onTap;
  final Color? background;
  final Gradient? gradient;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: gradient == null ? background : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(999),
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: borderWidth),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: SizedBox(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Illustrated placeholder avatar (used when a profile has no photo).
class AvatarPainter extends CustomPainter {
  const AvatarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Drawn on a 112 × 150 grid, scaled to fit.
    final s = size.width / 112;
    canvas.save();
    canvas.translate(0, size.height - 150 * s);
    canvas.scale(s);

    final paint = Paint()..isAntiAlias = true;

    // Shoulders
    paint.color = _kShirt;
    canvas.drawPath(
      Path()
        ..moveTo(6, 150)
        ..cubicTo(8, 120, 28, 108, 56, 108)
        ..cubicTo(84, 108, 104, 120, 106, 150)
        ..close(),
      paint,
    );

    // Neck
    paint.color = _kNeck;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(46, 86, 20, 26), const Radius.circular(8)),
      paint,
    );

    // Face
    paint.color = _kSkin;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(56, 64), width: 52, height: 60),
      paint,
    );

    // Hair
    paint.color = _kHair;
    canvas.drawPath(
      Path()
        ..moveTo(29, 64)
        ..cubicTo(26, 36, 41, 26, 57, 26)
        ..cubicTo(75, 26, 88, 36, 84, 64)
        ..cubicTo(81, 52, 74, 45, 61, 45)
        ..cubicTo(48, 45, 35, 48, 29, 64)
        ..close(),
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// import 'package:flutter/material.dart';
// import 'package:vivahbharath_app/view/custom/app_colors.dart';
// import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
// import 'package:vivahbharath_app/view/drawer/chat_screen.dart';

// /// Shared pieces for Manage Interest and Manage Request.

// enum ActStatus { pending, accepted, declined }

// class ActivityPerson {
//   ActivityPerson({
//     required this.name,
//     required this.lastSeen,
//     required this.line1,
//     required this.line2,
//     required this.line3,
//     this.id = 'VB[ID]',
//     this.online = false,
//     this.premium = false,
//     this.nameHidden = false,
//     this.photoUrl,
//   });

//   final String id;
//   final String name;
//   final String lastSeen;
//   final String line1;
//   final String line2;
//   final String line3;
//   final bool online;
//   final bool premium;
//   final bool nameHidden;
//   final String? photoUrl;
// }

// /// Sample people (from the app designs). TODO: replace with API data.
// class SamplePeople {
//   static final a = ActivityPerson(
//     name: '[Name]',
//     lastSeen: 'Last seen 2 weeks ago',
//     line1: '28 Yrs · 5\'4" · [Religion] · [Community]',
//     line2: 'Bachelors Degree · Software Engineer',
//     line3: 'Malappuram · Kerala · India',
//   );
//   static final b = ActivityPerson(
//     name: '[Name]',
//     lastSeen: 'Last seen 3 hours ago',
//     line1: '25 Yrs · 5\'2" · Hindu · Nair',
//     line2: 'Masters Degree · Teacher',
//     line3: 'Kozhikode · Kerala · India',
//     online: true,
//     premium: true,
//   );
//   static final c = ActivityPerson(
//     name: '[Name]',
//     lastSeen: 'Last seen 1 day ago',
//     line1: '27 Yrs · 5\'5" · Hindu · Ezhava',
//     line2: 'Bachelors Degree · Designer',
//     line3: 'Thrissur · Kerala · India',
//   );
//   static final d = ActivityPerson(
//     name: '[Name]',
//     lastSeen: 'Last seen 55 minutes ago',
//     line1: '26 Yrs · 5\'3" · Hindu · Nair',
//     line2: 'MBBS · Doctor',
//     line3: 'Kannur · Kerala · India',
//     online: true,
//   );
//   static final e = ActivityPerson(
//     name: '[Name]',
//     lastSeen: 'Last seen 5 hours ago',
//     line1: '24 Yrs · 5\'1" · Hindu · Nair',
//     line2: 'Bachelors Degree · Accountant',
//     line3: 'Kochi · Kerala · India',
//   );
// }

// void showActivityToast(BuildContext context, String msg,
//     {VoidCallback? onUndo}) {
//   ScaffoldMessenger.of(context)
//     ..hideCurrentSnackBar()
//     ..showSnackBar(SnackBar(
//       behavior: SnackBarBehavior.floating,
//       backgroundColor: AppColors.navy,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//       duration: const Duration(milliseconds: 3500),
//       content: Text(msg, style: const TextStyle(fontSize: 13)),
//       action: onUndo == null
//           ? null
//           : SnackBarAction(
//               label: 'Undo',
//               textColor: AppColors.goldBorder,
//               onPressed: onUndo),
//     ));
// }

// Future<bool> confirmAction(
//   BuildContext context, {
//   required String title,
//   required String message,
//   required String confirm,
//   bool danger = true,
// }) async {
//   final ok = await showDialog<bool>(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       title: Text(title,
//           style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: AppColors.navy)),
//       content: Text(message,
//           style: const TextStyle(fontSize: 14, color: AppColors.textMuted)),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(ctx, false),
//           child: const Text('Cancel',
//               style: TextStyle(color: AppColors.textMuted)),
//         ),
//         FilledButton(
//           style: FilledButton.styleFrom(
//               backgroundColor: danger ? AppColors.coral : AppColors.tealMid),
//           onPressed: () => Navigator.pop(ctx, true),
//           child: Text(confirm),
//         ),
//       ],
//     ),
//   );
//   return ok == true;
// }

// /// Opens a chat with [p].
// void openChatWith(BuildContext context, ActivityPerson p) {
//   Navigator.of(context).push(MaterialPageRoute(
//     builder: (_) => ChatScreen(
//       thread: ChatThread(
//         name: p.name,
//         id: p.id,
//         time: 'Now',
//         online: p.online,
//         premium: p.premium,
//         lastSeen: p.lastSeen,
//         photoUrl: p.photoUrl,
//         details: [p.line1.split(' · ').first, p.line2.split(' · ').last,
//           p.line3.split(' · ').first],
//       ),
//     ),
//   ));
// }

// // ── Buttons ─────────────────────────────────────────────────────────────────
// Widget actPair(Widget a, Widget b) => Row(
//       children: [
//         Expanded(child: a),
//         const SizedBox(width: 8),
//         Expanded(child: b),
//       ],
//     );

// Widget actPrimary(String label, IconData icon, VoidCallback onTap) =>
//     PillButton(
//       label: label,
//       icon: matchIcon(icon, 'action', size: 17, color: Colors.white),
//       foreground: Colors.white,
//       gradient: kTealGradient,
//       onTap: onTap,
//     );

// Widget actOutline(String label, IconData icon, VoidCallback onTap) =>
//     PillButton(
//       label: label,
//       icon: matchIcon(icon, 'action', size: 17, color: AppColors.navy),
//       foreground: AppColors.navy,
//       background: Colors.white,
//       borderColor: AppColors.fieldBorder,
//       onTap: onTap,
//     );

// Widget actCream(String label, IconData icon, VoidCallback onTap) => PillButton(
//       label: label,
//       icon: matchIcon(icon, 'action', size: 17, color: AppColors.goldDark),
//       foreground: AppColors.goldDark,
//       gradient:
//           const LinearGradient(colors: [AppColors.loginA, AppColors.loginB]),
//       borderColor: AppColors.goldBorder,
//       onTap: onTap,
//     );

// enum ActTone { ok, bad, waiting }

// (Color, Color) actToneColors(ActTone t) => switch (t) {
//       ActTone.ok => (
//           AppColors.verified.withValues(alpha: 0.12),
//           AppColors.verified
//         ),
//       ActTone.bad => (AppColors.coral.withValues(alpha: 0.1), AppColors.coral),
//       ActTone.waiting => (AppColors.toggleBg, AppColors.goldDark),
//     };

// /// Full-width status (not tappable).
// Widget actStatus(String label, IconData icon, ActTone tone) {
//   final (bg, fg) = actToneColors(tone);
//   return PillButton(
//     label: label,
//     icon: matchIcon(icon, 'status', size: 16, color: fg),
//     foreground: fg,
//     background: bg,
//     onTap: null,
//   );
// }

// /// Small status pill on the left, text link on the right.
// Widget actStatusWithLink(
//   String label,
//   ActTone tone,
//   String link,
//   VoidCallback onTap,
// ) {
//   final (bg, fg) = actToneColors(tone);
//   return Row(
//     children: [
//       Container(
//         height: 34,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration:
//             BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             matchIcon(
//                 tone == ActTone.ok ? Icons.check_rounded : Icons.close_rounded,
//                 'status',
//                 size: 15,
//                 color: fg),
//             const SizedBox(width: 4),
//             Text(label,
//                 style: TextStyle(
//                     fontSize: 13, fontWeight: FontWeight.w700, color: fg)),
//           ],
//         ),
//       ),
//       const Spacer(),
//       TextButton(
//         onPressed: onTap,
//         style: TextButton.styleFrom(foregroundColor: AppColors.link),
//         child: Text(link,
//             style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
//       ),
//     ],
//   );
// }

// // ── Widgets ─────────────────────────────────────────────────────────────────

// /// Two-option switch (Received / Sent).
// class ActSegmented extends StatelessWidget {
//   const ActSegmented({
//     super.key,
//     required this.labels,
//     required this.index,
//     required this.onPick,
//   });

//   final List<String> labels;
//   final int index;
//   final ValueChanged<int> onPick;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: AppColors.blueTint,
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Row(
//         children: [
//           for (var i = 0; i < labels.length; i++)
//             Expanded(
//               child: Semantics(
//                 selected: i == index,
//                 button: true,
//                 child: Material(
//                   color: i == index ? Colors.white : Colors.transparent,
//                   elevation: i == index ? 1 : 0,
//                   shadowColor: AppColors.tealDark.withValues(alpha: 0.2),
//                   shape: const StadiumBorder(),
//                   child: InkWell(
//                     customBorder: const StadiumBorder(),
//                     onTap: () => onPick(i),
//                     child: SizedBox(
//                       height: 42,
//                       child: Center(
//                         child: Text(
//                           labels[i],
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight:
//                                 i == index ? FontWeight.w700 : FontWeight.w600,
//                             color: i == index
//                                 ? AppColors.navy
//                                 : AppColors.textMuted,
//                           ),
//                         ),
//                       ),
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

// /// Profile card used on both screens.
// class ActivityCard extends StatelessWidget {
//   const ActivityCard({
//     super.key,
//     required this.person,
//     required this.note,
//     required this.noteIcon,
//     this.highlight = false,
//     this.actions,
//     this.onTap,
//   });

//   final ActivityPerson person;

//   /// e.g. "Sent you interest · today"
//   final String note;
//   final IconData noteIcon;

//   /// Pending items get a soft tint so they stand out.
//   final bool highlight;
//   final Widget? actions;
//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final p = person;
//     const detail = TextStyle(fontSize: 13, height: 1.4, color: AppColors.navy);

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.white, highlight ? AppColors.cream : Colors.white],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: highlight ? AppColors.goldBorder : AppColors.blueTintBorder,
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
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _Photo(person: p),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Flexible(
//                                 child: Text(
//                                   p.name,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w700,
//                                     color: AppColors.navy,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 4),
//                               matchIcon(Icons.verified_rounded, 'verified',
//                                   size: 16, color: AppColors.verified),
//                             ],
//                           ),
//                           const SizedBox(height: 2),
//                           Text(
//                             '${p.id} · ${p.lastSeen}',
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                                 fontSize: 12, color: AppColors.textMuted),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(p.line1, style: detail),
//                           Text(p.line2, style: detail),
//                           Text(p.line3, style: detail),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
//                   decoration: BoxDecoration(
//                     color: AppColors.toggleBg.withValues(alpha: 0.6),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     children: [
//                       matchIcon(noteIcon, 'note',
//                           size: 15, color: AppColors.brown),
//                       const SizedBox(width: 6),
//                       Expanded(
//                         child: Text(
//                           note,
//                           style: const TextStyle(
//                             fontSize: 12.5,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.brown,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (actions != null) ...[
//                   const SizedBox(height: 10),
//                   actions!,
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _Photo extends StatelessWidget {
//   const _Photo({required this.person});
//   final ActivityPerson person;

//   @override
//   Widget build(BuildContext context) {
//     final p = person;
//     return SizedBox(
//       width: 88,
//       height: 108,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.blueTint,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(
//                   color: p.premium ? AppColors.marigoldO : Colors.transparent,
//                   width: 2,
//                 ),
//               ),
//               clipBehavior: Clip.antiAlias,
//               child: p.photoUrl != null
//                   ? Image.network(p.photoUrl!, fit: BoxFit.cover)
//                   : const CustomPaint(painter: AvatarPainter()),
//             ),
//           ),
//           if (p.premium)
//             Positioned(
//               top: -6,
//               left: -6,
//               child: Container(
//                 width: 22,
//                 height: 22,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: AppColors.marigoldY,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//                 child: matchIcon(Icons.workspace_premium_rounded, 'crown',
//                     size: 12, color: AppColors.goldDark),
//               ),
//             ),
//           if (p.online)
//             Positioned(
//               left: 7,
//               bottom: 7,
//               child: Container(
//                 width: 12,
//                 height: 12,
//                 decoration: BoxDecoration(
//                   color: AppColors.online,
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 2),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// /// Empty state box.
// class ActEmpty extends StatelessWidget {
//   const ActEmpty({super.key, required this.icon, required this.text});
//   final IconData icon;
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.blueTintBorder),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: 56,
//             height: 56,
//             alignment: Alignment.center,
//             decoration: const BoxDecoration(
//               color: AppColors.blueTint,
//               shape: BoxShape.circle,
//             ),
//             child: matchIcon(icon, 'empty', size: 26, color: AppColors.tealMid),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             text,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Plain gradient page background + top bar + body.
// class ActivityPage extends StatelessWidget {
//   const ActivityPage({
//     super.key,
//     required this.title,
//     required this.children,
//     this.bottomNavigationBar,
//   });

//   final String title;
//   final List<Widget> children;
//   final Widget? bottomNavigationBar;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgBottom,
//       bottomNavigationBar: bottomNavigationBar,
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
//             children: children,
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/custom/profile_badges.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/drawer/chat_screen.dart';


/// Shared pieces for Manage Interest and Manage Request.

enum ActStatus { pending, accepted, declined, withdrawn }

class ActivityPerson {
  ActivityPerson({
    required this.name,
    required this.lastSeen,
    required this.line1,
    required this.line2,
    required this.line3,
    this.id = 'VB[ID]',
    this.online = false,
    this.premium = false,
    this.verified = true,
    this.featured = false,
    this.nameHidden = false,
    this.photoUrl,
  });

  final String id;
  final String name;
  final String lastSeen;
  final String line1;
  final String line2;
  final String line3;
  final bool online;

  /// Paid member — shows the "Paid Member" badge.
  final bool premium;
  final bool verified;
  final bool featured;
  final bool nameHidden;
  final String? photoUrl;
}

/// Sample people (from the app designs). TODO: replace with API data.
class SamplePeople {
  static final a = ActivityPerson(
    name: '[Name]',
    lastSeen: 'Last seen 2 weeks ago',
    line1: '28 Yrs · 5\'4" · [Religion] · [Community]',
    line2: 'Bachelors Degree · Software Engineer',
    line3: 'Malappuram · Kerala · India',
  );
  static final b = ActivityPerson(
    name: '[Name]',
    lastSeen: 'Last seen 3 hours ago',
    line1: '25 Yrs · 5\'2" · Hindu · Nair',
    line2: 'Masters Degree · Teacher',
    line3: 'Kozhikode · Kerala · India',
    online: true,
    premium: true,
    featured: true,
  );
  static final c = ActivityPerson(
    name: '[Name]',
    lastSeen: 'Last seen 1 day ago',
    line1: '27 Yrs · 5\'5" · Hindu · Ezhava',
    line2: 'Bachelors Degree · Designer',
    line3: 'Thrissur · Kerala · India',
  );
  static final d = ActivityPerson(
    name: '[Name]',
    lastSeen: 'Last seen 55 minutes ago',
    line1: '26 Yrs · 5\'3" · Hindu · Nair',
    line2: 'MBBS · Doctor',
    line3: 'Kannur · Kerala · India',
    online: true,
  );
  static final e = ActivityPerson(
    name: '[Name]',
    lastSeen: 'Last seen 5 hours ago',
    line1: '24 Yrs · 5\'1" · Hindu · Nair',
    line2: 'Bachelors Degree · Accountant',
    line3: 'Kochi · Kerala · India',
  );
}

void showActivityToast(BuildContext context, String msg,
    {VoidCallback? onUndo}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
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
              onPressed: onUndo),
    ));
}

Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String message,
  required String confirm,
  bool danger = true,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      icon: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.marigoldO, width: 2.5),
        ),
        child: const Text('!',
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: AppColors.marigoldO)),
      ),
      title: Text(title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.navy)),
      content: Text(message,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 14, height: 1.4, color: AppColors.textMuted)),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      actions: [
        Row(
          children: [
            Expanded(
              child: PillButton(
                label: 'Cancel',
                icon: const SizedBox.shrink(),
                foreground: AppColors.navy,
                background: Colors.white,
                borderColor: AppColors.fieldBorder,
                onTap: () => Navigator.pop(ctx, false),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PillButton(
                label: confirm,
                icon: const SizedBox.shrink(),
                foreground: Colors.white,
                background: danger ? AppColors.coral : AppColors.tealMid,
                onTap: () => Navigator.pop(ctx, true),
              ),
            ),
          ],
        ),
      ],
    ),
  );
  return ok == true;
}

/// Opens a chat with [p].
void openChatWith(BuildContext context, ActivityPerson p) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => ChatScreen(
      thread: ChatThread(
        name: p.name,
        id: p.id,
        time: 'Now',
        online: p.online,
        premium: p.premium,
        lastSeen: p.lastSeen,
        photoUrl: p.photoUrl,
        details: [p.line1.split(' · ').first, p.line2.split(' · ').last,
          p.line3.split(' · ').first],
      ),
    ),
  ));
}

// ── Buttons ─────────────────────────────────────────────────────────────────
Widget actPair(Widget a, Widget b) => Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: 8),
        Expanded(child: b),
      ],
    );

Widget actPrimary(String label, IconData icon, VoidCallback onTap) =>
    PillButton(
      label: label,
      icon: matchIcon(icon, 'action', size: 17, color: Colors.white),
      foreground: Colors.white,
      gradient: kTealGradient,
      onTap: onTap,
    );

Widget actOutline(String label, IconData icon, VoidCallback onTap) =>
    PillButton(
      label: label,
      icon: matchIcon(icon, 'action', size: 17, color: AppColors.navy),
      foreground: AppColors.navy,
      background: Colors.white,
      borderColor: AppColors.fieldBorder,
      onTap: onTap,
    );

Widget actCream(String label, IconData icon, VoidCallback onTap) => PillButton(
      label: label,
      icon: matchIcon(icon, 'action', size: 17, color: AppColors.goldDark),
      foreground: AppColors.goldDark,
      gradient:
          const LinearGradient(colors: [AppColors.loginA, AppColors.loginB]),
      borderColor: AppColors.goldBorder,
      onTap: onTap,
    );

enum ActTone { ok, bad, waiting }

(Color, Color) actToneColors(ActTone t) => switch (t) {
      ActTone.ok => (
          AppColors.verified.withValues(alpha: 0.12),
          AppColors.verified
        ),
      ActTone.bad => (AppColors.coral.withValues(alpha: 0.1), AppColors.coral),
      ActTone.waiting => (AppColors.toggleBg, AppColors.goldDark),
    };

/// Full-width status (not tappable).
Widget actStatus(String label, IconData icon, ActTone tone) {
  final (bg, fg) = actToneColors(tone);
  return PillButton(
    label: label,
    icon: matchIcon(icon, 'status', size: 16, color: fg),
    foreground: fg,
    background: bg,
    onTap: null,
  );
}

/// Small status pill on the left, text link on the right.
Widget actStatusWithLink(
  String label,
  ActTone tone,
  String link,
  VoidCallback onTap,
) {
  final (bg, fg) = actToneColors(tone);
  return Row(
    children: [
      Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            matchIcon(
                tone == ActTone.ok ? Icons.check_rounded : Icons.close_rounded,
                'status',
                size: 15,
                color: fg),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: fg)),
          ],
        ),
      ),
      const Spacer(),
      TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(foregroundColor: AppColors.link),
        child: Text(link,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ),
    ],
  );
}

// ── Widgets ─────────────────────────────────────────────────────────────────

/// Two-option switch (Received / Sent).
class ActSegmented extends StatelessWidget {
  const ActSegmented({
    super.key,
    required this.labels,
    required this.index,
    required this.onPick,
  });

  final List<String> labels;
  final int index;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                selected: i == index,
                button: true,
                child: Material(
                  color: i == index ? Colors.white : Colors.transparent,
                  elevation: i == index ? 1 : 0,
                  shadowColor: AppColors.tealDark.withValues(alpha: 0.2),
                  shape: const StadiumBorder(),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () => onPick(i),
                    child: SizedBox(
                      height: 42,
                      child: Center(
                        child: Text(
                          labels[i],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                i == index ? FontWeight.w700 : FontWeight.w600,
                            color: i == index
                                ? AppColors.navy
                                : AppColors.textMuted,
                          ),
                        ),
                      ),
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

/// Profile card used on both screens.
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.person,
    required this.note,
    required this.noteIcon,
    this.highlight = false,
    this.actions,
    this.onTap,
  });

  final ActivityPerson person;

  /// e.g. "Sent you interest · today"
  final String note;
  final IconData noteIcon;

  /// Pending items get a soft tint so they stand out.
  final bool highlight;
  final Widget? actions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = person;
    const detail = TextStyle(fontSize: 13, height: 1.4, color: AppColors.navy);

    final card = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: p.featured
              ? [AppColors.loginA, Colors.white]
              : [Colors.white, highlight ? AppColors.cream : Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight || p.featured
              ? AppColors.goldBorder
              : AppColors.blueTintBorder,
          width: p.featured ? 1.4 : 1,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Photo(person: p),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (p.verified || p.premium) ...[
                            ProfileBadges(
                              verified: p.verified,
                              paid: p.premium,
                              compact: true,
                            ),
                            const SizedBox(height: 6),
                          ],
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  p.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                              if (p.online) ...[
                                const SizedBox(width: 6),
                                const OnlineBadge(),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${p.id} · ${p.lastSeen}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Text(p.line1, style: detail),
                          Text(p.line2, style: detail),
                          Text(p.line3, style: detail),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.toggleBg.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      matchIcon(noteIcon, 'note',
                          size: 15, color: AppColors.brown),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          note,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (actions != null) ...[
                  const SizedBox(height: 10),
                  actions!,
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return withFeaturedRibbon(card, featured: p.featured);
  }
}

class _Photo extends StatelessWidget {
  const _Photo({required this.person});
  final ActivityPerson person;

  @override
  Widget build(BuildContext context) {
    final p = person;
    return SizedBox(
      width: 88,
      height: 108,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.blueTint,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: p.premium ? AppColors.marigoldO : Colors.transparent,
                  width: 2,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: p.photoUrl != null
                  ? Image.network(p.photoUrl!, fit: BoxFit.cover)
                  : const CustomPaint(painter: AvatarPainter()),
            ),
          ),
          if (p.premium)
            Positioned(
              top: -6,
              left: -6,
              child: Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.marigoldY,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: matchIcon(Icons.workspace_premium_rounded, 'crown',
                    size: 12, color: AppColors.goldDark),
              ),
            ),
          if (p.online)
            Positioned(
              left: 7,
              bottom: 7,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.online,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Empty state box.
class ActEmpty extends StatelessWidget {
  const ActEmpty({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blueTintBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.blueTint,
              shape: BoxShape.circle,
            ),
            child: matchIcon(icon, 'empty', size: 26, color: AppColors.tealMid),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// Plain gradient page background + top bar + body.
class ActivityPage extends StatelessWidget {
  const ActivityPage({
    super.key,
    required this.title,
    required this.children,
    this.bottomNavigationBar,
  });

  final String title;
  final List<Widget> children;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      bottomNavigationBar: bottomNavigationBar,
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
            children: children,
          ),
        ),
      ),
    );
  }
}


/// Count tile used as a filter (Accepted / Pending / Declined / Withdrawn).
class ActStatTile extends StatelessWidget {
  const ActStatTile({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: '$label, $count',
      child: Material(
        color: selected ? color : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: selected ? color : AppColors.blueTintBorder),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.2)
                        : color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: matchIcon(icon, 'stat',
                      size: 15, color: selected ? Colors.white : color),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.navy,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The four status tiles in one row.
class ActStatRow extends StatelessWidget {
  const ActStatRow({
    super.key,
    required this.counts,
    required this.selected,
    required this.onPick,
  });

  final Map<ActStatus, int> counts;
  final ActStatus? selected;

  /// Called with the tapped status, or null when the selected one is tapped again.
  final ValueChanged<ActStatus?> onPick;

  static const _defs = <(ActStatus, String, IconData, Color)>[
    (ActStatus.accepted, 'Accepted', Icons.check_rounded, AppColors.verified),
    (ActStatus.pending, 'Pending', Icons.schedule_rounded, AppColors.goldDark),
    (ActStatus.declined, 'Declined', Icons.close_rounded, AppColors.coral),
    (ActStatus.withdrawn, 'Withdrawn', Icons.undo_rounded, AppColors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < _defs.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: ActStatTile(
              label: _defs[i].$2,
              icon: _defs[i].$3,
              color: _defs[i].$4,
              count: counts[_defs[i].$1] ?? 0,
              selected: selected == _defs[i].$1,
              onTap: () =>
                  onPick(selected == _defs[i].$1 ? null : _defs[i].$1),
            ),
          ),
        ],
      ],
    );
  }
}

/// List heading with a one-line description.
class ActListHeader extends StatelessWidget {
  const ActListHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onShowAll,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onShowAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      fontSize: 12.5, color: AppColors.textMuted)),
            ],
          ),
        ),
        if (onShowAll != null)
          TextButton(
            onPressed: onShowAll,
            style: TextButton.styleFrom(foregroundColor: AppColors.link),
            child: const Text('Show all',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
      ],
    );
  }
}
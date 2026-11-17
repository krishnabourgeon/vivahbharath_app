import 'package:flutter/material.dart';
import 'package:vivahbharath_app/view/custom/app_colors.dart';
import 'package:vivahbharath_app/view/dashboard/matche_screen.dart';
import 'package:vivahbharath_app/view/dashboard/search_screen.dart';


// ─────────────────────────────────────────────────────────────────────────────
//  Model
// ─────────────────────────────────────────────────────────────────────────────
enum ChatItemType { day, system, message }

class ChatItem {
  ChatItem.day(this.text)
      : type = ChatItemType.day,
        mine = false,
        time = '';
  ChatItem.system(this.text)
      : type = ChatItemType.system,
        mine = false,
        time = '';
  ChatItem.msg(this.text, {required this.mine, required this.time})
      : type = ChatItemType.message;

  final ChatItemType type;
  final String text;
  final bool mine;
  final String time;
}

class ChatThread {
  ChatThread({
    required this.name,
    required this.time,
    this.id = 'VB[ID]',
    this.online = false,
    this.premium = false,
    this.lastSeen = 'Last seen recently',
    this.unread = 0,
    this.details = const [],
    this.photoUrl,
    List<ChatItem>? items,
  }) : items = items ?? [];

  final String id;
  final String name;
  final bool online;
  final bool premium;
  final String lastSeen;
  String time; // shown in the list
  int unread;
  final List<String> details; // ["26 yrs", "Software Engineer", "Kozhikode"]
  final String? photoUrl;
  final List<ChatItem> items;

  ChatItem? get last {
    for (var i = items.length - 1; i >= 0; i--) {
      if (items[i].type == ChatItemType.message) return items[i];
    }
    return null;
  }
}

/// Sample chats from the app designs — replace with your API data.
List<ChatThread> sampleChats() => [
      ChatThread(
        name: '[Name]',
        time: '2:41 PM',
        online: true,
        premium: true,
        unread: 2,
        details: ['26 yrs', 'Software Engineer', 'Kozhikode'],
        items: [
          ChatItem.day('Yesterday'),
          ChatItem.system('Interest accepted · You can now chat'),
          ChatItem.msg('Hi! Thank you for accepting my interest. How are you?',
              mine: true, time: '7:12 PM'),
          ChatItem.msg("Hello! I'm doing well, thank you. Nice to hear from you.",
              mine: false, time: '7:20 PM'),
          ChatItem.day('Today'),
          ChatItem.msg("I saw you're also from Kozhikode. Do you work there?",
              mine: true, time: '2:30 PM'),
          ChatItem.msg('Yes, I work as a software engineer here. And you?',
              mine: false, time: '2:36 PM'),
          ChatItem.msg('Same field! Maybe our families could talk this weekend?',
              mine: true, time: '2:39 PM'),
          ChatItem.msg('That sounds lovely! Let me ask my parents too 😊',
              mine: false, time: '2:41 PM'),
        ],
      ),
      ChatThread(
        name: '[Name]',
        time: '11:05 AM',
        unread: 1,
        items: [
          ChatItem.msg('Thank you for accepting my interest.',
              mine: false, time: '11:05 AM'),
        ],
      ),
      ChatThread(
        name: '[Name]',
        time: 'Yesterday',
        online: true,
        items: [
          ChatItem.msg('Do you enjoy travelling?', mine: true, time: '6:10 PM'),
        ],
      ),
      ChatThread(
        name: '[Name]',
        time: 'Mon',
        premium: true,
        items: [
          ChatItem.msg('Sure, Sunday evening works for a call.',
              mine: false, time: '8:02 PM'),
        ],
      ),
      ChatThread(
        name: '[Name]',
        time: '24 Oct',
        items: [
          ChatItem.msg('Nice to meet you!', mine: true, time: '9:15 AM'),
        ],
      ),
      ChatThread(
        name: '[Name]',
        time: '20 Oct',
        items: [
          ChatItem.msg('My family is from Kozhikode as well.',
              mine: false, time: '4:40 PM'),
        ],
      ),
      // A new connection with no messages yet → shows the "You're connected!" start.
      ChatThread(
        name: '[Name]',
        time: 'New',
        lastSeen: 'Last seen 55 minutes ago',
        details: ['26 yrs', 'Software Engineer', 'Kozhikode'],
      ),
    ];

// ─────────────────────────────────────────────────────────────────────────────
//  Chats list
// ─────────────────────────────────────────────────────────────────────────────
enum _ChatFilter { all, unread, online }

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({
    super.key,
    this.threads,
    this.chatsLeft = 7,
    this.chatsTotal = 10,
    this.packageName = 'Launching offer package',
    this.onUpgrade,
    this.onNewChat,
    this.showBottomNav = true,
  });

  final List<ChatThread>? threads;
  final int chatsLeft;
  final int chatsTotal;
  final String packageName;
  final VoidCallback? onUpgrade;
  final VoidCallback? onNewChat;
  final bool showBottomNav;

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late final List<ChatThread> _threads = widget.threads ?? sampleChats();
  _ChatFilter _filter = _ChatFilter.all;
  String _q = '';

  List<ChatThread> get _visible => _threads.where((t) {
        if (_filter == _ChatFilter.unread && t.unread == 0) return false;
        if (_filter == _ChatFilter.online && !t.online) return false;
        if (_q.isNotEmpty) {
          final hay = '${t.name} ${t.last?.text ?? ''}'.toLowerCase();
          if (!hay.contains(_q.toLowerCase())) return false;
        }
        return true;
      }).toList();

  Future<void> _open(ChatThread t) async {
    setState(() => t.unread = 0);
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatScreen(thread: t)),
    );
    if (mounted) setState(() {}); // refresh last message / time
  }

  @override
  Widget build(BuildContext context) {
    final rows = _visible;
    final unreadCount = _threads.where((t) => t.unread > 0).length;

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
              SearchTopBar(
                title: 'Chats',
                // trailing: CircleIconButton(
                //   tooltip: 'New chat',
                //   background: AppColors.tealMid,
                //   // icon: matchIcon(Icons.edit_outlined, 'edit',
                //   //     size: 20, color: Colors.white),
                //   onTap: widget.onNewChat ?? () {/* TODO: pick a connection */},
                // ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (v) => setState(() => _q = v.trim()),
                  style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  decoration: InputDecoration(
                    hintText: 'Search chats',
                    hintStyle:
                        const TextStyle(fontSize: 14, color: AppColors.hint),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 8),
                      child: matchIcon(Icons.search_rounded, 'search',
                          size: 20, color: AppColors.textMuted),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide:
                          const BorderSide(color: AppColors.fieldBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide:
                          const BorderSide(color: AppColors.fieldBorder),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999),
                      borderSide: const BorderSide(
                          color: AppColors.tealMid, width: 1.4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    FilterPill(
                      label: 'All',
                      selected: _filter == _ChatFilter.all,
                      onTap: () => setState(() => _filter = _ChatFilter.all),
                    ),
                    const SizedBox(width: 8),
                    FilterPill(
                      label: unreadCount > 0 ? 'Unread ($unreadCount)' : 'Unread',
                      selected: _filter == _ChatFilter.unread,
                      onTap: () => setState(() => _filter = _ChatFilter.unread),
                    ),
                    const SizedBox(width: 8),
                    FilterPill(
                      label: 'Online',
                      selected: _filter == _ChatFilter.online,
                      onTap: () => setState(() => _filter = _ChatFilter.online),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  children: [
                    _QuotaBanner(
                      left: widget.chatsLeft,
                      total: widget.chatsTotal,
                      packageName: widget.packageName,
                      onUpgrade: widget.onUpgrade ?? () {/* TODO */},
                    ),
                    const SizedBox(height: 12),
                    if (rows.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Text(
                          'No chats here yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, color: AppColors.textMuted),
                        ),
                      ),
                    for (final t in rows) ...[
                      _ChatTile(thread: t, onTap: () => _open(t)),
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
}

class _QuotaBanner extends StatelessWidget {
  const _QuotaBanner({
    required this.left,
    required this.total,
    required this.packageName,
    required this.onUpgrade,
  });
  final int left;
  final int total;
  final String packageName;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.goldBorder),
      ),
      child: Row(
        children: [
          matchIcon(Icons.chat_bubble_outline_rounded, 'chat',
              size: 18, color: AppColors.goldDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$left of $total chats left',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' on your $packageName'),
                ],
              ),
              style: const TextStyle(
                  fontSize: 12.5, height: 1.35, color: AppColors.goldDark),
            ),
          ),
          TextButton(
            onPressed: onUpgrade,
            style: TextButton.styleFrom(foregroundColor: AppColors.link),
            child: const Text(
              'Upgrade',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.thread, required this.onTap});
  final ChatThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = thread;
    final last = t.last;
    final unread = t.unread > 0;
    final preview = last == null
        ? "You're connected! Say hello 👋"
        : (last.mine ? 'You: ${last.text}' : last.text);

    return Material(
      color: unread ? null : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
            color: unread
                ? AppColors.tealMid.withValues(alpha: 0.35)
                : AppColors.blueTintBorder),
      ),
      child: Ink(
        decoration: unread
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Colors.white, AppColors.blueTint],
                ),
              )
            : null,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ChatAvatar(
                  size: 54,
                  online: t.online,
                  premium: t.premium,
                  photoUrl: t.photoUrl,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              t.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          matchIcon(Icons.verified_rounded, 'verified',
                              size: 15, color: AppColors.verified),
                          const Spacer(),
                          Text(
                            t.time,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight:
                                  unread ? FontWeight.w700 : FontWeight.w500,
                              color: unread
                                  ? AppColors.tealMid
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              preview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight:
                                    unread ? FontWeight.w700 : FontWeight.w400,
                                color: unread
                                    ? AppColors.navy
                                    : AppColors.textMuted,
                              ),
                            ),
                          ),
                          if (unread) ...[
                            const SizedBox(width: 8),
                            Container(
                              constraints: const BoxConstraints(minWidth: 22),
                              height: 22,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.tealMid,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${t.unread}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
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

/// Round avatar with online dot and premium crown.
class ChatAvatar extends StatelessWidget {
  const ChatAvatar({
    super.key,
    this.size = 48,
    this.online = false,
    this.premium = false,
    this.photoUrl,
  });

  final double size;
  final bool online;
  final bool premium;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blueTint,
              border: Border.all(
                  color: premium ? AppColors.marigoldO : Colors.white,
                  width: 2),
            ),
            child: ClipOval(
              child: photoUrl != null
                  ? Image.network(photoUrl!, fit: BoxFit.cover)
                  : const CustomPaint(painter: AvatarPainter()),
            ),
          ),
          if (premium)
            Positioned(
              top: -4,
              left: -2,
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.marigoldY,
                  shape: BoxShape.circle,
                ),
                child: matchIcon(Icons.workspace_premium_rounded, 'crown',
                    size: 12, color: AppColors.goldDark),
              ),
            ),
          if (online)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.26,
                height: size * 0.26,
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

// ─────────────────────────────────────────────────────────────────────────────
//  Conversation
// ─────────────────────────────────────────────────────────────────────────────
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.thread,
    this.onSend,
    this.onCall,
    this.onViewProfile,
    this.onBlock,
    this.onReport,
    this.onAttach,
  });

  final ChatThread thread;

  /// TODO: send through your chat API / socket.
  final Future<void> Function(ChatThread thread, String text)? onSend;
  final VoidCallback? onCall;
  final VoidCallback? onViewProfile;
  final VoidCallback? onBlock;
  final VoidCallback? onReport;
  final VoidCallback? onAttach;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _canSend = false;

  static const _suggestions = [
    'Hi! I liked your profile. Can we talk?',
    'What do you enjoy doing on weekends?',
    'Tell me a little about your family.',
    'What are you looking for in a partner?',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      final c = _ctrl.text.trim().isNotEmpty;
      if (c != _canSend) setState(() => _canSend = c);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _ctrl.text).trim();
    if (text.isEmpty) return;
    final t = widget.thread;
    final now = TimeOfDay.now().format(context);
    setState(() {
      final hasToday = t.items.any(
          (i) => i.type == ChatItemType.day && i.text == 'Today');
      if (!hasToday) t.items.add(ChatItem.day('Today'));
      t.items.add(ChatItem.msg(text, mine: true, time: now));
      t.time = now;
      _ctrl.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut);
      }
    });
    await widget.onSend?.call(t, text);
  }

  Future<void> _menu() async {
    final pick = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.fieldBorder,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 8),
              for (final (icon, label, value, danger) in const [
                (Icons.person_outline_rounded, 'View profile', 'profile', false),
                (Icons.block_rounded, 'Block', 'block', true),
                (Icons.flag_outlined, 'Report', 'report', true),
              ])
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  leading: matchIcon(icon, value,
                      size: 22,
                      color: danger ? AppColors.coral : AppColors.navy),
                  title: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: danger ? AppColors.coral : AppColors.navy,
                    ),
                  ),
                  onTap: () => Navigator.pop(ctx, value),
                ),
            ],
          ),
        ),
      ),
    );
    switch (pick) {
      case 'profile':
        widget.onViewProfile?.call();
      case 'block':
        widget.onBlock?.call();
      case 'report':
        widget.onReport?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.thread;
    final empty = t.last == null;

    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bgTop, AppColors.bgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(bottom: BorderSide(color: AppColors.blueTintBorder)),
                ),
                child: Row(
                  children: [
                    CircleIconButton(
                      tooltip: 'Back',
                      size: 40,
                      icon: matchIcon(Icons.chevron_left_rounded, 'back',
                          size: 24, color: AppColors.goldDark),
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 10),
                    ChatAvatar(size: 42, online: t.online, photoUrl: t.photoUrl),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: widget.onViewProfile,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    t.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                matchIcon(Icons.verified_rounded, 'verified',
                                    size: 15, color: AppColors.verified),
                              ],
                            ),
                            Text(
                              t.online ? 'Online now' : t.lastSeen,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: t.online
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: t.online
                                    ? AppColors.verified
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    CircleIconButton(
                      tooltip: 'Call',
                      size: 40,
                      background: Colors.white,
                      borderColor: AppColors.fieldBorder,
                      icon: matchIcon(Icons.call_outlined, 'call',
                          size: 19, color: AppColors.goldDark),
                      onTap: widget.onCall ?? () {/* TODO */},
                    ),
                    const SizedBox(width: 6),
                    CircleIconButton(
                      tooltip: 'More',
                      size: 40,
                      background: Colors.white,
                      borderColor: AppColors.fieldBorder,
                      icon: matchIcon(Icons.more_vert_rounded, 'more',
                          size: 20, color: AppColors.navy),
                      onTap: _menu,
                    ),
                  ],
                ),
              ),

              // Messages / connected start
              Expanded(
                child: empty
                    ? _ConnectedStart(
                        thread: t,
                        suggestions: _suggestions,
                        onPick: (s) => _ctrl.text = s,
                      )
                    : ListView.builder(
                        controller: _scroll,
                        reverse: true,
                        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                        itemCount: t.items.length,
                        itemBuilder: (_, i) =>
                            _ItemView(item: t.items[t.items.length - 1 - i]),
                      ),
              ),

              // Composer
              Container(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border:
                      Border(top: BorderSide(color: AppColors.blueTintBorder)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleIconButton(
                      tooltip: 'Attach',
                      size: 44,
                      background: AppColors.bgTop,
                      icon: matchIcon(Icons.add_rounded, 'add',
                          size: 22, color: AppColors.tealMid),
                      onTap: widget.onAttach ?? () {/* TODO */},
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        minLines: 1,
                        maxLines: 5,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(
                            fontSize: 14.5, color: AppColors.navy),
                        decoration: InputDecoration(
                          hintText: empty ? 'Say hello…' : 'Type a message…',
                          hintStyle: const TextStyle(color: AppColors.hint),
                          filled: true,
                          fillColor: AppColors.bgBottom,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: const BorderSide(
                                color: AppColors.blueTintBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: const BorderSide(
                                color: AppColors.blueTintBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: const BorderSide(
                                color: AppColors.tealMid, width: 1.3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Opacity(
                      opacity: _canSend ? 1 : 0.5,
                      child: Semantics(
                        button: true,
                        label: 'Send',
                        child: Material(
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: Ink(
                            decoration: const BoxDecoration(
                                gradient: kTealGradient),
                            child: InkWell(
                              onTap: _canSend ? () => _send() : null,
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: Center(
                                  child: matchIcon(Icons.send_rounded, 'send',
                                      size: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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

class _ItemView extends StatelessWidget {
  const _ItemView({required this.item});
  final ChatItem item;

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case ChatItemType.day:
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.blueTintBorder),
            ),
            child: Text(item.text,
                style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted)),
          ),
        );
      case ChatItemType.system:
        return Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.goldBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                matchIcon(Icons.favorite_border_rounded, 'heart',
                    size: 14, color: AppColors.goldDark),
                const SizedBox(width: 6),
                Text(item.text,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.goldDark)),
              ],
            ),
          ),
        );
      case ChatItemType.message:
        final mine = item.mine;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment:
                mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.74),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: mine ? kTealGradient : null,
                    color: mine ? null : Colors.white,
                    border: mine
                        ? null
                        : Border.all(color: AppColors.blueTintBorder),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(mine ? 18 : 4),
                      bottomRight: Radius.circular(mine ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 14.5,
                      height: 1.4,
                      color: mine ? Colors.white : AppColors.navy,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.time,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textMuted)),
                  if (mine) ...[
                    const SizedBox(width: 4),
                    matchIcon(Icons.done_all_rounded, 'read',
                        size: 15, color: AppColors.tealMid),
                  ],
                ],
              ),
            ],
          ),
        );
    }
  }
}

class _ConnectedStart extends StatelessWidget {
  const _ConnectedStart({
    required this.thread,
    required this.suggestions,
    required this.onPick,
  });

  final ChatThread thread;
  final List<String> suggestions;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.tealB, AppColors.tealC],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 76,
                width: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Positioned(left: 0, child: ChatAvatar(size: 70)),
                    Positioned(
                        right: 0,
                        child: ChatAvatar(size: 70, photoUrl: thread.photoUrl)),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.marigoldY,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: matchIcon(Icons.favorite_rounded, 'heart',
                            size: 15, color: AppColors.goldDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "You're connected!",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.sparkleGold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${thread.name} accepted your interest. Say hello and start getting to know each other.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              if (thread.details.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final d in thread.details)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25)),
                        ),
                        child: Text(d,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Not sure what to say? Try one',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 10),
        for (final s in suggestions) ...[
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(color: AppColors.blueTintBorder),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onPick(s),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                child: Row(
                  children: [
                    matchIcon(Icons.chat_bubble_outline_rounded, 'chat',
                        size: 17, color: AppColors.tealMid),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(s,
                          style: const TextStyle(
                              fontSize: 14, color: AppColors.navy)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.cream,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.goldBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              matchIcon(Icons.shield_outlined, 'safe',
                  size: 16, color: AppColors.goldDark),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Keep chats respectful. Don't share bank details or send money to anyone you meet here.",
                  style: TextStyle(
                      fontSize: 12.5, height: 1.4, color: AppColors.goldDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
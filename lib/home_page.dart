import 'package:flutter/material.dart';
import 'api.dart';

enum FriendsTab { online, all, addFriend }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<ActivityItem>> _activeNowFuture;
  final TextEditingController _searchController = TextEditingController();

  FriendsTab _selectedTab = FriendsTab.online;
  bool _micMuted = false;
  bool _headphonesMuted = false;

  @override
  void initState() {
    super.initState();
    _activeNowFuture = Api.fetchActiveNow();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _query => _searchController.text.trim().toLowerCase();

  void _onSearchChanged(String value) {
    setState(() {});
  }

  void _setTab(FriendsTab tab) {
    setState(() => _selectedTab = tab);
  }

  void _toggleMic() {
    setState(() => _micMuted = !_micMuted);
  }

  void _toggleHeadphones() {
    setState(() => _headphonesMuted = !_headphonesMuted);
  }

  List<FriendItem> get _visibleFriends {
    Iterable<FriendItem> items = Api.friends;

    if (_selectedTab == FriendsTab.online) {
      items = items.where((item) => item.status == Presence.online);
    }

    final q = _query;
    if (q.isNotEmpty) {
      items = items.where(
        (item) =>
            item.name.toLowerCase().contains(q) ||
            item.subtitle.toLowerCase().contains(q),
      );
    }

    return items.toList();
  }

  List<DirectMessageItem> get _visibleDirectMessages {
    final q = _query;
    if (q.isEmpty) return Api.directMessages;

    return Api.directMessages.where((item) {
      return item.name.toLowerCase().contains(q) ||
          item.subtitle.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 700) {
          return _MobileHome(
            activeNowFuture: _activeNowFuture,
            selectedTab: _selectedTab,
            onTabChanged: _setTab,
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            visibleFriends: _visibleFriends,
            visibleDirectMessages: _visibleDirectMessages,
            micMuted: _micMuted,
            headphonesMuted: _headphonesMuted,
            onToggleMic: _toggleMic,
            onToggleHeadphones: _toggleHeadphones,
          );
        }

        if (width < 1100) {
          return _TabletHome(
            activeNowFuture: _activeNowFuture,
            selectedTab: _selectedTab,
            onTabChanged: _setTab,
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            visibleFriends: _visibleFriends,
            visibleDirectMessages: _visibleDirectMessages,
            micMuted: _micMuted,
            headphonesMuted: _headphonesMuted,
            onToggleMic: _toggleMic,
            onToggleHeadphones: _toggleHeadphones,
          );
        }

        return _DesktopHome(
          activeNowFuture: _activeNowFuture,
          selectedTab: _selectedTab,
          onTabChanged: _setTab,
          searchController: _searchController,
          onSearchChanged: _onSearchChanged,
          visibleFriends: _visibleFriends,
          visibleDirectMessages: _visibleDirectMessages,
          micMuted: _micMuted,
          headphonesMuted: _headphonesMuted,
          onToggleMic: _toggleMic,
          onToggleHeadphones: _toggleHeadphones,
        );
      },
    );
  }
}

class _DesktopHome extends StatelessWidget {
  final Future<List<ActivityItem>> activeNowFuture;
  final FriendsTab selectedTab;
  final ValueChanged<FriendsTab> onTabChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<FriendItem> visibleFriends;
  final List<DirectMessageItem> visibleDirectMessages;
  final bool micMuted;
  final bool headphonesMuted;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleHeadphones;

  const _DesktopHome({
    required this.activeNowFuture,
    required this.selectedTab,
    required this.onTabChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.visibleFriends,
    required this.visibleDirectMessages,
    required this.micMuted,
    required this.headphonesMuted,
    required this.onToggleMic,
    required this.onToggleHeadphones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const _ServerRail(),
              const SizedBox(width: 12),
              _SidebarPane(
                searchController: searchController,
                onSearchChanged: onSearchChanged,
                visibleDirectMessages: visibleDirectMessages,
                micMuted: micMuted,
                headphonesMuted: headphonesMuted,
                onToggleMic: onToggleMic,
                onToggleHeadphones: onToggleHeadphones,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MainPane(
                  selectedTab: selectedTab,
                  onTabChanged: onTabChanged,
                  searchController: searchController,
                  onSearchChanged: onSearchChanged,
                  visibleFriends: visibleFriends,
                ),
              ),
              const SizedBox(width: 12),
              _ActivityPane(activeNowFuture: activeNowFuture),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabletHome extends StatelessWidget {
  final Future<List<ActivityItem>> activeNowFuture;
  final FriendsTab selectedTab;
  final ValueChanged<FriendsTab> onTabChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<FriendItem> visibleFriends;
  final List<DirectMessageItem> visibleDirectMessages;
  final bool micMuted;
  final bool headphonesMuted;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleHeadphones;

  const _TabletHome({
    required this.activeNowFuture,
    required this.selectedTab,
    required this.onTabChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.visibleFriends,
    required this.visibleDirectMessages,
    required this.micMuted,
    required this.headphonesMuted,
    required this.onToggleMic,
    required this.onToggleHeadphones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const _ServerRail(compact: true),
              const SizedBox(width: 12),
              _SidebarPane(
                searchController: searchController,
                onSearchChanged: onSearchChanged,
                visibleDirectMessages: visibleDirectMessages,
                micMuted: micMuted,
                headphonesMuted: headphonesMuted,
                onToggleMic: onToggleMic,
                onToggleHeadphones: onToggleHeadphones,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MainPane(
                  selectedTab: selectedTab,
                  onTabChanged: onTabChanged,
                  searchController: searchController,
                  onSearchChanged: onSearchChanged,
                  visibleFriends: visibleFriends,
                ),
              ),
              const SizedBox(width: 12),
              _ActivityPane(activeNowFuture: activeNowFuture),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileHome extends StatelessWidget {
  final Future<List<ActivityItem>> activeNowFuture;
  final FriendsTab selectedTab;
  final ValueChanged<FriendsTab> onTabChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<FriendItem> visibleFriends;
  final List<DirectMessageItem> visibleDirectMessages;
  final bool micMuted;
  final bool headphonesMuted;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleHeadphones;

  const _MobileHome({
    required this.activeNowFuture,
    required this.selectedTab,
    required this.onTabChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.visibleFriends,
    required this.visibleDirectMessages,
    required this.micMuted,
    required this.headphonesMuted,
    required this.onToggleMic,
    required this.onToggleHeadphones,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const _MobileTopBar(),
            const SizedBox(height: 12),
            const _MobileServersStrip(),
            const SizedBox(height: 12),
            _MobileSearchCard(
              controller: searchController,
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 12),
            _MobileSectionCard(
              height: 360,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  ...Api.sidebarItems.map((e) => _SidebarTile(item: e)),
                  const SizedBox(height: 12),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withOpacity(.3),
                  ),
                  const SizedBox(height: 12),
                  _SectionTitle(title: 'Direct Messages'),
                  const SizedBox(height: 10),
                  ...visibleDirectMessages.map(
                    (e) => _DirectMessageTile(item: e),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _MobileSectionCard(
              height: 560,
              child: Column(
                children: [
                  _TopTabsBar(
                    mobile: true,
                    selectedTab: selectedTab,
                    onTabChanged: onTabChanged,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: _SearchField(
                      controller: searchController,
                      hintText: 'Search',
                      onChanged: onSearchChanged,
                    ),
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: _buildMobileFriendsBody(
                        context: context,
                        tab: selectedTab,
                        friends: visibleFriends,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _MobileSectionCard(
              height: 430,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _BottomUserBar(
                  micMuted: micMuted,
                  headphonesMuted: headphonesMuted,
                  onToggleMic: onToggleMic,
                  onToggleHeadphones: onToggleHeadphones,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _MobileSectionCard(
              height: 430,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _ActivityPane(activeNowFuture: activeNowFuture),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileFriendsBody({
    required BuildContext context,
    required FriendsTab tab,
    required List<FriendItem> friends,
  }) {
    if (tab == FriendsTab.addFriend) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: _AddFriendPanel(onTap: () {}),
      );
    }

    return ListView.separated(
      key: ValueKey(tab),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      itemCount: friends.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: Theme.of(context).colorScheme.outlineVariant.withOpacity(.18),
      ),
      itemBuilder: (context, index) => _FriendTile(item: friends[index]),
    );
  }
}

class _MobileSectionCard extends StatelessWidget {
  final double height;
  final Widget child;

  const _MobileSectionCard({required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1A140F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: child,
    );
  }
}

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(.22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withOpacity(.35)),
      ),
      child: Row(
        children: [
          _ClickableAvatar(
            url: 'https://i.pravatar.cc/150?img=23',
            size: 34,
            onTap: () {},
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Friends',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          _HoverIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _HoverIconButton(icon: Icons.settings_outlined, onTap: () {}),
        ],
      ),
    );
  }
}

class _MobileServersStrip extends StatelessWidget {
  const _MobileServersStrip();

  @override
  Widget build(BuildContext context) {
    final servers = Api.serverRail.where((s) => !s.isHome).toList();
    return SizedBox(
      height: 74,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: servers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) =>
            _ServerTile(server: servers[index], compact: true),
      ),
    );
  }
}

class _MobileSearchCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _MobileSearchCard({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A140F),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withOpacity(.18)),
      ),
      child: _SearchField(
        controller: controller,
        hintText: 'Find or start a conversation',
        onChanged: onChanged,
      ),
    );
  }
}

class _ServerRail extends StatelessWidget {
  final bool compact;
  const _ServerRail({this.compact = false});

  @override
  Widget build(BuildContext context) {
    final railWidth = compact ? 66.0 : 78.0;

    return Container(
      width: railWidth,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF17120D),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: Column(
        children: [
          _RoundActionIcon(
            icon: Icons.nights_stay_rounded,
            selected: true,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: Api.serverRail.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return _ServerTile(
                  server: Api.serverRail[index],
                  compact: compact,
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          _RoundActionIcon(icon: Icons.explore_rounded, onTap: () {}),
          const SizedBox(height: 10),
          _RoundActionIcon(icon: Icons.add_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _ServerTile extends StatelessWidget {
  final ServerItem server;
  final bool compact;

  const _ServerTile({required this.server, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final size = compact ? 48.0 : 50.0;

    return _HoverPressSurface(
      borderRadius: BorderRadius.circular(size / 2),
      onTap: () {},
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              border: Border.all(
                color: server.selected
                    ? const Color(0xFFD7B46A)
                    : Colors.white.withOpacity(.05),
                width: server.selected ? 2 : 1,
              ),
              boxShadow: server.selected
                  ? [
                      BoxShadow(
                        color: const Color(0xFFD7B46A).withOpacity(.18),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size / 2),
              child: Image.network(
                server.avatarUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    width: size,
                    height: size,
                    color: const Color(0xFF2A2118),
                    alignment: Alignment.center,
                    child: const Icon(Icons.discord_rounded),
                  );
                },
              ),
            ),
          ),
          if (server.unreadCount != null)
            Positioned(
              right: -4,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A65),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFF17120D), width: 2),
                ),
                child: Text(
                  '${server.unreadCount}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SidebarPane extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<DirectMessageItem> visibleDirectMessages;
  final bool micMuted;
  final bool headphonesMuted;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleHeadphones;

  const _SidebarPane({
    required this.searchController,
    required this.onSearchChanged,
    required this.visibleDirectMessages,
    required this.micMuted,
    required this.headphonesMuted,
    required this.onToggleMic,
    required this.onToggleHeadphones,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: SidebarCard(
        searchController: searchController,
        onSearchChanged: onSearchChanged,
        visibleDirectMessages: visibleDirectMessages,
        micMuted: micMuted,
        headphonesMuted: headphonesMuted,
        onToggleMic: onToggleMic,
        onToggleHeadphones: onToggleHeadphones,
      ),
    );
  }
}

class SidebarCard extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<DirectMessageItem> visibleDirectMessages;
  final bool micMuted;
  final bool headphonesMuted;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleHeadphones;

  const SidebarCard({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.visibleDirectMessages,
    required this.micMuted,
    required this.headphonesMuted,
    required this.onToggleMic,
    required this.onToggleHeadphones,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A140F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _SearchField(
              controller: searchController,
              hintText: 'Find or start a conversation',
              onChanged: onSearchChanged,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ...Api.sidebarItems.map((e) => _SidebarTile(item: e)),
                const SizedBox(height: 12),
                Divider(color: scheme.outlineVariant.withOpacity(.3)),
                const SizedBox(height: 12),
                _SectionTitle(title: 'Direct Messages'),
                const SizedBox(height: 10),
                ...visibleDirectMessages.map(
                  (e) => _DirectMessageTile(item: e),
                ),
              ],
            ),
          ),
          _BottomUserBar(
            micMuted: micMuted,
            headphonesMuted: headphonesMuted,
            onToggleMic: onToggleMic,
            onToggleHeadphones: onToggleHeadphones,
          ),
        ],
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {
  final SidebarItem item;
  const _SidebarTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _HoverPressSurface(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      hoverColor: scheme.surfaceContainerHighest.withOpacity(.26),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: item.selected
              ? scheme.surfaceContainerHighest.withOpacity(.32)
              : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20,
              color: item.selected ? scheme.primary : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontWeight: item.selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            if (item.badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD7B46A),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.badge!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A140F),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DirectMessageTile extends StatelessWidget {
  final DirectMessageItem item;
  const _DirectMessageTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusColor = _presenceColor(item.status);

    return _HoverPressSurface(
      borderRadius: BorderRadius.circular(14),
      onTap: () {},
      hoverColor: scheme.surfaceContainerHighest.withOpacity(.24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: item.name == 'марьяна.'
              ? scheme.surfaceContainerHighest.withOpacity(.22)
              : null,
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _ClickableAvatar(url: item.avatarUrl, size: 36, onTap: () {}),
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1A140F),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: item.name == 'марьяна.'
                          ? FontWeight.w700
                          : FontWeight.w500,
                      fontSize: 13.5,
                    ),
                  ),
                  if (item.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.group)
              Icon(
                Icons.group_rounded,
                size: 17,
                color: scheme.onSurfaceVariant,
              ),
            if (item.name == 'FTP') ...[
              const SizedBox(width: 4),
              Icon(
                Icons.do_not_disturb_on_rounded,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MainPane extends StatelessWidget {
  final FriendsTab selectedTab;
  final ValueChanged<FriendsTab> onTabChanged;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final List<FriendItem> visibleFriends;

  const _MainPane({
    required this.selectedTab,
    required this.onTabChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.visibleFriends,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A140F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TopTabsBar(selectedTab: selectedTab, onTabChanged: onTabChanged),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _SearchField(
              controller: searchController,
              hintText: 'Search',
              onChanged: onSearchChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              selectedTab == FriendsTab.online
                  ? 'Online — ${visibleFriends.length}'
                  : selectedTab == FriendsTab.all
                  ? 'All — ${visibleFriends.length}'
                  : 'Add Friend',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: _buildFriendsBody(
                context: context,
                scheme: scheme,
                tab: selectedTab,
                friends: visibleFriends,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsBody({
    required BuildContext context,
    required ColorScheme scheme,
    required FriendsTab tab,
    required List<FriendItem> friends,
  }) {
    if (tab == FriendsTab.addFriend) {
      return _AddFriendPanel(key: const ValueKey('add_friend'), onTap: () {});
    }

    return ListView.separated(
      key: ValueKey(tab),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      itemCount: friends.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: scheme.outlineVariant.withOpacity(.18)),
      itemBuilder: (context, index) => _FriendTile(item: friends[index]),
    );
  }
}

class _TopTabsBar extends StatelessWidget {
  final bool mobile;
  final FriendsTab selectedTab;
  final ValueChanged<FriendsTab> onTabChanged;

  const _TopTabsBar({
    required this.selectedTab,
    required this.onTabChanged,
    this.mobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: mobile ? 58 : 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF17120D),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(.06)),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.people_alt_rounded, size: 20),
          const SizedBox(width: 8),
          const Text('Friends', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 10),
          _TabPill(
            label: 'Online',
            selected: selectedTab == FriendsTab.online,
            onTap: () => onTabChanged(FriendsTab.online),
          ),
          const SizedBox(width: 8),
          _TabPill(
            label: 'All',
            selected: selectedTab == FriendsTab.all,
            onTap: () => onTabChanged(FriendsTab.all),
          ),
          const Spacer(),
          if (!mobile) ...[
            _TabPill(
              label: 'Add Friend',
              selected: selectedTab == FriendsTab.addFriend,
              onTap: () => onTabChanged(FriendsTab.addFriend),
            ),
            const SizedBox(width: 8),
            _HoverIconButton(
              icon: Icons.person_add_alt_1_rounded,
              onTap: () {},
              fillColor: scheme.surfaceContainerHighest.withOpacity(.28),
            ),
            const SizedBox(width: 10),
            _HoverIconButton(
              icon: Icons.inbox_rounded,
              onTap: () {},
              fillColor: scheme.surfaceContainerHighest.withOpacity(.28),
            ),
            const SizedBox(width: 10),
            _HoverIconButton(
              icon: Icons.emoji_emotions_outlined,
              onTap: () {},
              fillColor: scheme.surfaceContainerHighest.withOpacity(.28),
            ),
          ] else ...[
            const SizedBox(width: 8),
            _TabPill(
              label: 'Add Friend',
              selected: selectedTab == FriendsTab.addFriend,
              onTap: () => onTabChanged(FriendsTab.addFriend),
            ),
          ],
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFD7B46A) : Colors.transparent;
    final fg = selected
        ? const Color(0xFF1A140F)
        : Theme.of(context).colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        hoverColor: Colors.white.withOpacity(.08),
        splashColor: Colors.white.withOpacity(.12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withOpacity(selected ? 0.0 : .08),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _FriendTile extends StatelessWidget {
  final FriendItem item;
  const _FriendTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final statusColor = _presenceColor(item.status);

    return _HoverPressSurface(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      hoverColor: scheme.surfaceContainerHighest.withOpacity(.22),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _ClickableAvatar(url: item.avatarUrl, size: 42, onTap: () {}),
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1A140F),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            _HoverIconButton(
              icon: Icons.chat_bubble_outline_rounded,
              onTap: () {},
            ),
            const SizedBox(width: 18),
            _HoverIconButton(icon: Icons.more_vert_rounded, onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _ActivityPane extends StatelessWidget {
  final Future<List<ActivityItem>> activeNowFuture;

  const _ActivityPane({required this.activeNowFuture});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A140F),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(.06)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                'Active Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<ActivityItem>>(
                future: activeNowFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Ошибка загрузки',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  final items = snapshot.data ?? const <ActivityItem>[];
                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        'Нет активностей',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _ActivityCard(item: items[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final ActivityItem item;
  const _ActivityCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return _HoverPressSurface(
      borderRadius: BorderRadius.circular(18),
      onTap: () {},
      hoverColor: scheme.surfaceContainerHighest.withOpacity(.20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacity(.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outlineVariant.withOpacity(.18)),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
              leading: _ClickableAvatar(
                url: item.avatarUrl,
                size: 44,
                onTap: () {},
              ),
              title: Text(
                item.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('${item.game} — ${item.time}'),
              trailing: PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: scheme.onSurfaceVariant,
                ),
                tooltip: 'Menu',
                onSelected: (_) {},
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'profile', child: Text('Open profile')),
                  PopupMenuItem(value: 'message', child: Text('Message')),
                  PopupMenuItem(
                    value: 'mute',
                    child: Text('Mute notifications'),
                  ),
                  PopupMenuItem(value: 'hide', child: Text('Hide activity')),
                ],
              ),
            ),
            Divider(height: 1, color: scheme.outlineVariant.withOpacity(.18)),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              leading: _AppSquareBadge(imageUrl: item.gameBadge),
              title: Text(
                item.game,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              subtitle: const Text('1 Person', style: TextStyle(fontSize: 12)),
              trailing: _ClickableAvatar(
                url: item.avatarUrl,
                size: 26,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppSquareBadge extends StatelessWidget {
  final String imageUrl;

  const _AppSquareBadge({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: SizedBox(
        width: 32,
        height: 32,
        child: imageUrl.isEmpty
            ? Container(
                color: const Color(0xFF3A2E20),
                child: const Icon(Icons.sports_esports, size: 18),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: const Color(0xFF3A2E20),
                    child: const Icon(Icons.sports_esports, size: 18),
                  );
                },
              ),
      ),
    );
  }
}

class _BottomUserBar extends StatelessWidget {
  final bool micMuted;
  final bool headphonesMuted;
  final VoidCallback onToggleMic;
  final VoidCallback onToggleHeadphones;

  const _BottomUserBar({
    required this.micMuted,
    required this.headphonesMuted,
    required this.onToggleMic,
    required this.onToggleHeadphones,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withOpacity(.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant.withOpacity(.18)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _HoverPressSurface(
              borderRadius: BorderRadius.circular(14),
              onTap: () {},
              hoverColor: scheme.surfaceContainerHighest.withOpacity(.30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    _ClickableAvatar(
                      url: 'https://i.pravatar.cc/150?img=23',
                      size: 34,
                      onTap: () {},
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'me',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text('gooning', style: TextStyle(fontSize: 11.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _HoverIconButton(
            icon: micMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            onTap: onToggleMic,
          ),
          const SizedBox(width: 12),
          _HoverIconButton(
            icon: headphonesMuted
                ? Icons.headset_off_rounded
                : Icons.headphones_rounded,
            onTap: onToggleHeadphones,
          ),
          const SizedBox(width: 12),
          _HoverIconButton(icon: Icons.settings_rounded, onTap: () {}),
        ],
      ),
    );
  }
}

class _RoundActionIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoundActionIcon({
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? const Color(0xFF1A140F) : scheme.onSurfaceVariant;
    final bg = selected
        ? const Color(0xFFD7B46A)
        : scheme.surfaceContainerHighest.withOpacity(.22);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: selected
            ? const Color(0xFFD7B46A).withOpacity(.18)
            : scheme.surfaceContainerHighest.withOpacity(.34),
        splashColor: Colors.white.withOpacity(.12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: fg),
        ),
      ),
    );
  }
}

class _HoverIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? fillColor;

  const _HoverIconButton({
    required this.icon,
    required this.onTap,
    this.fillColor,
  });

  @override
  State<_HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<_HoverIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill =
        widget.fillColor ?? scheme.surfaceContainerHighest.withOpacity(.34);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          customBorder: const CircleBorder(),
          hoverColor: fill,
          splashColor: Colors.white.withOpacity(.12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _hovered ? fill : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: scheme.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

class _HoverPressSurface extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final Color? hoverColor;

  const _HoverPressSurface({
    required this.child,
    required this.onTap,
    required this.borderRadius,
    this.hoverColor,
  });

  @override
  State<_HoverPressSurface> createState() => _HoverPressSurfaceState();
}

class _HoverPressSurfaceState extends State<_HoverPressSurface> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fill =
        widget.hoverColor ?? scheme.surfaceContainerHighest.withOpacity(.22);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: widget.borderRadius,
          hoverColor: fill,
          splashColor: Colors.white.withOpacity(.12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: _hovered ? fill : Colors.transparent,
              borderRadius: widget.borderRadius,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _ClickableAvatar extends StatelessWidget {
  final String url;
  final double size;
  final VoidCallback onTap;

  const _ClickableAvatar({
    required this.url,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _HoverPressSurface(
      borderRadius: BorderRadius.circular(size / 2),
      onTap: onTap,
      hoverColor: Colors.white.withOpacity(.08),
      child: ClipOval(
        child: Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: size,
              height: size,
              color: const Color(0xFF2A2118),
              alignment: Alignment.center,
              child: const Icon(Icons.person_rounded),
            );
          },
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withOpacity(.18),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outlineVariant.withOpacity(.22)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: scheme.primary.withOpacity(.55),
            width: 1.3,
          ),
        ),
      ),
    );
  }
}

class _AddFriendPanel extends StatelessWidget {
  final VoidCallback onTap;

  const _AddFriendPanel({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: _HoverPressSurface(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        hoverColor: scheme.surfaceContainerHighest.withOpacity(.28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest.withOpacity(.14),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: scheme.outlineVariant.withOpacity(.18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_add_alt_1_rounded,
                size: 38,
                color: scheme.primary,
              ),
              const SizedBox(height: 12),
              const Text(
                'Add Friend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Кнопка кликабельна и анимирована, но без функционала.',
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

Color _presenceColor(Presence status) {
  switch (status) {
    case Presence.online:
      return const Color(0xFF3BA55D);
    case Presence.idle:
      return const Color(0xFFF0B232);
    case Presence.dnd:
      return const Color(0xFFF04747);
    case Presence.offline:
      return const Color(0xFF5B5B5B);
  }
}

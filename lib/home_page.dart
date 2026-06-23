import 'package:flutter/material.dart';
import 'api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<List<ActivityItem>> _activeNowFuture;

  @override
  void initState() {
    super.initState();
    _activeNowFuture = Api.fetchActiveNow();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 700) {
          return _MobileHome(activeNowFuture: _activeNowFuture);
        }

        if (width < 1100) {
          return _TabletHome(activeNowFuture: _activeNowFuture);
        }

        return _DesktopHome(activeNowFuture: _activeNowFuture);
      },
    );
  }
}

class _DesktopHome extends StatelessWidget {
  final Future<List<ActivityItem>> activeNowFuture;

  const _DesktopHome({required this.activeNowFuture});

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
              const _SidebarPane(),
              const SizedBox(width: 12),
              const Expanded(child: _MainPane()),
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

  const _TabletHome({required this.activeNowFuture});

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
              const _SidebarPane(),
              const SizedBox(width: 12),
              const Expanded(child: _MainPane()),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileHome extends StatelessWidget {
  final Future<List<ActivityItem>> activeNowFuture;

  const _MobileHome({required this.activeNowFuture});

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
            const _MobileSearchCard(),
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
                  const _SectionTitle(title: 'Direct Messages'),
                  const SizedBox(height: 10),
                  ...Api.directMessages.map((e) => _DirectMessageTile(item: e)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _MobileSectionCard(
              height: 560,
              child: Column(
                children: [
                  const _TopTabsBar(mobile: true),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest.withOpacity(.22),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outlineVariant.withOpacity(.22),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search_rounded, size: 22),
                          SizedBox(width: 10),
                          Text('Search', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Online — ${Api.friends.length}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      itemCount: Api.friends.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: Theme.of(
                          context,
                        ).colorScheme.outlineVariant.withOpacity(.18),
                      ),
                      itemBuilder: (context, index) {
                        return _FriendTile(item: Api.friends[index]);
                      },
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        'Active Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder<List<ActivityItem>>(
                        future: activeNowFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Ошибка загрузки',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
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
            ),
            const SizedBox(height: 12),
            const _BottomUserBar(),
          ],
        ),
      ),
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
          const _Avatar(url: 'https://i.pravatar.cc/150?img=23', size: 34),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Friends',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          Icon(
            Icons.notifications_none_rounded,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Icon(Icons.settings_outlined, color: scheme.onSurfaceVariant),
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
  const _MobileSearchCard();

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
      child: const Row(
        children: [
          Icon(Icons.search_rounded, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Find or start a conversation',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
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
          const _RoundActionIcon(
            icon: Icons.nights_stay_rounded,
            selected: true,
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
          const _RoundActionIcon(icon: Icons.explore_rounded),
          const SizedBox(height: 10),
          const _RoundActionIcon(icon: Icons.add_rounded),
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

    return Stack(
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
            child: _Avatar(url: server.avatarUrl, size: size),
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
    );
  }
}

class _SidebarPane extends StatelessWidget {
  const _SidebarPane();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 260, child: SidebarCard());
  }
}

class SidebarCard extends StatelessWidget {
  const SidebarCard({super.key});

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
          const _SidebarSearch(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ...Api.sidebarItems.map((e) => _SidebarTile(item: e)),
                const SizedBox(height: 12),
                Divider(color: scheme.outlineVariant.withOpacity(.3)),
                const SizedBox(height: 12),
                const _SectionTitle(title: 'Direct Messages'),
                const SizedBox(height: 10),
                ...Api.directMessages.map((e) => _DirectMessageTile(item: e)),
              ],
            ),
          ),
          const _BottomUserBar(),
        ],
      ),
    );
  }
}

class _SidebarSearch extends StatelessWidget {
  const _SidebarSearch();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withOpacity(.22),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outlineVariant.withOpacity(.28)),
        ),
        child: const Row(
          children: [
            Icon(Icons.search_rounded, size: 22),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Find or start a conversation',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
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

    return Container(
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

    return Container(
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
              _Avatar(url: item.avatarUrl, size: 36),
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
            Icon(Icons.group_rounded, size: 17, color: scheme.onSurfaceVariant),
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
    );
  }
}

class _MainPane extends StatelessWidget {
  const _MainPane();

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
          const _TopTabsBar(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withOpacity(.22),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: scheme.outlineVariant.withOpacity(.22),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, size: 22),
                  SizedBox(width: 10),
                  Text('Search', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              'Online — ${Api.friends.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: Api.friends.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: scheme.outlineVariant.withOpacity(.18),
              ),
              itemBuilder: (context, index) =>
                  _FriendTile(item: Api.friends[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopTabsBar extends StatelessWidget {
  final bool mobile;
  const _TopTabsBar({this.mobile = false});

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
          const _Pill(label: 'Online', selected: true),
          const SizedBox(width: 8),
          const _Pill(label: 'All'),
          const Spacer(),
          if (!mobile) ...[
            const _Pill(label: 'Add Friend', selected: true),
            const SizedBox(width: 8),
            Icon(
              Icons.person_add_alt_1_rounded,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Icon(Icons.inbox_rounded, color: scheme.onSurfaceVariant),
            const SizedBox(width: 10),
            Icon(Icons.emoji_emotions_outlined, color: scheme.onSurfaceVariant),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final bool selected;
  const _Pill({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFFD7B46A) : Colors.transparent;
    final fg = selected
        ? const Color(0xFF1A140F)
        : Theme.of(context).colorScheme.onSurface;

    return Container(
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              _Avatar(url: item.avatarUrl, size: 42),
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
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 18),
          Icon(Icons.more_vert_rounded, color: scheme.onSurfaceVariant),
        ],
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

    return Container(
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
            leading: _Avatar(url: item.avatarUrl, size: 44),
            title: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Text('${item.game} — ${item.time}'),
            trailing: _GameBadge(imageUrl: item.gameBadge),
          ),
          Divider(height: 1, color: scheme.outlineVariant.withOpacity(.18)),
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            leading: _AppSquareBadge(imageUrl: item.gameBadge),
            title: Text(
              item.game,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            subtitle: const Text('1 Person', style: TextStyle(fontSize: 12)),
            trailing: _Avatar(url: item.avatarUrl, size: 26),
          ),
        ],
      ),
    );
  }
}

class _GameBadge extends StatelessWidget {
  final String imageUrl;

  const _GameBadge({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: 32,
        height: 32,
        child: imageUrl.isEmpty
            ? Container(
                color: const Color(0xFF2496FF),
                child: const Icon(
                  Icons.sports_esports,
                  size: 18,
                  color: Colors.white,
                ),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    color: const Color(0xFF2496FF),
                    child: const Icon(
                      Icons.sports_esports,
                      size: 18,
                      color: Colors.white,
                    ),
                  );
                },
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
  const _BottomUserBar();

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
          const _Avatar(url: 'https://i.pravatar.cc/150?img=23', size: 34),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'me',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 2),
                Text('gooning', style: TextStyle(fontSize: 11.5)),
              ],
            ),
          ),
          Icon(Icons.mic_off_rounded, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Icon(Icons.headphones_rounded, color: scheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Icon(Icons.settings_rounded, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _RoundActionIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  const _RoundActionIcon({required this.icon, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFFD7B46A)
            : scheme.surfaceContainerHighest.withOpacity(.22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: selected ? const Color(0xFF1A140F) : scheme.onSurfaceVariant,
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

class _Avatar extends StatelessWidget {
  final String url;
  final double size;

  const _Avatar({required this.url, required this.size});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
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

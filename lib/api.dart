import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  static const serverRail = <ServerItem>[
    ServerItem(
      id: 'home',
      name: 'Home',
      avatarUrl: 'https://i.pravatar.cc/120?img=11',
      selected: true,
      isHome: true,
    ),
    ServerItem(
      id: '1',
      name: 'SC:G',
      avatarUrl: 'https://i.pravatar.cc/120?img=12',
      unreadCount: 46,
    ),
    ServerItem(
      id: '2',
      name: 'Art',
      avatarUrl: 'https://i.pravatar.cc/120?img=13',
    ),
    ServerItem(
      id: '3',
      name: 'Music',
      avatarUrl: 'https://i.pravatar.cc/120?img=14',
    ),
    ServerItem(
      id: '4',
      name: 'Games',
      avatarUrl: 'https://i.pravatar.cc/120?img=15',
    ),
    ServerItem(
      id: '5',
      name: 'Chat',
      avatarUrl: 'https://i.pravatar.cc/120?img=16',
    ),
    ServerItem(
      id: '6',
      name: 'Photos',
      avatarUrl: 'https://i.pravatar.cc/120?img=17',
    ),
    ServerItem(
      id: '7',
      name: 'Code',
      avatarUrl: 'https://i.pravatar.cc/120?img=18',
    ),
  ];

  static const sidebarItems = <SidebarItem>[
    SidebarItem(label: 'Friends', icon: Icons.people_rounded, selected: true),
    SidebarItem(label: 'Nitro', icon: Icons.bolt_rounded, badge: 'NEW'),
    SidebarItem(label: 'Shop', icon: Icons.storefront_rounded, badge: 'NEW'),
    SidebarItem(label: 'Quests', icon: Icons.emoji_events_outlined),
  ];

  static const directMessages = <DirectMessageItem>[
    DirectMessageItem(
      name: '123',
      subtitle: 'Do Not Disturb',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.dnd,
    ),
    DirectMessageItem(
      name: '123',
      subtitle: '',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.offline,
    ),
    DirectMessageItem(
      name: '123',
      subtitle: '',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.idle,
    ),
    DirectMessageItem(
      name: '123',
      subtitle: '',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.online,
    ),
    DirectMessageItem(
      name: '123',
      subtitle: 'грэызт писюльки',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.online,
    ),
    DirectMessageItem(
      name: '123',
      subtitle: '7 Members',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.offline,
      group: true,
    ),
  ];

  static const friends = <FriendItem>[
    FriendItem(
      name: 'Nexor',
      subtitle: 'Online',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.online,
    ),
    FriendItem(
      name: 'void.exe',
      subtitle: '🎮 Counter-Strike 2',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.online,
    ),
    FriendItem(
      name: 'Mori',
      subtitle: 'Idle',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.idle,
    ),
    FriendItem(
      name: 'astral',
      subtitle: '🌙 sleeping',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.idle,
    ),
    FriendItem(
      name: 'xKarma',
      subtitle: 'Do Not Disturb',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.dnd,
    ),
    FriendItem(
      name: 'PixelCat',
      subtitle: '🎨 Drawing',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.online,
    ),
    FriendItem(
      name: 'Vortex',
      subtitle: 'Offline',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.offline,
    ),
    FriendItem(
      name: 'Mizuki',
      subtitle: '🎵 Spotify',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.online,
    ),
    FriendItem(
      name: 'cyberfox',
      subtitle: '🛠️ Coding',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.dnd,
    ),
    FriendItem(
      name: 'Kitsune',
      subtitle: 'Online',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.online,
    ),
    FriendItem(
      name: 'starlight',
      subtitle: '✨ vibing',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.idle,
    ),
    FriendItem(
      name: 'Raven',
      subtitle: '🎮 Minecraft',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.online,
    ),
    FriendItem(
      name: '0xDEAD',
      subtitle: 'Compiling...',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.dnd,
    ),
    FriendItem(
      name: 'Lumi',
      subtitle: 'Offline',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.offline,
    ),
    FriendItem(
      name: 'Echo',
      subtitle: '🎮 Valorant',
      avatarUrl: 'https://picsum.photos/200',
      status: Presence.online,
    ),
  ];

  static const user = UserItem(
    name: 'me',
    subtitle: 'gooning',
    avatarUrl: 'https://picsum.photos/200',
  );

  static Future<List<ActivityItem>> fetchActiveNow() async {
    final baseItems = <ActivityItem>[
      const ActivityItem(
        name: 'test',
        game: "Garry's Mod",
        time: '2h',
        avatarUrl: 'https://picsum.photos/200',
        gameBadge: '',
      ),
      const ActivityItem(
        name: 'test',
        game: 'Dota 2',
        time: '1h',
        avatarUrl: 'https://picsum.photos/200',
        gameBadge: '',
      ),
    ];

    final result = <ActivityItem>[];

    for (final item in baseItems) {
      final badgeUrl = await _getGameBadgeUrl(item.game);
      result.add(
        ActivityItem(
          name: item.name,
          game: item.game,
          time: item.time,
          avatarUrl: item.avatarUrl,
          gameBadge: badgeUrl ?? '',
        ),
      );
    }

    return result;
  }

  static Future<String?> _getGameBadgeUrl(String gameName) async {
    final bucketSlug = _bucketSlug(gameName);
    final bucketUrl = Uri.parse(
      'https://app.lizardbyte.dev/GameDB/buckets/$bucketSlug.json',
    );

    final bucketJson = await _getJson(bucketUrl);
    if (bucketJson == null || bucketJson.isEmpty) {
      return null;
    }

    final target = _normalize(gameName);
    String? foundGameId;

    for (final entry in bucketJson.entries) {
      final value = entry.value;
      if (value is! Map) continue;

      final name = value['name']?.toString();
      if (name == null || name.isEmpty) continue;

      if (_isExactTitleMatch(name, gameName, target)) {
        foundGameId = entry.key;
        break;
      }
    }

    if (foundGameId == null) {
      return null;
    }

    final gameUrl = Uri.parse(
      'https://app.lizardbyte.dev/GameDB/games/$foundGameId.json',
    );

    final gameJson = await _getJson(gameUrl);
    if (gameJson == null || gameJson.isEmpty) {
      return null;
    }

    return _extractImageUrl(gameJson);
  }

  static bool _isExactTitleMatch(
    String bucketName,
    String gameName,
    String normalizedTarget,
  ) {
    final a = bucketName.trim().toLowerCase();
    final b = gameName.trim().toLowerCase();

    if (a == b) return true;

    final normalizedName = _normalize(bucketName);
    return normalizedName == normalizedTarget;
  }

  static Future<Map<String, dynamic>?> _getJson(Uri url) async {
    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static String? _extractImageUrl(Map<String, dynamic> gameJson) {
    final cover = gameJson['cover'];
    if (cover is Map) {
      final coverUrl = cover['url']?.toString();
      if (coverUrl != null && coverUrl.isNotEmpty) {
        return _fixImageUrl(coverUrl);
      }
    }

    final artworks = gameJson['artworks'];
    if (artworks is List) {
      for (final item in artworks) {
        if (item is Map) {
          final url = item['url']?.toString();
          if (url != null && url.isNotEmpty) {
            return _fixImageUrl(url);
          }
        }
      }
    }

    final screenshots = gameJson['screenshots'];
    if (screenshots is List) {
      for (final item in screenshots) {
        if (item is Map) {
          final url = item['url']?.toString();
          if (url != null && url.isNotEmpty) {
            return _fixImageUrl(url);
          }
        }
      }
    }

    final videos = gameJson['videos'];
    if (videos is List) {
      for (final item in videos) {
        if (item is Map) {
          final thumb = item['thumb']?.toString();
          if (thumb != null && thumb.isNotEmpty) {
            return _fixImageUrl(thumb);
          }
        }
      }
    }

    return null;
  }

  static String _fixImageUrl(String url) {
    if (url.startsWith('//')) {
      return 'https:$url';
    }
    return url;
  }

  static String _normalize(String input) {
    return input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  static String _bucketSlug(String gameName) {
    final letters = gameName.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (letters.isEmpty) return 'aa';
    if (letters.length >= 2) return letters.substring(0, 2);
    return '${letters[0]}${letters[0]}';
  }
}

enum Presence { online, idle, dnd, offline }

class ServerItem {
  final String id;
  final String name;
  final String avatarUrl;
  final int? unreadCount;
  final bool selected;
  final bool isHome;

  const ServerItem({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.unreadCount,
    this.selected = false,
    this.isHome = false,
  });
}

class SidebarItem {
  final String label;
  final IconData icon;
  final bool selected;
  final String? badge;

  const SidebarItem({
    required this.label,
    required this.icon,
    this.selected = false,
    this.badge,
  });
}

class DirectMessageItem {
  final String name;
  final String subtitle;
  final String avatarUrl;
  final Presence status;
  final bool group;

  const DirectMessageItem({
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    required this.status,
    this.group = false,
  });
}

class FriendItem {
  final String name;
  final String subtitle;
  final String avatarUrl;
  final Presence status;

  const FriendItem({
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
    required this.status,
  });
}

class ActivityItem {
  final String name;
  final String game;
  final String time;
  final String avatarUrl;
  final String gameBadge;

  const ActivityItem({
    required this.name,
    required this.game,
    required this.time,
    required this.avatarUrl,
    required this.gameBadge,
  });
}

class UserItem {
  final String name;
  final String subtitle;
  final String avatarUrl;

  const UserItem({
    required this.name,
    required this.subtitle,
    required this.avatarUrl,
  });
}

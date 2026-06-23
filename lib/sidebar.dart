import 'package:flutter/material.dart';
import 'api.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  State<SidebarPage> createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  final SidebarApi _api = SidebarApi();
  late final Future<List<SidebarServer>> _serversFuture;

  String _selectedId = 'dm';

  @override
  void initState() {
    super.initState();
    _serversFuture = _api.loadServers();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 88,
              decoration: BoxDecoration(
                color: scheme.surface,
                border: Border(
                  right: BorderSide(
                    color: scheme.outlineVariant.withOpacity(0.35),
                  ),
                ),
              ),
              child: FutureBuilder<List<SidebarServer>>(
                future: _serversFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Icon(Icons.error_outline_rounded),
                    );
                  }

                  final servers = snapshot.data ?? const <SidebarServer>[];

                  return Column(
                    children: [
                      const SizedBox(height: 12),

                      _CircleButton(
                        tooltip: 'DM',
                        selected: _selectedId == 'dm',
                        icon: Icons.forum_rounded,
                        onTap: () => setState(() => _selectedId = 'dm'),
                      ),

                      const SizedBox(height: 14),
                      SizedBox(
                        width: 32,
                        child: Divider(
                          thickness: 1,
                          height: 1,
                          color: scheme.outlineVariant.withOpacity(0.55),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          itemCount: servers.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final server = servers[index];
                            return _CircleButton(
                              tooltip: server.name,
                              selected: _selectedId == server.id,
                              imageUrl: server.avatarUrl,
                              onTap: () =>
                                  setState(() => _selectedId = server.id),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 8),

                      _CircleButton(
                        tooltip: 'search',
                        icon: Icons.search_rounded,
                        onTap: () {},
                      ),

                      const SizedBox(height: 10),

                      _CircleButton(
                        tooltip: 'create',
                        icon: Icons.add_rounded,
                        onTap: () {},
                      ),

                      const SizedBox(height: 14),
                    ],
                  );
                },
              ),
            ),
            const Expanded(child: SizedBox.expand()),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final String tooltip;
  final VoidCallback onTap;
  final bool selected;
  final IconData? icon;
  final String? imageUrl;

  const _CircleButton({
    super.key,
    required this.tooltip,
    required this.onTap,
    this.selected = false,
    this.icon,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final bg = selected
        ? scheme.primary
        : scheme.surfaceContainerHighest.withOpacity(0.55);

    final fg = selected ? scheme.onPrimary : scheme.onSurface;

    return Tooltip(
      message: tooltip,
      child: Center(
        child: SizedBox(
          width: 56,
          height: 56,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bg,
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: scheme.primary.withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: imageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            imageUrl!,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.cloud_off_rounded,
                                color: fg,
                                size: 26,
                              );
                            },
                          ),
                        )
                      : Icon(icon, size: 28, color: fg),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/providers/role_provider.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();

    Future.microtask(() => context.read<RoleProvider>().getAllRoles());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoleProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // Background glow circles
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFB8960C).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFB8960C).withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 20, 20, 0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF13131A),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFF22222E), width: 1),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Color(0xFF9B9BAB),
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Text(
                            'Roles',
                            style: TextStyle(
                              color: Color(0xFFF5F0E8),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          // Refresh button
                          GestureDetector(
                            onTap: provider.getAllRoles,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF13131A),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFF22222E), width: 1),
                              ),
                              child: const Icon(
                                Icons.refresh_rounded,
                                color: Color(0xFFB8960C),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Page heading
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gestión de\nroles.',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF5F0E8),
                              height: 1.15,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (!provider.isLoading && provider.error == null)
                            Text(
                              '${provider.roles.length} ${provider.roles.length == 1 ? "rol configurado" : "roles configurados"}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B6B7B),
                                letterSpacing: 0.2,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Body
                    Expanded(
                      child: provider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFB8960C),
                                strokeWidth: 2,
                              ),
                            )
                          : provider.error != null
                              ? _ErrorState(
                                  error: provider.error!,
                                  onRetry: provider.getAllRoles,
                                )
                              : provider.roles.isEmpty
                                  ? const _EmptyState()
                                  : RefreshIndicator(
                                      onRefresh: provider.getAllRoles,
                                      color: const Color(0xFFB8960C),
                                      backgroundColor: const Color(0xFF13131A),
                                      child: ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 40),
                                        itemCount: provider.roles.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 10),
                                        itemBuilder: (_, i) {
                                          final role = provider.roles[i];
                                          return _RoleCard(
                                            name: role.name,
                                            index: i,
                                            onDelete: () =>
                                                _confirmDelete(context, provider, role),
                                          );
                                        },
                                      ),
                                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, RoleProvider provider, dynamic role) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF13131A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Eliminar rol',
          style: TextStyle(
            color: Color(0xFFF5F0E8),
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        content: Text(
          '¿Seguro que deseas eliminar el rol "${role.name}"? Esta acción no se puede deshacer.',
          style: const TextStyle(color: Color(0xFF6B6B7B), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF6B6B7B)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              provider.deleteRoleId(role.id);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(
                color: Color(0xFFE05252),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Role card ──────────────────────────────────────────────────────────────────

class _RoleCard extends StatefulWidget {
  final String name;
  final int index;
  final VoidCallback onDelete;

  const _RoleCard({
    required this.name,
    required this.index,
    required this.onDelete,
  });

  @override
  State<_RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<_RoleCard> {
  bool _pressed = false;

  // Cycle through a few icon options based on common role names
  IconData get _roleIcon {
    final n = widget.name.toLowerCase();
    if (n.contains('admin')) return Icons.shield_rounded;
    if (n.contains('super')) return Icons.star_rounded;
    if (n.contains('mod') || n.contains('editor')) return Icons.edit_rounded;
    if (n.contains('view') || n.contains('read')) return Icons.visibility_rounded;
    if (n.contains('user')) return Icons.person_rounded;
    if (n.contains('guest')) return Icons.person_outline_rounded;
    // fallback by index to keep variety
    const icons = [
      Icons.shield_rounded,
      Icons.security_rounded,
      Icons.lock_rounded,
      Icons.badge_rounded,
      Icons.verified_user_rounded,
      Icons.manage_accounts_rounded,
    ];
    return icons[widget.index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF13131A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? const Color(0xFFB8960C).withOpacity(0.3)
                  : const Color(0xFF22222E),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8960C).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: const Color(0xFFB8960C).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  _roleIcon,
                  color: const Color(0xFFB8960C),
                  size: 22,
                ),
              ),

              const SizedBox(width: 16),

              // Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Color(0xFFF5F0E8),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Permiso del sistema',
                      style: TextStyle(
                        color: Color(0xFF4A4A5A),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Delete button
              GestureDetector(
                onTap: widget.onDelete,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE05252).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFE05252).withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFE05252),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFB8960C).withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFB8960C).withOpacity(0.18), width: 1),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: Color(0xFFB8960C),
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sin roles aún',
            style: TextStyle(
              color: Color(0xFFF5F0E8),
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Recarga para actualizar la lista',
            style: TextStyle(color: Color(0xFF6B6B7B), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ── Error state ────────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE05252).withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: const Color(0xFFE05252).withOpacity(0.15), width: 1),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: Color(0xFFE05252),
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Algo salió mal',
              style: TextStyle(
                color: Color(0xFFF5F0E8),
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B6B7B), fontSize: 12),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFB8960C).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFB8960C).withOpacity(0.25), width: 1),
                ),
                child: const Text(
                  'Reintentar',
                  style: TextStyle(
                    color: Color(0xFFB8960C),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
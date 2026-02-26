import 'package:flutter/material.dart';
import 'package:flutter_auth_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/routes/app_routes.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with SingleTickerProviderStateMixin {
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

    Future.microtask(() => context.read<UserProvider>().loadUsers());
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
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
                                border: Border.all(color: const Color(0xFF22222E), width: 1),
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
                            'Usuarios',
                            style: TextStyle(
                              color: Color(0xFFF5F0E8),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gestión de\nusuarios.',
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
                              '${provider.users.length} ${provider.users.length == 1 ? "usuario registrado" : "usuarios registrados"}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B6B7B),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: provider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFB8960C),
                                strokeWidth: 2,
                              ),
                            )
                          : provider.error != null
                              ? _ErrorState(error: provider.error!)
                              : provider.users.isEmpty
                                  ? const _EmptyState()
                                  : RefreshIndicator(
                                      onRefresh: provider.loadUsers,
                                      color: const Color(0xFFB8960C),
                                      backgroundColor: const Color(0xFF13131A),
                                      child: ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                                        itemCount: provider.users.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                                        itemBuilder: (_, i) {
                                          final u = provider.users[i];
                                          return _UserCard(
                                            username: u.username,
                                            email: u.email,
                                            onDelete: () => provider.deleteUser(u.id),
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
          Positioned(
            bottom: 28,
            right: 24,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.createUser),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8960C),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB8960C).withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_add_rounded,
                  color: Color(0xFF0A0A0F),
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatefulWidget {
  final String username;
  final String email;
  final VoidCallback onDelete;

  const _UserCard({
    required this.username,
    required this.email,
    required this.onDelete,
  });

  @override
  State<_UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<_UserCard> {
  bool _pressed = false;

  String get _initials {
    final parts = widget.username.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return widget.username.isNotEmpty
        ? widget.username.substring(0, widget.username.length >= 2 ? 2 : 1).toUpperCase()
        : '?';
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF13131A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Eliminar usuario',
          style: TextStyle(color: Color(0xFFF5F0E8), fontWeight: FontWeight.w700, fontSize: 17),
        ),
        content: Text(
          '¿Seguro que deseas eliminar a ${widget.username}? Esta acción no se puede deshacer.',
          style: const TextStyle(color: Color(0xFF6B6B7B), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Color(0xFF6B6B7B))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onDelete();
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Color(0xFFE05252), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
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
              color: _pressed ? const Color(0xFFB8960C).withOpacity(0.3) : const Color(0xFF22222E),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8960C).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: const Color(0xFFB8960C).withOpacity(0.2), width: 1),
                ),
                child: Center(
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: Color(0xFFB8960C),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: const TextStyle(
                        color: Color(0xFFF5F0E8),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.email,
                      style: const TextStyle(color: Color(0xFF6B6B7B), fontSize: 12),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _confirmDelete(context),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE05252).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE05252).withOpacity(0.15), width: 1),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE05252), size: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
              border: Border.all(color: const Color(0xFFB8960C).withOpacity(0.18), width: 1),
            ),
            child: const Icon(Icons.people_outline_rounded, color: Color(0xFFB8960C), size: 32),
          ),
          const SizedBox(height: 20),
          const Text(
            'Sin usuarios aún',
            style: TextStyle(color: Color(0xFFF5F0E8), fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Agrega el primero con el botón +',
            style: TextStyle(color: Color(0xFF6B6B7B), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String error;
  const _ErrorState({required this.error});

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
                border: Border.all(color: const Color(0xFFE05252).withOpacity(0.15), width: 1),
              ),
              child: const Icon(Icons.wifi_off_rounded, color: Color(0xFFE05252), size: 30),
            ),
            const SizedBox(height: 20),
            const Text(
              'Algo salió mal',
              style: TextStyle(color: Color(0xFFF5F0E8), fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B6B7B), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
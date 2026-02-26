import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/routes/app_routes.dart';
import 'package:flutter_auth_app/providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // Background decorative circles — matching login
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
                          // Brand mark
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFB8960C),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.lock_outline_rounded,
                              color: Color(0xFF0A0A0F),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              color: Color(0xFFF5F0E8),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Spacer(),
                          // Logout button
                          GestureDetector(
                            onTap: () {
                              auth.logout();
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.login);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF13131A),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: const Color(0xFF22222E), width: 1),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.logout_rounded,
                                    color: Color(0xFF6B6B7B),
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Salir',
                                    style: TextStyle(
                                      color: Color(0xFF6B6B7B),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Greeting header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Panel de\ncontrol.',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFF5F0E8),
                              height: 1.15,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Administra usuarios y permisos del sistema.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B6B7B),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Section label
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: const Text(
                        'ACCESO RÁPIDO',
                        style: TextStyle(
                          color: Color(0xFF9B9BAB),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Menu cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _DashboardCard(
                            icon: Icons.people_alt_rounded,
                            title: 'Usuarios',
                            subtitle: 'Gestionar cuentas y accesos',
                            delay: 0,
                            onTap: () =>
                                Navigator.pushNamed(context, AppRoutes.users),
                          ),
                          const SizedBox(height: 12),
                          _DashboardCard(
                            icon: Icons.shield_rounded,
                            title: 'Roles',
                            subtitle: 'Configurar permisos y grupos',
                            delay: 80,
                            onTap: () =>
                                Navigator.pushNamed(context, AppRoutes.roles),
                          ),
                        ],
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
}

class _DashboardCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int delay;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.delay,
    required this.onTap,
  });

  @override
  State<_DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<_DashboardCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xFF16161F)
                : const Color(0xFF13131A),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _pressed
                  ? const Color(0xFFB8960C).withOpacity(0.35)
                  : const Color(0xFF22222E),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8960C).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFB8960C).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  color: const Color(0xFFB8960C),
                  size: 24,
                ),
              ),

              const SizedBox(width: 18),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Color(0xFFF5F0E8),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6B6B7B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF3A3A4A),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
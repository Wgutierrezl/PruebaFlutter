import 'package:flutter/material.dart';
import 'package:flutter_auth_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/models/auth_model.dart';
import 'package:flutter_auth_app/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool _obscurePass = true;

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
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // Background decorative circles
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

          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // Logo / Brand mark
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8960C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0xFF0A0A0F),
                            size: 24,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Title
                        const Text(
                          'Bienvenido\nde nuevo.',
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
                          'Inicia sesión para continuar.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B6B7B),
                            letterSpacing: 0.2,
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Email field
                        _buildLabel('Correo electrónico'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: emailCtrl,
                          hint: 'tu@correo.com',
                          icon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        const SizedBox(height: 20),

                        // Password field
                        _buildLabel('Contraseña'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: passCtrl,
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscurePass,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscurePass = !_obscurePass),
                            child: Icon(
                              _obscurePass
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: const Color(0xFF4A4A5A),
                              size: 18,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: auth.isLoading
                                ? null
                                : () async {
                                    final dto = LoginDTO(
                                      email: emailCtrl.text,
                                      password: passCtrl.text,
                                    );
                                    await auth.login(dto);
                                    if (auth.isAuthenticated) {
                                      Navigator.pushReplacementNamed(
                                          context, AppRoutes.home);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB8960C),
                              disabledBackgroundColor:
                                  const Color(0xFFB8960C).withOpacity(0.4),
                              foregroundColor: const Color(0xFF0A0A0F),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: auth.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF0A0A0F),
                                    ),
                                  )
                                : const Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Register link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '¿No tienes cuenta?',
                                style: TextStyle(
                                  color: Color(0xFF6B6B7B),
                                  fontSize: 13,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, AppRoutes.register);
                                },
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Crear cuenta',
                                  style: TextStyle(
                                    color: Color(0xFFB8960C),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF9B9BAB),
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF13131A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF22222E), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFFF5F0E8),
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF3A3A4A), fontSize: 15),
          prefixIcon: Icon(icon, color: const Color(0xFF4A4A5A), size: 18),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffixIcon,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        cursorColor: const Color(0xFFB8960C),
      ),
    );
  }
}
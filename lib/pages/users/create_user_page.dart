import 'package:flutter/material.dart';
import 'package:flutter_auth_app/providers/auth_provider.dart';
import 'package:flutter_auth_app/providers/role_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_app/models/user_model.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage>
    with SingleTickerProviderStateMixin {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  int? selectedRoleId;
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
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
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
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final roleProvider = context.watch<RoleProvider>();

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
                gradient: RadialGradient(colors: [
                  const Color(0xFFB8960C).withOpacity(0.15),
                  Colors.transparent,
                ]),
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
                gradient: RadialGradient(colors: [
                  const Color(0xFFB8960C).withOpacity(0.10),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Top bar
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

                      const SizedBox(height: 32),

                      // Brand icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8960C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.manage_accounts_rounded,
                          color: Color(0xFF0A0A0F),
                          size: 24,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Title
                      const Text(
                        'Nuevo\nusuario.',
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
                        'Completa los datos para crear la cuenta.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B6B7B),
                          letterSpacing: 0.2,
                        ),
                      ),

                      const SizedBox(height: 44),

                      // Username
                      _buildLabel('Nombre de usuario'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: nameCtrl,
                        hint: 'john_doe',
                        icon: Icons.person_outline_rounded,
                      ),

                      const SizedBox(height: 20),

                      // Email
                      _buildLabel('Correo electrónico'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: emailCtrl,
                        hint: 'tu@correo.com',
                        icon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      // Password
                      _buildLabel('Contraseña'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: passCtrl,
                        hint: '••••••••',
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePass,
                        suffixIcon: GestureDetector(
                          onTap: () =>
                              setState(() => _obscurePass = !_obscurePass),
                          child: Icon(
                            _obscurePass
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF4A4A5A),
                            size: 18,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Role selector
                      _buildLabel('Rol'),
                      const SizedBox(height: 8),

                      roleProvider.isLoading
                          ? Container(
                              height: 54,
                              decoration: BoxDecoration(
                                color: const Color(0xFF13131A),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: const Color(0xFF22222E), width: 1),
                              ),
                              child: const Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFB8960C),
                                  ),
                                ),
                              ),
                            )
                          : _RoleSelector(
                              roles: roleProvider.roles,
                              selectedRoleId: selectedRoleId,
                              onChanged: (value) =>
                                  setState(() => selectedRoleId = value),
                            ),

                      const SizedBox(height: 40),

                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: auth.isLoading || selectedRoleId == null
                              ? null
                              : () async {
                                  final dto = UserCreate(
                                    username: nameCtrl.text,
                                    roleId: selectedRoleId!,
                                    email: emailCtrl.text,
                                    password: passCtrl.text,
                                  );
                                  await auth.register(dto);
                                  if (mounted) Navigator.pop(context);
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB8960C),
                            disabledBackgroundColor:
                                const Color(0xFFB8960C).withOpacity(0.3),
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
                                  'Crear usuario',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 36),
                    ],
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
        style: const TextStyle(color: Color(0xFFF5F0E8), fontSize: 15),
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

// ── Custom role selector ───────────────────────────────────────────────────────

class _RoleSelector extends StatelessWidget {
  final List<dynamic> roles;
  final int? selectedRoleId;
  final ValueChanged<int?> onChanged;

  const _RoleSelector({
    required this.roles,
    required this.selectedRoleId,
    required this.onChanged,
  });

  IconData _iconForRole(String name) {
    final n = name.toLowerCase();
    if (n.contains('admin')) return Icons.shield_rounded;
    if (n.contains('super')) return Icons.star_rounded;
    if (n.contains('mod') || n.contains('editor')) return Icons.edit_rounded;
    if (n.contains('view') || n.contains('read')) return Icons.visibility_rounded;
    if (n.contains('employee')) return Icons.badge_rounded;
    if (n.contains('guest')) return Icons.person_outline_rounded;
    return Icons.manage_accounts_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: roles.map((role) {
        final isSelected = selectedRoleId == role.id;
        return GestureDetector(
          onTap: () => onChanged(role.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFB8960C).withOpacity(0.10)
                  : const Color(0xFF13131A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFB8960C).withOpacity(0.45)
                    : const Color(0xFF22222E),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFB8960C).withOpacity(0.15)
                        : const Color(0xFF0F0F16),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFB8960C).withOpacity(0.3)
                          : const Color(0xFF1A1A24),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _iconForRole(role.name),
                    size: 16,
                    color: isSelected
                        ? const Color(0xFFB8960C)
                        : const Color(0xFF4A4A5A),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    role.name,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFF5F0E8)
                          : const Color(0xFF6B6B7B),
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 180),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB8960C),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFF0A0A0F),
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
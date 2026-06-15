import 'package:flutter/material.dart';
import 'login_page.dart';
import 'data_store.dart';
import 'widgets/logo_widget.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = AppTheme.getPrimaryColor(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: AppTheme.getBgDecoration(context),
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Brand Icon/Image Placeholder
                  Icon(
                    Icons.health_and_safety_outlined,
                    size: 80,
                    color: themeColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Masuk Portal LansCare',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getTextColor(context),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pilih peran Anda untuk mengakses layanan yang sesuai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.getSubtextColor(context),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Lansia Card Selection
                  _buildRoleCard(
                    context: context,
                    title: 'Portal Lansia',
                    description: 'Untuk melihat rekam kesehatan, jadwal posyandu, pengingat obat, dan tips kesehatan.',
                    icon: Icons.elderly,
                    color: const Color(0xFFF39C12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(isKader: false),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Kader Card Selection
                  _buildRoleCard(
                    context: context,
                    title: 'Portal Kader',
                    description: 'Untuk petugas posyandu melakukan pencatatan kesehatan, kehadiran, dan kelola kegiatan.',
                    icon: Icons.badge_outlined,
                    color: themeColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(isKader: true),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = DataStore().isDarkMode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppTheme.getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.2 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : color.darken(0.22),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.getSubtextColor(context),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white54 : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}

// Helper extension to darken colors for readability
extension ColorDarken on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsv = HSVColor.fromColor(this);
    final newValue = (hsv.value - amount).clamp(0.0, 1.0);
    return hsv.withValue(newValue).toColor();
  }
}

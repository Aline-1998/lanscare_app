import 'package:flutter/material.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingData> _slides = [
    OnboardingData(
      title: 'Sehat Bersama, Bahagia Selalu',
      description:
          'LansCare membantu lansia memantau kesehatan, jadwal posyandu, dan pengingat penting setiap hari.',
      illustrationBuilder: (context) => const _ElderlyCoupleIllustration(),
    ),
    OnboardingData(
      title: 'Pantau Kesehatan Lebih Mudah',
      description:
          'Catat tekanan darah, gula darah, berat badan, dan denyut nadi kapan saja.',
      illustrationBuilder: (context) => const _HealthMonitoringIllustration(),
    ),
    OnboardingData(
      title: 'Jadwal & Pengingat Tidak Terlewat',
      description:
          'Dapatkan pengingat jadwal posyandu dan minum obat agar tidak terlewat.',
      illustrationBuilder: (context) => const _CalendarReminderIllustration(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Page Title
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F5A5C),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Page Description
                        Text(
                          slide.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Page Illustration
                        Expanded(
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 280),
                              child: slide.illustrationBuilder(context),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom section containing Dots & Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final isActive = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8.0,
                        width: isActive ? 16.0 : 8.0,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF0F5A5C)
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 30),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentIndex < _slides.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          // Go to Login
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F5A5C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentIndex == _slides.length - 1
                            ? 'Mulai Sekarang'
                            : 'Selanjutnya',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final WidgetBuilder illustrationBuilder;

  OnboardingData({
    required this.title,
    required this.description,
    required this.illustrationBuilder,
  });
}

// ILLUSTRATIONS

// Slide 1 Illustration (Elderly couple)
class _ElderlyCoupleIllustration extends StatelessWidget {
  const _ElderlyCoupleIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(260, 240),
      painter: _CouplePainter(),
    );
  }
}

class _CouplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Draw background soft circles
    final paintBg1 = Paint()..color = const Color(0xFFDDEEEF).withOpacity(0.6);
    final paintBg2 = Paint()..color = const Color(0xFFEBF5F6);
    canvas.drawCircle(Offset(width * 0.35, height * 0.5), width * 0.3, paintBg1);
    canvas.drawCircle(Offset(width * 0.65, height * 0.5), width * 0.25, paintBg2);

    // Grandpa (Left)
    final gpPaintHair = Paint()..color = Colors.grey[300]!;
    final gpPaintSkin = Paint()..color = const Color(0xFFFFD1A9);
    final gpPaintShirt = Paint()..color = const Color(0xFF0F5A5C);
    
    // Shirt
    final gpShirtPath = Path();
    gpShirtPath.moveTo(width * 0.15, height * 0.95);
    gpShirtPath.quadraticBezierTo(width * 0.22, height * 0.7, width * 0.35, height * 0.7);
    gpShirtPath.quadraticBezierTo(width * 0.48, height * 0.7, width * 0.55, height * 0.95);
    canvas.drawPath(gpShirtPath, gpPaintShirt);

    // Head gp
    final gpHeadCenter = Offset(width * 0.35, height * 0.5);
    final gpHeadRadius = width * 0.14;
    canvas.drawCircle(gpHeadCenter, gpHeadRadius, gpPaintSkin);

    // Grandpa hair (simple bald-ish layout/sides)
    final gpRightHair = Rect.fromCircle(center: Offset(width * 0.23, height * 0.46), radius: width * 0.04);
    final gpLeftHair = Rect.fromCircle(center: Offset(width * 0.47, height * 0.46), radius: width * 0.04);
    canvas.drawArc(gpRightHair, 0, 3.14, true, gpPaintHair);
    canvas.drawArc(gpLeftHair, 0, 3.14, true, gpPaintHair);

    // Grandpa glasses & eyes
    final glassPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(width * 0.3, height * 0.48), width * 0.035, glassPaint);
    canvas.drawCircle(Offset(width * 0.4, height * 0.48), width * 0.035, glassPaint);
    canvas.drawLine(Offset(width * 0.335, height * 0.48), Offset(width * 0.365, height * 0.48), glassPaint);
    
    // Smile gp
    final smilePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    final gpSmile = Path()..addArc(Rect.fromCircle(center: Offset(width * 0.35, height * 0.54), radius: width * 0.03), 0.1, 2.9);
    canvas.drawPath(gpSmile, smilePaint);


    // Grandma (Right)
    final gmPaintHair = Paint()..color = Colors.grey[200]!;
    final gmPaintSkin = Paint()..color = const Color(0xFFFFD6B2);
    final gmPaintCardigan = Paint()..color = const Color(0xFFF39C12);
    
    // Cardigan / Shirt gm
    final gmShirtPath = Path();
    gmShirtPath.moveTo(width * 0.45, height * 0.95);
    gmShirtPath.quadraticBezierTo(width * 0.52, height * 0.72, width * 0.65, height * 0.72);
    gmShirtPath.quadraticBezierTo(width * 0.78, height * 0.72, width * 0.85, height * 0.95);
    canvas.drawPath(gmShirtPath, gmPaintCardigan);

    // Head gm
    final gmHeadCenter = Offset(width * 0.65, height * 0.53);
    final gmHeadRadius = width * 0.13;
    canvas.drawCircle(gmHeadCenter, gmHeadRadius, gmPaintSkin);

    // Hair bun gm
    canvas.drawCircle(Offset(width * 0.65, height * 0.36), width * 0.05, gmPaintHair);
    // Hair wig gm
    canvas.drawCircle(Offset(width * 0.65, height * 0.44), width * 0.12, gmPaintHair);
    canvas.drawCircle(gmHeadCenter, gmHeadRadius, gmPaintSkin); // Redraw face over background hair line

    // Grandma glasses
    canvas.drawCircle(Offset(width * 0.6, height * 0.52), width * 0.032, glassPaint);
    canvas.drawCircle(Offset(width * 0.7, height * 0.52), width * 0.032, glassPaint);
    canvas.drawLine(Offset(width * 0.632, height * 0.52), Offset(width * 0.668, height * 0.52), glassPaint);
    
    // Smile gm
    final gmSmile = Path()..addArc(Rect.fromCircle(center: Offset(width * 0.65, height * 0.58), radius: width * 0.03), 0.1, 2.9);
    canvas.drawPath(gmSmile, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Slide 2 Illustration (Health monitoring cards & blood & heart)
class _HealthMonitoringIllustration extends StatelessWidget {
  const _HealthMonitoringIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 8, width: 80, color: Colors.grey[300]),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 120, color: const Color(0xFF0F5A5C)),
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bloodtype, color: Color(0xFF22B573), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 8, width: 60, color: Colors.grey[300]),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 90, color: const Color(0xFF22B573)),
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.speed, color: Color(0xFFF39C12), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 8, width: 70, color: Colors.grey[300]),
                    const SizedBox(height: 6),
                    Container(height: 12, width: 100, color: const Color(0xFFF39C12)),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

// Slide 3 Illustration (Calendar and a bell)
class _CalendarReminderIllustration extends StatelessWidget {
  const _CalendarReminderIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(260, 240),
      painter: _CalendarReminderPainter(),
    );
  }
}

class _CalendarReminderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Draw background circle
    final bgPaint = Paint()..color = const Color(0xFFFFF8E1);
    canvas.drawCircle(Offset(width * 0.5, height * 0.5), width * 0.35, bgPaint);

    // Draw Calendar card on the left
    final calPaint = Paint()..color = Colors.white;
    final calShadow = Paint()
      ..color = Colors.black12
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    
    final calRect = Rect.fromLTWH(width * 0.2, height * 0.25, width * 0.32, height * 0.45);
    canvas.drawRect(calRect.shift(const Offset(2, 2)), calShadow);
    canvas.drawRect(calRect, calPaint);

    // Calendar header
    final calHeader = Paint()..color = const Color(0xFF0F5A5C);
    canvas.drawRect(Rect.fromLTWH(width * 0.2, height * 0.25, width * 0.32, height * 0.1), calHeader);

    // Calendar grid lines
    final linePaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 2.0;
    
    // Draw grid
    canvas.drawLine(Offset(width * 0.24, height * 0.43), Offset(width * 0.48, height * 0.43), linePaint);
    canvas.drawLine(Offset(width * 0.24, height * 0.53), Offset(width * 0.48, height * 0.53), linePaint);
    canvas.drawLine(Offset(width * 0.24, height * 0.63), Offset(width * 0.48, height * 0.63), linePaint);
    canvas.drawLine(Offset(width * 0.32, height * 0.39), Offset(width * 0.32, height * 0.66), linePaint);
    canvas.drawLine(Offset(width * 0.40, height * 0.39), Offset(width * 0.40, height * 0.66), linePaint);

    // Checkmark inside calendar
    final checkPaint = Paint()
      ..color = const Color(0xFF22B573)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(width * 0.34, height * 0.5), Offset(width * 0.38, height * 0.54), checkPaint);
    canvas.drawLine(Offset(width * 0.38, height * 0.54), Offset(width * 0.46, height * 0.44), checkPaint);

    // Draw Bell on the right
    final bellPaint = Paint()
      ..color = const Color(0xFFF1C40F)
      ..style = PaintingStyle.fill;
    
    final bellCenter = Offset(width * 0.65, height * 0.48);
    final bellRadius = width * 0.15;
    
    // Bell silhouette
    final bellPath = Path();
    bellPath.moveTo(bellCenter.dx, bellCenter.dy - bellRadius * 1.2);
    // Bell top dome
    bellPath.quadraticBezierTo(bellCenter.dx + bellRadius, bellCenter.dy - bellRadius, bellCenter.dx + bellRadius * 0.8, bellCenter.dy + bellRadius * 0.4);
    // Bell flared bottom
    bellPath.lineTo(bellCenter.dx + bellRadius * 1.2, bellCenter.dy + bellRadius * 0.7);
    bellPath.lineTo(bellCenter.dx - bellRadius * 1.2, bellCenter.dy + bellRadius * 0.7);
    bellPath.lineTo(bellCenter.dx - bellRadius * 0.8, bellCenter.dy + bellRadius * 0.4);
    // Bell top dome left
    bellPath.quadraticBezierTo(bellCenter.dx - bellRadius, bellCenter.dy - bellRadius, bellCenter.dx, bellCenter.dy - bellRadius * 1.2);
    
    canvas.drawPath(bellPath.shift(const Offset(2, 2)), calShadow);
    canvas.drawPath(bellPath, bellPaint);

    // Bell clapper
    canvas.drawCircle(Offset(bellCenter.dx, bellCenter.dy + bellRadius * 0.85), bellRadius * 0.25, Paint()..color = const Color(0xFFD68910));
    // Bell rim bottom bar
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTRB(bellCenter.dx - bellRadius * 1.3, bellCenter.dy + bellRadius * 0.6, bellCenter.dx + bellRadius * 1.3, bellCenter.dy + bellRadius * 0.75), const Radius.circular(3)), Paint()..color = const Color(0xFFD68910));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

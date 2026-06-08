import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'data_store.dart';
import 'kader/dashboard_kader_page.dart';
import 'widgets/logo_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isKaderLogin = false;

  @override
  Widget build(BuildContext context) {
    final themeColor = _isKaderLogin
        ? const Color(0xFF2E7D32)
        : const Color(0xFF0F5A5C);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Brand Logo
              const LansCareLogo(size: 90),
              const SizedBox(height: 16),
              // Brand Title
              Text(
                _isKaderLogin ? 'KADER POSYANDU' : 'LANSCARE',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              // Brand Subtitle
              Text(
                _isKaderLogin
                    ? 'Portal Pencatatan & Arsip Laporan'
                    : 'Sehat Bersama, Bahagia Selalu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),

              // Segmented Toggle between Lansia and Kader login portal
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isKaderLogin = false;
                          _emailController.clear();
                          _passwordController.clear();
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !_isKaderLogin
                                ? const Color(0xFF0F5A5C)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Masuk Lansia',
                            style: TextStyle(
                              color: !_isKaderLogin
                                  ? Colors.white
                                  : (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white70
                                        : Colors.black87),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _isKaderLogin = true;
                          _emailController.clear();
                          _passwordController.clear();
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _isKaderLogin
                                ? const Color(0xFF2E7D32)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Masuk Kader',
                            style: TextStyle(
                              color: _isKaderLogin
                                  ? Colors.white
                                  : (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white70
                                        : Colors.black87),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Email / HP / NIK Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: _isKaderLogin
                      ? 'Email Kader / NIK'
                      : 'Email / NIK Lansia / No. HP',
                  prefixIcon: Icon(
                    _isKaderLogin ? Icons.badge_outlined : Icons.email_outlined,
                    color: themeColor,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: themeColor, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline, color: themeColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: themeColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: themeColor, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Forgot Password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Tautan pemulihan dikirim ke email Anda.',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Lupa password?',
                    style: TextStyle(
                      color: themeColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;
                    final store = DataStore();

                    final user = store.authenticate(email, password);
                    if (user != null) {
                      if (_isKaderLogin) {
                        // User trying to log in as Kader
                        if (user.role == 'Kader') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardKaderPage(),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Berhasil masuk sebagai Kader: ${user.name}!',
                              ),
                            ),
                          );
                        } else {
                          // Deny if Lansia tries to log in under Kader tab
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Akses Tab Salah',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Akun Anda terdaftar sebagai Lansia. Silakan masuk melalui pilihan tab "Masuk Lansia" di atas.',
                                style: TextStyle(height: 1.4),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        // User trying to log in as Lansia
                        if (user.role == 'Lansia') {
                          store.updateProfile(
                            name: user.name,
                            age: user.age,
                            gender: user.gender,
                            nik: user.nik,
                            familyContact: user.familyContact,
                            medicalHistory: user.medicalHistory,
                            profileImage: user.profileImage,
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardPage(),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Selamat datang kembali, ${user.name}!',
                              ),
                            ),
                          );
                        } else {
                          // Deny if Kader tries to log in under Lansia tab
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Akses Tab Salah',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              content: const Text(
                                'Akun Anda terdaftar sebagai Kader Posyandu. Silakan masuk melalui pilihan tab "Masuk Kader" di atas.',
                                style: TextStyle(height: 1.4),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Email/NIK atau password salah! Silakan coba lagi.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _isKaderLogin ? 'Masuk sebagai Kader' : 'Masuk',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Belum punya akun? Daftar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Belum punya akun? ',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showRegisterDialog();
                    },
                    child: Text(
                      'Daftar',
                      style: TextStyle(
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showRegisterDialog() {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final nikCtrl = TextEditingController();
    final familyContactCtrl = TextEditingController();
    final medicalHistoryCtrl = TextEditingController();
    String gender = 'Perempuan';
    String role = 'Lansia';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Daftar Akun LansCare',
            style: TextStyle(
              color: Color(0xFF0F5A5C),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email / No. HP',
                  ),
                ),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                ),
                TextField(
                  controller: nikCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'NIK (16 Digit)',
                  ),
                ),
                TextField(
                  controller: ageCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Umur (Tahun)'),
                ),
                TextField(
                  controller: familyContactCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Kontak Keluarga (Nama - No HP)',
                    hintText: 'Anak: Budi - 0812...',
                  ),
                ),
                TextField(
                  controller: medicalHistoryCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Riwayat Penyakit',
                    hintText: 'Hipertensi, Kolesterol, dll',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: gender,
                  items: ['Perempuan', 'Laki-laki'].map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) gender = val;
                  },
                  decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: role,
                  items: ['Lansia', 'Kader'].map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) role = val;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Daftar Sebagai',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (emailCtrl.text.isNotEmpty &&
                    passCtrl.text.isNotEmpty &&
                    nameCtrl.text.isNotEmpty &&
                    nikCtrl.text.isNotEmpty &&
                    ageCtrl.text.isNotEmpty) {
                  final store = DataStore();
                  store.registerUser(
                    email: emailCtrl.text.trim(),
                    password: passCtrl.text,
                    name: nameCtrl.text,
                    age: int.tryParse(ageCtrl.text) ?? 60,
                    gender: gender,
                    role: role,
                    nik: nikCtrl.text.trim(),
                    familyContact: familyContactCtrl.text.isNotEmpty
                        ? familyContactCtrl.text
                        : 'Belum diisi',
                    medicalHistory: medicalHistoryCtrl.text.isNotEmpty
                        ? medicalHistoryCtrl.text
                        : 'Tidak ada',
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Akun ${nameCtrl.text} ($role) berhasil didaftarkan!',
                      ),
                    ),
                  );

                  // Auto log in based on registered role
                  if (role == 'Kader') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardKaderPage(),
                      ),
                    );
                  } else {
                    store.updateProfile(
                      name: nameCtrl.text,
                      age: int.tryParse(ageCtrl.text) ?? 60,
                      gender: gender,
                      nik: nikCtrl.text.trim(),
                      familyContact: familyContactCtrl.text.isNotEmpty
                          ? familyContactCtrl.text
                          : 'Belum diisi',
                      medicalHistory: medicalHistoryCtrl.text.isNotEmpty
                          ? medicalHistoryCtrl.text
                          : 'Tidak ada',
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Mohon isi data pendaftaran (Email, Password, Nama, NIK, dan Umur)!',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A5C),
              ),
              child: const Text(
                'Daftar & Masuk',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

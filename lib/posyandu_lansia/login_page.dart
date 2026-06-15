import 'package:flutter/material.dart';

import 'dashboard_page.dart';
import 'data_store.dart';
import 'database_helper.dart';
import 'kader/dashboard_kader_page.dart';
import 'widgets/logo_widget.dart';

class LoginPage extends StatefulWidget {
  final bool isKader;
  const LoginPage({super.key, required this.isKader});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late bool _isKaderLogin;
  String _selectedPosyandu = 'Posyandu Rt.11 Rw.03';

  @override
  void initState() {
    super.initState();
    _isKaderLogin = widget.isKader;
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Brand Logo
              const LansCareLogo(size: 180),
              const SizedBox(height: 16),
              // Brand Title
              Text(
                _isKaderLogin ? 'KADER LANSCARE' : 'LANSCARE',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.getTextColor(context),
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
                  color: AppTheme.getSubtextColor(context),
                ),
              ),
              const SizedBox(height: 30),

              // Segmented Toggle between Lansia and Kader login portal
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.getCardColor(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DataStore().isDarkMode ? Colors.white12 : Colors.grey.shade300,
                  ),
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
                                ? themeColor
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
                                ? themeColor
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

              // Posyandu label above field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Posyandu',
                  style: TextStyle(
                    color: AppTheme.getTextColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Posyandu selection field
              InkWell(
                onTap: () {
                  _showSearchablePosyanduPicker(
                    context: context,
                    currentValue: _selectedPosyandu,
                    allowAddNew: _isKaderLogin,
                    onSelected: (val) {
                      setState(() {
                        _selectedPosyandu = val;
                      });
                    },
                  );
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: TextEditingController(text: _selectedPosyandu),
                    key: ValueKey(_selectedPosyandu),
                    decoration: InputDecoration(
                      hintText: 'Pilih Posyandu Anda',
                      hintStyle: TextStyle(
                        color: DataStore().isDarkMode ? Colors.white60 : Colors.grey.shade500,
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(Icons.location_city, color: themeColor),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      filled: true,
                      fillColor: AppTheme.getCardColor(context),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: DataStore().isDarkMode ? Colors.white12 : Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: themeColor, width: 1.8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Identity label above field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _isKaderLogin ? 'Identitas Kader' : 'Identitas Lansia',
                  style: TextStyle(
                    color: AppTheme.getTextColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Email / HP / NIK Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: _isKaderLogin
                      ? 'Email Kader / NIK'
                      : 'Email / NIK / No. HP',
                  hintStyle: TextStyle(
                    color: DataStore().isDarkMode ? Colors.white60 : Colors.grey.shade500,
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    _isKaderLogin ? Icons.badge_outlined : Icons.email_outlined,
                    color: themeColor,
                  ),
                  filled: true,
                  fillColor: AppTheme.getCardColor(context),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: DataStore().isDarkMode ? Colors.white12 : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: themeColor, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password label above field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kata Sandi',
                  style: TextStyle(
                    color: AppTheme.getTextColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Masukkan password',
                  hintStyle: TextStyle(
                    color: DataStore().isDarkMode ? Colors.white60 : Colors.grey.shade500,
                    fontSize: 13,
                  ),
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
                  fillColor: AppTheme.getCardColor(context),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: DataStore().isDarkMode ? Colors.white12 : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: themeColor, width: 1.8),
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
                      color: DataStore().isDarkMode ? themeColor : const Color(0xFF0F5A5C),
                      fontWeight: FontWeight.bold,
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
                      DatabaseHelper.instance.saveSession(user.email, user.role);
                      store.currentUserEmail = user.email;
                      store.currentUserRole = user.role;
                      store.loadHealthRecords(user.email);
                      store.updateProfile(
                        name: user.name,
                        age: user.age,
                        gender: user.gender,
                        nik: user.nik,
                        familyContact: user.familyContact,
                        medicalHistory: user.medicalHistory,
                        profileImage: user.profileImage,
                        posyandu: user.posyandu,
                        kaderContact: user.kaderContact,
                      );
                      store.updateKaderPosyandu(user.posyandu);

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
                      borderRadius: BorderRadius.circular(12.0),
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
                    style: TextStyle(
                      color: DataStore().isDarkMode ? Colors.white70 : const Color(0xFF1B3D44),
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showRegisterDialog(isKader: _isKaderLogin);
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
    ),
  );
}

  void _showRegisterDialog({required bool isKader}) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final ageCtrl = TextEditingController();
    final nikCtrl = TextEditingController();
    final familyContactCtrl = TextEditingController();
    String gender = 'Perempuan';
    String registerPosyandu = 'Posyandu Rt.11 Rw.03';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                isKader ? 'Daftar Akun Kader' : 'Daftar Akun Lansia',
                style: TextStyle(
                  color: AppTheme.getPrimaryColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                      ),
                    ),
                    TextField(
                      controller: emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Email / Gmail',
                      ),
                    ),
                    TextField(
                      controller: passCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    TextField(
                      controller: ageCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Umur (Tahun)',
                      ),
                    ),
                    if (isKader) ...[
                      TextField(
                        controller: nikCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'NIK (16 Digit)',
                        ),
                      ),
                      TextField(
                        controller: familyContactCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon Anda (Kader)',
                          hintText: '0812...',
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
                          if (val != null) {
                            setStateDialog(() {
                              gender = val;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Jenis Kelamin',
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showSearchablePosyanduPicker(
                            context: context,
                            currentValue: registerPosyandu,
                            allowAddNew: isKader,
                            onSelected: (val) {
                              setStateDialog(() {
                                registerPosyandu = val;
                              });
                            },
                          );
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            controller: TextEditingController(
                              text: registerPosyandu,
                            ),
                            key: ValueKey(registerPosyandu),
                            decoration: const InputDecoration(
                              labelText: 'Pilih Posyandu',
                              suffixIcon: Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (emailCtrl.text.isNotEmpty &&
                        passCtrl.text.isNotEmpty &&
                        nameCtrl.text.isNotEmpty &&
                        ageCtrl.text.isNotEmpty &&
                        (!isKader || nikCtrl.text.isNotEmpty)) {
                      final store = DataStore();
                      final role = isKader ? 'Kader' : 'Lansia';
                      final registeredEmail = emailCtrl.text.trim();
                      store.registerUser(
                        email: registeredEmail,
                        password: passCtrl.text,
                        name: nameCtrl.text,
                        age: int.tryParse(ageCtrl.text) ?? 60,
                        gender: isKader ? gender : 'Belum diisi',
                        role: role,
                        nik: isKader ? nikCtrl.text.trim() : 'Belum diisi',
                        familyContact: isKader && familyContactCtrl.text.isNotEmpty
                            ? familyContactCtrl.text
                            : 'Belum diisi',
                        medicalHistory: 'Tidak ada',
                        posyandu: isKader ? registerPosyandu : 'Posyandu Melati',
                        kaderContact: '',
                      );

                      DatabaseHelper.instance.saveSession(registeredEmail, role);
                      store.currentUserEmail = registeredEmail;
                      store.currentUserRole = role;
                      store.loadHealthRecords(registeredEmail);

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Akun ${nameCtrl.text} ($role) berhasil didaftarkan!',
                          ),
                        ),
                      );

                      // Auto log in based on registered role
                      if (isKader) {
                        store.updateProfile(
                          name: nameCtrl.text,
                          age: int.tryParse(ageCtrl.text) ?? 40,
                          gender: gender,
                          nik: nikCtrl.text.trim(),
                          familyContact: familyContactCtrl.text.isNotEmpty
                              ? familyContactCtrl.text
                              : 'Belum diisi',
                          medicalHistory: 'Tidak ada',
                          posyandu: registerPosyandu,
                        );
                        store.updateKaderPosyandu(registerPosyandu);
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
                          gender: 'Belum diisi',
                          nik: 'Belum diisi',
                          familyContact: 'Belum diisi',
                          medicalHistory: 'Tidak ada',
                          posyandu: 'Posyandu Melati',
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
                        SnackBar(
                          content: Text(
                            isKader 
                              ? 'Mohon isi data pendaftaran (Email, Password, Nama, NIK, dan Umur)!'
                              : 'Mohon isi data pendaftaran (Nama, Email, Password, dan Umur)!',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.getPrimaryColor(context),
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
      },
    );
  }

  void _showSearchablePosyanduPicker({
    required BuildContext context,
    required String currentValue,
    required ValueChanged<String> onSelected,
    bool allowAddNew = true,
  }) {
    final store = DataStore();
    final searchCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final query = searchCtrl.text.trim();
            final filteredList = store.posyandus
                .where(
                  (item) => item.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

            final showAddNew =
                allowAddNew &&
                query.isNotEmpty &&
                !store.posyandus.any(
                  (item) => item.toLowerCase() == query.toLowerCase(),
                );

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Pilih Posyandu',
                style: TextStyle(
                  color: AppTheme.getPrimaryColor(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchCtrl,
                      decoration: InputDecoration(
                        hintText: 'Cari Posyandu...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppTheme.getPrimaryColor(context),
                        ),
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade900
                            : Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) {
                        setStateDialog(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            if (showAddNew)
                              ListTile(
                                leading: Icon(
                                  Icons.add,
                                  color: AppTheme.getPrimaryColor(context),
                                ),
                                title: Text(
                                  'Tambah "$query"',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.getPrimaryColor(context),
                                  ),
                                ),
                                subtitle: const Text(
                                  'Jadikan posyandu baru di sistem',
                                ),
                                onTap: () {
                                  store.addPosyandu(query);
                                  onSelected(query);
                                  Navigator.pop(context);
                                },
                              ),
                            if (filteredList.isEmpty && !showAddNew)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                child: Center(
                                  child: Text('Posyandu tidak ditemukan'),
                                ),
                              ),
                            ...filteredList.map((item) {
                              final isSelected = item == currentValue;
                              return ListTile(
                                title: Text(
                                  item,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppTheme.getPrimaryColor(context)
                                        : null,
                                  ),
                                ),
                                trailing: isSelected
                                    ? Icon(
                                        Icons.check,
                                        color: AppTheme.getPrimaryColor(context),
                                      )
                                    : null,
                                onTap: () {
                                  onSelected(item);
                                  Navigator.pop(context);
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'posyandu_lansia/onboarding_page.dart';
import 'posyandu_lansia/data_store.dart';
import 'posyandu_lansia/database_helper.dart';
import 'posyandu_lansia/dashboard_page.dart';
import 'posyandu_lansia/kader/dashboard_kader_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataStore().init();

  final session = await DatabaseHelper.instance.getSession();
  Widget initialScreen = const OnboardingPage();

  if (session != null) {
    final email = session['email']!;
    final role = session['role']!;
    final store = DataStore();

    final user = store.users.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => RegisteredUser(
        email: email,
        password: '',
        role: role,
        name: role == 'Kader' ? 'Bu Rina' : 'Siti Aminah',
        age: role == 'Kader' ? 40 : 66,
        gender: 'Perempuan',
        nik: '',
        familyContact: '',
        medicalHistory: '',
        posyandu: 'Posyandu Melati',
      ),
    );

    store.currentUserEmail = user.email;
    store.currentUserRole = user.role;
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

    await store.loadHealthRecords(user.email);

    if (role == 'Kader') {
      initialScreen = const DashboardKaderPage();
    } else {
      initialScreen = const DashboardPage();
    }
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    final store = DataStore();
    return AnimatedBuilder(
      animation: store,
      builder: (context, child) {
        return MaterialApp(
          title: 'LansCare',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF27A1A6),
              primary: const Color(0xFF27A1A6),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF27A1A6),
              primary: const Color(0xFF27A1A6),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: store.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: initialScreen,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(store.fontSizeFactor),
              ),
              child: Container(
                decoration: AppTheme.getBgDecoration(context),
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}




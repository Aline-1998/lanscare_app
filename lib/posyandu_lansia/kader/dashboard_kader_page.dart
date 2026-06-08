import 'package:flutter/material.dart';

import '../data_store.dart';
import '../login_page.dart';
import 'manage_jadwal_page.dart';
import 'data_lansia_page.dart';
import 'input_pemeriksaan_page.dart';
import 'rekap_laporan_page.dart';

class DashboardKaderPage extends StatefulWidget {
  const DashboardKaderPage({super.key});

  @override
  State<DashboardKaderPage> createState() => _DashboardKaderPageState();
}

class _DashboardKaderPageState extends State<DashboardKaderPage> {
  final DataStore _store = DataStore();
  int _currentTabIndex = 4; // Active tab is Kader Menu (index 4)

  void _showAnnouncementDialog() {
    final titleCtrl = TextEditingController(text: 'Pengumuman Penting');
    final bodyCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Kirim Pengumuman',
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
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Judul Pengumuman',
                  ),
                ),
                TextField(
                  controller: bodyCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Isi Pengumuman / Pesan',
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
                if (titleCtrl.text.isNotEmpty && bodyCtrl.text.isNotEmpty) {
                  _store.addNotification(
                    titleCtrl.text,
                    bodyCtrl.text,
                    'Hari ini',
                    'Informasi',
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Pengumuman berhasil disebarkan ke semua lansia!',
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5A5C),
              ),
              child: const Text('Kirim', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _store,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Halo, Bu Rina 👋',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F5A5C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kader Posyandu Melati',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.red),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 4 Summary Metrics Cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    children: [
                      _buildSummaryCard(
                        'Lansia Terdaftar',
                        '${_store.lansiaMembers.length} orang',
                        Icons.group,
                        Colors.blue,
                      ),
                      _buildSummaryCard(
                        'Pemeriksaan Hari Ini',
                        '12 orang',
                        Icons.check_circle_outline,
                        const Color(0xFF22B573),
                      ),
                      _buildSummaryCard(
                        'Jadwal Terdekat',
                        '15 Mei 2024',
                        Icons.calendar_month,
                        Colors.teal,
                      ),
                      _buildSummaryCard(
                        'Pengingat Terkirim',
                        '8 notifikasi',
                        Icons.send_to_mobile,
                        Colors.orange,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Menu Kader Title
                  const Text(
                    'Menu Kader',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F5A5C),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Grid Menu
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildMenuTile(context, 'Data Lansia', Icons.people, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataLansiaPage(),
                          ),
                        );
                      }),
                      _buildMenuTile(
                        context,
                        'Input Pemeriksaan',
                        Icons.edit_document,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const InputPemeriksaanPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuTile(
                        context,
                        'Jadwal Posyandu',
                        Icons.calendar_today,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ManageJadwalPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuTile(
                        context,
                        'Kirim Pengumuman',
                        Icons.campaign,
                        _showAnnouncementDialog,
                      ),
                      _buildMenuTile(
                        context,
                        'Rekap Laporan',
                        Icons.bar_chart,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RekapLaporanPage(),
                            ),
                          );
                        },
                      ),
                      _buildMenuTile(
                        context,
                        'Pengaturan',
                        Icons.settings,
                        () {},
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Kembali ke Menu Utama Kader untuk mengakses fitur ini.',
              ),
            ),
          );
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0F5A5C),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Kesehatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Artikel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            activeIcon: Icon(Icons.manage_accounts, color: Color(0xFF0F5A5C)),
            label: 'Kader',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String val,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          Text(
            val,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F5A5C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF4F5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF0F5A5C), size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

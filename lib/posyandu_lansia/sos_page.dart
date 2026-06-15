import 'package:flutter/material.dart';

import 'data_store.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerSos() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text(
                'SOS DIKIRIM',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Sinyal darurat dan lokasi Anda telah dikirimkan ke pihak Keluarga dan Kader Posyandu terdekat. Tetap tenang, bantuan sedang dalam perjalanan.',
            style: TextStyle(height: 1.5),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _callNumber(String label, String number) {
    // Extract number if formatted as "Name - Number"
    String finalNumber = number;
    if (number.contains(' - ')) {
      finalNumber = number.split(' - ').last;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Menghubungi $label'),
          content: Text('Apakah Anda ingin menelepon $finalNumber?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Memanggil $finalNumber...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27A1A6),
              ),
              child: const Text(
                'Panggil',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditSosDialog(BuildContext context) {
    final store = DataStore();
    final familyController = TextEditingController(
      text: store.userFamilyContact,
    );
    final kaderController = TextEditingController(text: store.userKaderContact);
    final puskesmasController = TextEditingController(
      text: store.userPuskesmasContact,
    );
    final ambulanceController = TextEditingController(
      text: store.userAmbulanceContact,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Ubah Kontak Darurat',
            style: TextStyle(
              color: Color(0xFF27A1A6),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: familyController,
                  decoration: const InputDecoration(
                    labelText: 'Kontak Keluarga',
                    hintText: 'Nama - No Telp',
                  ),
                ),
                TextField(
                  controller: kaderController,
                  decoration: const InputDecoration(
                    labelText: 'Kontak Kader',
                    hintText: 'Nama - No Telp',
                  ),
                ),
                TextField(
                  controller: puskesmasController,
                  decoration: const InputDecoration(
                    labelText: 'Kontak Puskesmas',
                    hintText: 'Nama - No Telp',
                  ),
                ),
                TextField(
                  controller: ambulanceController,
                  decoration: const InputDecoration(
                    labelText: 'Layanan Ambulans',
                    hintText: 'No Telp',
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
                store.updateSosContacts(
                  familyContact: familyController.text,
                  kaderContact: kaderController.text,
                  puskesmasContact: puskesmasController.text,
                  ambulanceContact: ambulanceController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kontak darurat berhasil diperbarui'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF27A1A6),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = DataStore();
    final isDark = store.isDarkMode;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF27A1A6)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Darurat (SOS)',
          style: TextStyle(
            color: Color(0xFF27A1A6),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF27A1A6)),
            tooltip: 'Ubah Kontak SOS',
            onPressed: () => _showEditSosDialog(context),
          ),
        ],
      ),
      body: Container(
        decoration: AppTheme.getBgDecoration(context),
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: store,
            builder: (context, child) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Butuh Bantuan Darurat?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tekan tombol SOS jika Anda membutuhkan bantuan segera.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.getTextColor(context).withOpacity(0.8),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Pulsing SOS Button
                    Center(
                      child: ScaleTransition(
                        scale: _pulseAnimation,
                        child: GestureDetector(
                          onTap: _triggerSos,
                          child: Container(
                            width: 170,
                            height: 170,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.4),
                                  blurRadius: 18,
                                  spreadRadius: 6,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.ring_volume,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'SOS\nDarurat',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Hubungi Cepat List
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Hubungi Cepat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.getTextColor(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildContactItem(
                      'Keluarga',
                      store.userFamilyContact,
                      Colors.indigo,
                    ),
                    const SizedBox(height: 10),
                    _buildContactItem(
                      'Kader Posyandu',
                      store.userKaderContact,
                      const Color(0xFF27A1A6),
                    ),
                    const SizedBox(height: 10),
                    _buildContactItem(
                      'Puskesmas Terdekat',
                      store.userPuskesmasContact,
                      Colors.teal,
                    ),
                    const SizedBox(height: 10),
                    _buildContactItem(
                      'Ambulans',
                      store.userAmbulanceContact,
                      Colors.red,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(String label, String number, Color color) {
    final isDark = DataStore().isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.getCardColor(context),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(isDark ? 0.2 : 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppTheme.getTextColor(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        number,
                        style: TextStyle(
                          color: AppTheme.getTextColor(
                            context,
                          ).withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _callNumber(label, number),
            icon: const Icon(
              Icons.phone_forwarded,
              color: Colors.green,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

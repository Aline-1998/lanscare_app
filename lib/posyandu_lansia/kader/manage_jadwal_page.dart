import 'package:flutter/material.dart';
import '../data_store.dart';

class ManageJadwalPage extends StatefulWidget {
  final bool isEmbedded;
  const ManageJadwalPage({super.key, this.isEmbedded = false});

  @override
  State<ManageJadwalPage> createState() => _ManageJadwalPageState();
}

class _ManageJadwalPageState extends State<ManageJadwalPage> {
  final DataStore _store = DataStore();

  void _showAddScheduleDialog() {
    final nameCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: '15');
    final monthCtrl = TextEditingController(text: 'Mei');
    final timeCtrl = TextEditingController(text: '08.00 - 11.00 WIB');
    final locationCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Tambah Jadwal Posyandu',
            style: TextStyle(color: Color(0xFF0F5A5C), fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Posyandu (contoh: Posyandu Dahlia)'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dateCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Tanggal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: monthCtrl,
                        decoration: const InputDecoration(labelText: 'Bulan (contoh: Juni)'),
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: timeCtrl,
                  decoration: const InputDecoration(labelText: 'Waktu (contoh: 08.00 - 11.00 WIB)'),
                ),
                TextField(
                  controller: locationCtrl,
                  decoration: const InputDecoration(labelText: 'Lokasi / Alamat'),
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
                if (nameCtrl.text.isNotEmpty && locationCtrl.text.isNotEmpty) {
                  final int day = int.tryParse(dateCtrl.text) ?? 1;
                  // Add posyandu schedule
                  _store.addPosyanduSchedule(
                    nameCtrl.text,
                    DateTime(2026, 6, day), // Assume default year
                    timeCtrl.text,
                    locationCtrl.text,
                  );
                  
                  // Send out a notification broadcast alerts to all lansia
                  _store.addNotification(
                    'Jadwal Posyandu Baru',
                    'Kader menambahkan ${nameCtrl.text} pada tanggal ${dateCtrl.text} ${monthCtrl.text}.',
                    'Sekarang',
                    'Pengingat',
                  );

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Jadwal ${nameCtrl.text} berhasil dijadwalkan!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F5A5C)),
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F5A5C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Kelola Jadwal Posyandu',
          style: TextStyle(color: Color(0xFF0F5A5C), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: AnimatedBuilder(
        animation: _store,
        builder: (context, child) {
          final list = _store.schedules;
          return Column(
            children: [
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Text('Belum ada jadwal posyandu', style: TextStyle(color: Colors.grey[600])),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: list.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = list[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: Colors.grey.shade100),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBF4F5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        '${item.date.day}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF0F5A5C)),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Bln',
                                        style: TextStyle(fontSize: 11, color: Color(0xFF0F5A5C), fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F5A5C)),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.access_time, size: 13, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(item.timeRange, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on_outlined, size: 13, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              item.location,
                                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _showAddScheduleDialog,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Buat Jadwal Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5A5C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

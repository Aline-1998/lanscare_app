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
    final timeCtrl = TextEditingController(text: '08.00 - 11.00 WIB');
    final locationCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final months = [
              'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
              'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
            ];
            final dateStr = '${selectedDate.day} ${months[selectedDate.month - 1]} ${selectedDate.year}';
            
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
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pilih Tanggal:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F5A5C))),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.calendar_today, color: Color(0xFF0F5A5C)),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null && picked != selectedDate) {
                              setStateDialog(() {
                                selectedDate = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
                    if (nameCtrl.text.trim().isEmpty || locationCtrl.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon isi semua data jadwal (Nama Posyandu dan Lokasi)!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Add posyandu schedule
                    _store.addPosyanduSchedule(
                      nameCtrl.text.trim(),
                      selectedDate,
                      timeCtrl.text.trim(),
                      locationCtrl.text.trim(),
                    );
                    
                    // Send out a notification broadcast alerts to all lansia
                    _store.addNotification(
                      'Jadwal Posyandu Baru',
                      'Kader menambahkan ${nameCtrl.text.trim()} pada tanggal $dateStr.',
                      'Sekarang',
                      'Pengingat',
                    );

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Jadwal ${nameCtrl.text.trim()} berhasil dijadwalkan!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F5A5C)),
                  child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.getCardColor(context),
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
                          final months = [
                            'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                            'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
                          ];
                          final monthStr = months[item.date.month - 1];
                          return Container(
                            decoration: BoxDecoration(
                              color: AppTheme.getCardColor(context),
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Container(
                                   width: 55,
                                   padding: const EdgeInsets.symmetric(vertical: 8),
                                   decoration: BoxDecoration(
                                     color: AppTheme.getPrimaryColor(context).withOpacity(0.1),
                                     borderRadius: BorderRadius.circular(12),
                                     border: Border.all(
                                       color: AppTheme.getPrimaryColor(context).withOpacity(0.2),
                                     ),
                                   ),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Text(
                                         '${item.date.day}',
                                         style: TextStyle(
                                           fontSize: 20,
                                           fontWeight: FontWeight.bold,
                                           color: AppTheme.getPrimaryColor(context),
                                         ),
                                       ),
                                       const SizedBox(height: 2),
                                       Text(
                                         monthStr.toUpperCase(),
                                         style: TextStyle(
                                           fontSize: 10,
                                           fontWeight: FontWeight.bold,
                                           color: AppTheme.getPrimaryColor(context).withOpacity(0.8),
                                           letterSpacing: 1.1,
                                         ),
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
                                          Icon(Icons.access_time, size: 13, color: AppTheme.getSubtextColor(context)),
                                          const SizedBox(width: 4),
                                          Text(item.timeRange, style: TextStyle(color: AppTheme.getSubtextColor(context), fontSize: 12)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on_outlined, size: 13, color: AppTheme.getSubtextColor(context)),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              item.location,
                                              style: TextStyle(color: AppTheme.getSubtextColor(context), fontSize: 12),
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

import 'package:flutter/material.dart';
import 'data_store.dart';

class PengingatObatPage extends StatefulWidget {
  const PengingatObatPage({super.key});

  @override
  State<PengingatObatPage> createState() => _PengingatObatPageState();
}

class _PengingatObatPageState extends State<PengingatObatPage> {
  final DataStore _store = DataStore();

  void _showAddMedicineDialog() {
    final nameController = TextEditingController();
    final doseController = TextEditingController(text: '1 tablet');
    final timeController = TextEditingController(text: '08.00');
    final noteController = TextEditingController(text: 'sesudah makan');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Tambah Jadwal Obat',
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Obat (contoh: Paracetamol)',
                    hintText: 'Aspirin, Amlodipin, dll',
                  ),
                ),
                TextField(
                  controller: doseController,
                  decoration: const InputDecoration(
                    labelText: 'Dosis (contoh: 1 tablet / 5 ml)',
                  ),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    labelText: 'Waktu (contoh: 07.30 / 18.00)',
                  ),
                ),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan (contoh: sesudah makan)',
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
                if (nameController.text.isNotEmpty) {
                  _store.addMedicine(
                    nameController.text,
                    doseController.text,
                    timeController.text,
                    noteController.text,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Obat ${nameController.text} berhasil ditambahkan!')),
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
      backgroundColor: const Color(0xFFF5F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F5A5C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengingat Obat',
          style: TextStyle(
            color: Color(0xFF0F5A5C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _store,
        builder: (context, child) {
          final medicines = _store.medicines;
          return Column(
            children: [
              // Date Indicator Row
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Color(0xFF0F5A5C)),
                    const SizedBox(width: 8),
                    Text(
                      'Hari Ini: ${_getFormattedDate()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F5A5C),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Medicine List
              Expanded(
                child: medicines.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada jadwal obat',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        itemCount: medicines.length,
                        itemBuilder: (context, index) {
                          final med = medicines[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: med.isChecked
                                    ? const Color(0xFF22B573).withOpacity(0.3)
                                    : Colors.grey.shade200,
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Left Icon
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: med.isChecked
                                        ? const Color(0xFFE8F5E9)
                                        : const Color(0xFFEBF4F5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.medication,
                                    color: med.isChecked
                                        ? const Color(0xFF22B573)
                                        : const Color(0xFF0F5A5C),
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                // Text details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        med.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: const Color(0xFF0F5A5C),
                                          decoration: med.isChecked ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time, size: 13, color: Colors.grey[600]),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Pukul ${med.time}',
                                            style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '• ${med.dose} ${med.note}',
                                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Checkbox
                                GestureDetector(
                                  onTap: () {
                                    _store.toggleMedicine(med.id);
                                  },
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: med.isChecked ? const Color(0xFF22B573) : Colors.grey,
                                        width: 2.0,
                                      ),
                                      color: med.isChecked ? const Color(0xFF22B573) : Colors.transparent,
                                    ),
                                    child: med.isChecked
                                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Bottom Button Row
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _showAddMedicineDialog,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Tambah Obat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5A5C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

import 'package:flutter/material.dart';
import '../data_store.dart';

class InputPemeriksaanPage extends StatefulWidget {
  const InputPemeriksaanPage({super.key});

  @override
  State<InputPemeriksaanPage> createState() => _InputPemeriksaanPageState();
}

class _InputPemeriksaanPageState extends State<InputPemeriksaanPage> {
  final DataStore _store = DataStore();
  
  LansiaMember? _selectedLansia;
  final _bpSysCtrl = TextEditingController(text: '120');
  final _bpDiaCtrl = TextEditingController(text: '80');
  final _sugarCtrl = TextEditingController(text: '90');
  final _weightCtrl = TextEditingController(text: '55.0');
  final _heartCtrl = TextEditingController(text: '72');

  @override
  void initState() {
    super.initState();
    if (_store.lansiaMembers.isNotEmpty) {
      _selectedLansia = _store.lansiaMembers.first;
    }
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
          'Input Pemeriksaan',
          style: TextStyle(color: Color(0xFF0F5A5C), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Anggota Lansia',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F5A5C), fontSize: 14),
            ),
            const SizedBox(height: 8),

            // Dropdown to select Lansia
            DropdownButtonFormField<LansiaMember>(
              value: _selectedLansia,
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
              items: _store.lansiaMembers.map((LansiaMember val) {
                return DropdownMenuItem<LansiaMember>(
                  value: val,
                  child: Text('${val.name} (${val.age} Thn • ${val.gender})'),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedLansia = val;
                });
              },
            ),
            const SizedBox(height: 24),

            const Text(
              'Data Hasil Pemeriksaan',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F5A5C), fontSize: 14),
            ),
            const SizedBox(height: 12),

            // BP Input
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tekanan Darah (mmHg)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _bpSysCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Sistolik',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('/', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _bpDiaCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Diastolik',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sugar Input
            _buildInputContainer('Gula Darah Sewaktu (mg/dL)', _sugarCtrl),
            const SizedBox(height: 16),

            // Weight Input
            _buildInputContainer('Berat Badan (kg)', _weightCtrl, isDecimal: true),
            const SizedBox(height: 16),

            // Heart Rate Input
            _buildInputContainer('Denyut Nadi (bpm)', _heartCtrl),
            const SizedBox(height: 30),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final member = _selectedLansia;
                  final double? wt = double.tryParse(_weightCtrl.text);
                  final int? sg = int.tryParse(_sugarCtrl.text);
                  final int? ht = int.tryParse(_heartCtrl.text);

                  if (member != null && wt != null && sg != null && ht != null) {
                    _store.addKaderRecord(
                      member.id,
                      HealthRecord(
                        date: DateTime.now(),
                        bpSystolic: _bpSysCtrl.text,
                        bpDiastolic: _bpDiaCtrl.text,
                        bloodSugar: sg,
                        weight: wt,
                        heartRate: ht,
                      ),
                    );
                    
                    // Add automatic notification alert for Lansia
                    _store.addNotification(
                      'Pemeriksaan Baru Dicatat',
                      'Vitals Anda telah diperbarui oleh Kader ${member.name}. Cek ringkasan kesehatan Anda.',
                      'Sekarang',
                      'Pengingat',
                    );

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Pemeriksaan untuk ${member.name} berhasil disimpan!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mohon isi data dengan benar!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5A5C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Simpan Hasil Pemeriksaan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputContainer(String label, TextEditingController controller, {bool isDecimal = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: isDecimal ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }
}

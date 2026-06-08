import 'package:flutter/material.dart';
import '../widgets/custom_chart.dart';

class RekapLaporanPage extends StatefulWidget {
  const RekapLaporanPage({super.key});

  @override
  State<RekapLaporanPage> createState() => _RekapLaporanPageState();
}

class _RekapLaporanPageState extends State<RekapLaporanPage> {
  String _selectedYear = 'Tahun 2026';
  final List<String> _years = List.generate(31, (index) => 'Tahun ${2020 + index}');

  Map<String, String> _getStatsForYear(String yearStr) {
    final int year = int.tryParse(yearStr.replaceAll('Tahun ', '')) ?? 2026;
    // Calculate deterministic stats so they change dynamically based on the selected year
    final int total = ((year - 2000) * 4.5).round();
    final int normal = (total * 0.7).round();
    final int attention = (total * 0.2).round();
    final int referral = total - normal - attention;

    return {
      'total': '$total',
      'normal': '$normal',
      'attention': '$attention',
      'referral': '$referral',
    };
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getStatsForYear(_selectedYear);

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
          'Rekap Laporan',
          style: TextStyle(color: Color(0xFF0F5A5C), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown month/year selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedYear,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF0F5A5C)),
                  items: _years.map((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F5A5C))),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedYear = val;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Summary Stats Cards
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              children: [
                _buildReportStatCard('Pemeriksaan', stats['total']!, Colors.blue),
                _buildReportStatCard('Normal', stats['normal']!, const Color(0xFF22B573)),
                _buildReportStatCard('Perlu Perhatian', stats['attention']!, Colors.orange),
                _buildReportStatCard('Rujukan', stats['referral']!, Colors.red),
              ],
            ),
            const SizedBox(height: 24),

            // Bar Chart Container Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8)],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grafik Pemeriksaan',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F5A5C)),
                  ),
                  SizedBox(height: 12),
                  BarChartWidget(),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Download Report Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Laporan Rekap $_selectedYear sedang diunduh...')),
                  );
                },
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  'Unduh Laporan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5A5C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReportStatCard(String label, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 6)],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F5A5C)),
          ),
        ],
      ),
    );
  }
}

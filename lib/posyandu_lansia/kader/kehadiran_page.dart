import 'package:flutter/material.dart';
import '../data_store.dart';

class KehadiranPage extends StatefulWidget {
  const KehadiranPage({super.key});

  @override
  State<KehadiranPage> createState() => _KehadiranPageState();
}

class _KehadiranPageState extends State<KehadiranPage> {
  final DataStore _store = DataStore();
  PosyanduSchedule? _selectedSchedule;
  final List<String> _tempAttendedIds = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (_store.schedules.isNotEmpty) {
      _selectedSchedule = _store.schedules.first;
      _tempAttendedIds.addAll(_store.getAttendance(_selectedSchedule!.id));
    }
  }

  void _onScheduleChanged(PosyanduSchedule? schedule) {
    if (schedule == null) return;
    setState(() {
      _selectedSchedule = schedule;
      _tempAttendedIds.clear();
      _tempAttendedIds.addAll(_store.getAttendance(schedule.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = DataStore().isDarkMode;
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
          'Kehadiran Posyandu',
          style: TextStyle(color: Color(0xFF27A1A6), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Container(
        decoration: AppTheme.getBgDecoration(context),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            // Schedule Selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Jadwal Posyandu',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF27A1A6), fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<PosyanduSchedule>(
                    value: _selectedSchedule,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.getCardColor(context),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                    items: _store.schedules.map((PosyanduSchedule val) {
                      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
                      final dateStr = '${val.date.day} ${months[val.date.month - 1]} ${val.date.year}';
                      return DropdownMenuItem<PosyanduSchedule>(
                        value: val,
                        child: Text('${val.name} ($dateStr)'),
                      );
                    }).toList(),
                    onChanged: _onScheduleChanged,
                  ),
                ],
              ),
            ),
  
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.getCardColor(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  style: TextStyle(color: AppTheme.getTextColor(context)),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    hintText: 'Cari nama lansia...',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
  
            // Members list
            Expanded(
              child: _selectedSchedule == null
                  ? Center(child: Text('Belum ada jadwal posyandu', style: TextStyle(color: AppTheme.getTextColor(context).withOpacity(0.6))))
                  : AnimatedBuilder(
                      animation: _store,
                      builder: (context, child) {
                        final list = _store.lansiaMembers.where((m) {
                          return m.name.toLowerCase().contains(_searchQuery.toLowerCase());
                        }).toList();
  
                        if (list.isEmpty) {
                          return Center(
                            child: Text('Nama tidak ditemukan', style: TextStyle(color: AppTheme.getTextColor(context).withOpacity(0.6))),
                          );
                        }
  
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          itemCount: list.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final member = list[index];
                            final isAttended = _tempAttendedIds.contains(member.id);
  
                            return Container(
                              decoration: BoxDecoration(
                                color: AppTheme.getCardColor(context),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              ),
                              child: CheckboxListTile(
                                activeColor: const Color(0xFF27A1A6),
                                checkColor: Colors.white,
                                title: Text(
                                  member.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF27A1A6)),
                                ),
                                subtitle: Text(
                                  '${member.age} Tahun • ${member.gender}',
                                  style: TextStyle(color: AppTheme.getTextColor(context).withOpacity(0.6), fontSize: 12),
                                ),
                                value: isAttended,
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked == true) {
                                      _tempAttendedIds.add(member.id);
                                    } else {
                                      _tempAttendedIds.remove(member.id);
                                    }
                                  });
                                },
                                secondary: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBF4F5).withOpacity(isDark ? 0.2 : 1.0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.person, color: Color(0xFF27A1A6), size: 22),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
  
            // Save button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _selectedSchedule == null
                      ? null
                      : () {
                          _store.setAttendance(_selectedSchedule!.id, List.from(_tempAttendedIds));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Daftar kehadiran berhasil disimpan!')),
                          );
                          Navigator.pop(context);
                        },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text('Simpan Kehadiran', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27A1A6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



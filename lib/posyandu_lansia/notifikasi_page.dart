import 'package:flutter/material.dart';
import 'data_store.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DataStore _store = DataStore();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationItem> _getFilteredNotifications(String tabName) {
    if (tabName == 'Pengingat') {
      return _store.notifications.where((n) => n.type == 'Pengingat').toList();
    } else if (tabName == 'Informasi') {
      return _store.notifications.where((n) => n.type == 'Informasi').toList();
    }
    return _store.notifications; // 'Semua'
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
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF0F5A5C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0F5A5C),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF0F5A5C),
          indicatorWeight: 3.0,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Pengingat'),
            Tab(text: 'Informasi'),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: _store,
        builder: (context, child) {
          final activeTabLabel = ['Semua', 'Pengingat', 'Informasi'][_tabController.index];
          final items = _getFilteredNotifications(activeTabLabel);

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text(
                    'Tidak ada notifikasi',
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  )
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notif = items[index];
              IconData iconData = Icons.info_outline;
              Color iconBg = const Color(0xFFE8F5E9);
              Color iconColor = const Color(0xFF22B573);

              if (notif.title.contains('Obat')) {
                iconData = Icons.medication_outlined;
                iconBg = const Color(0xFFE3F2FD);
                iconColor = Colors.blue;
              } else if (notif.title.contains('Posyandu')) {
                iconData = Icons.calendar_month_outlined;
                iconBg = const Color(0xFFE0F2F1);
                iconColor = const Color(0xFF0F5A5C);
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notif Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(iconData, color: iconColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    // Notif Text Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notif.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF0F5A5C),
                                ),
                              ),
                              Text(
                                notif.timeLabel,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            notif.body,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

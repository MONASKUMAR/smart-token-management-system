import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  final _searchController = TextEditingController();
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    final tokens = state.todayTokens;
    final total = tokens.length;
    final completed = tokens.where((t) => t['status'] == 'Completed').length;
    final skipped = tokens.where((t) => t['status'] == 'Skipped').length;
    final manual = tokens.where((t) => t['source'] == 'Manual').length;
    final online = tokens.where((t) => t['source'] == 'Online').length;

    // Calculate service type distribution
    final serviceDistribution = <String, int>{};
    for (final t in tokens) {
      final type = t['service_type'] ?? 'General Service';
      serviceDistribution[type] = (serviceDistribution[type] ?? 0) + 1;
    }

    // Filter list for table view
    final query = _searchController.text.trim().toLowerCase();
    final filteredTokens = tokens.where((t) {
      final name = (t['customer_name'] ?? '').toString().toLowerCase();
      final num = t['token_number'].toString();
      final phone = (t['phone_number'] ?? '').toString();
      final status = (t['status'] ?? '').toString().toLowerCase();
      return name.contains(query) || num.contains(query) || phone.contains(query) || status.contains(query);
    }).toList();

    Widget buildDistributionBar(String title, int count, Color color) {
      final percent = total > 0 ? (count / total) : 0.0;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                Text('$count (${(percent * 100).toStringAsFixed(0)}%)',
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: const Color(0xFF0F172A),
                color: color,
                minHeight: 8,
              ),
            )
          ],
        ),
      );
    }

    Widget buildAnalyticSummary() {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Distribution',
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            buildDistributionBar('General Service', serviceDistribution['General Service'] ?? 0, const Color(0xFF6366F1)),
            buildDistributionBar('Consultation', serviceDistribution['Consultation'] ?? 0, Colors.amber),
            buildDistributionBar('Enquiry', serviceDistribution['Enquiry'] ?? 0, Colors.cyan),
            buildDistributionBar('Premium Service', serviceDistribution['Premium Service'] ?? 0, Colors.deepOrangeAccent),
          ],
        ),
      );
    }

    Widget buildMetricIndicator(String title, String val, IconData icon, Color color) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 12),
              Text(title, style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 4),
              Text(val, style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
    }

    Widget buildMetricOverview() {
      return Column(
        children: [
          Row(
            children: [
              buildMetricIndicator('Total Tickets', '$total', Icons.confirmation_num_outlined, Colors.blue),
              const SizedBox(width: 12),
              buildMetricIndicator('Completed Today', '$completed', Icons.check_circle_outline, Colors.green),
              const SizedBox(width: 12),
              buildMetricIndicator('Skipped Tokens', '$skipped', Icons.forward_to_inbox, Colors.amber),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              buildMetricIndicator('Walk-In Clients', '$manual', Icons.person_outline, Colors.deepOrangeAccent),
              const SizedBox(width: 12),
              buildMetricIndicator('Online Bookings', '$online', Icons.language, Colors.cyan),
            ],
          ),
        ],
      );
    }

    Widget buildLogsTable() {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ticket History Log',
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.white60, size: 18),
                        hintText: 'Search log...',
                        hintStyle: const TextStyle(color: Colors.white30),
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
            ),
            if (filteredTokens.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: Text('No historical logs match search queries.', style: GoogleFonts.inter(color: Colors.white30)),
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(const Color(0xFF0F172A).withOpacity(0.5)),
                  columns: [
                    DataColumn(label: Text('Token', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Customer Name', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Phone', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Service', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Source', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Status', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('Time Generated', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold))),
                  ],
                  rows: filteredTokens.map((t) {
                    final num = t['token_number'];
                    final name = t['customer_name'] ?? 'Walk-In';
                    final phone = t['phone_number'] ?? '-';
                    final service = t['service_type'] ?? '-';
                    final source = t['source'] ?? '-';
                    final status = t['status'] ?? 'Waiting';
                    final created = DateTime.tryParse(t['created_at']?.toString() ?? '')?.toLocal();
                    final timeStr = created != null
                        ? "${created.hour.toString().padLeft(2, '0')}:${created.minute.toString().padLeft(2, '0')}"
                        : '-';

                    Color statusColor = Colors.amber;
                    if (status == 'Completed') {
                      statusColor = Colors.green;
                    } else if (status == 'Skipped') {
                      statusColor = Colors.redAccent;
                    } else if (status == 'Serving') {
                      statusColor = const Color(0xFF818CF8);
                    }

                    return DataRow(
                      cells: [
                        DataCell(Text('#$num', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold))),
                        DataCell(Text(name, style: GoogleFonts.inter(color: Colors.white70))),
                        DataCell(Text(phone, style: GoogleFonts.inter(color: Colors.white60))),
                        DataCell(Text(service, style: GoogleFonts.inter(color: Colors.white60))),
                        DataCell(Text(source, style: GoogleFonts.inter(color: Colors.white60))),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                            child: Text(status, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        DataCell(Text(timeStr, style: GoogleFonts.inter(color: Colors.white30))),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reports & Analytics',
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Statistical summaries and customer logs compiled today.',
                  style: GoogleFonts.inter(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: buildMetricOverview()),
                  const SizedBox(width: 24),
                  Expanded(flex: 7, child: buildAnalyticSummary()),
                ],
              )
            else ...[
              buildMetricOverview(),
              const SizedBox(height: 24),
              buildAnalyticSummary(),
            ],
            const SizedBox(height: 24),
            buildLogsTable(),
          ],
        ),
      ),
    );
  }
}

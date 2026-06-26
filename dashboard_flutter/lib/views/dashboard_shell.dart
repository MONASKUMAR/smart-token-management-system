import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state.dart';
import 'queue_console_view.dart';
import 'waitlist_view.dart';
import 'reports_view.dart';
import 'settings_view.dart';
import 'tv_monitor_view.dart';
import 'kiosk_registration_view.dart';

class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  final List<Widget> _views = [
    const QueueConsoleView(),
    const WaitlistView(),
    const ReportsView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    
    final orgName = state.settings['Organization Name'] ?? 'Smart Token System';

    // Sidebar Items definition
    final menuItems = [
      _SidebarItem(icon: Icons.dashboard_outlined, label: 'Dashboard Console'),
      _SidebarItem(icon: Icons.format_list_numbered, label: 'Waiting Waitlist'),
      _SidebarItem(icon: Icons.bar_chart_rounded, label: 'Reports & Logs'),
      _SidebarItem(icon: Icons.settings_suggest_outlined, label: 'System Settings'),
    ];

    final logoBase64 = state.settings['Organization Logo'] ?? '';

    Widget sidebarHeader = Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: _isSidebarCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (logoBase64.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(2),
                color: Colors.white,
                child: Image.memory(
                  base64Decode(logoBase64.split(',')[1]),
                  height: 32,
                  width: 32,
                  fit: BoxFit.contain,
                ),
              ),
            )
          else
            const Icon(Icons.layers, color: Color(0xFF818CF8), size: 32),
          if (!_isSidebarCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Token System',
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    Widget buildSidebar() {
      return Container(
        width: _isSidebarCollapsed ? 80 : 260,
        height: double.infinity,
        color: const Color(0xFF0F172A),
        child: Column(
          children: [
            sidebarHeader,
            const Divider(color: Color(0xFF1E293B), height: 1),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final isSelected = _selectedIndex == index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF6366F1).withOpacity(0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? Border.all(color: const Color(0xFF6366F1).withOpacity(0.3))
                              : Border.all(color: Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: _isSidebarCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                          children: [
                            Icon(
                              item.icon,
                              color: isSelected ? const Color(0xFF818CF8) : Colors.white60,
                              size: 22,
                            ),
                            if (!_isSidebarCollapsed) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: GoogleFonts.inter(
                                    color: isSelected ? Colors.white : Colors.white60,
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Color(0xFF1E293B), height: 1),
            // Extra screens shortcuts
            if (!_isSidebarCollapsed) ...[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.tv, color: Colors.amberAccent, size: 18),
                      title: Text('TV Monitor View', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TvMonitorView())),
                    ),
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.tablet_android, color: Colors.tealAccent, size: 18),
                      title: Text('Kiosk Mode', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KioskRegistrationView())),
                    ),
                  ],
                ),
              ),
            ],
            // Logout segment
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => state.logout(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, color: Colors.redAccent, size: 18),
                      if (!_isSidebarCollapsed) ...[
                        const SizedBox(width: 10),
                        Text(
                          'Sign Out',
                          style: GoogleFonts.inter(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      drawer: isMobile
          ? Drawer(
              backgroundColor: const Color(0xFF0F172A),
              child: Column(
                children: [
                  sidebarHeader,
                  const Divider(color: Color(0xFF1E293B)),
                  Expanded(
                    child: ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        final isSelected = _selectedIndex == index;
                        return ListTile(
                          selected: isSelected,
                          selectedColor: const Color(0xFF818CF8),
                          leading: Icon(item.icon, color: isSelected ? const Color(0xFF818CF8) : Colors.white60),
                          title: Text(item.label, style: GoogleFonts.inter(color: isSelected ? Colors.white : Colors.white60)),
                          onTap: () {
                            setState(() => _selectedIndex = index);
                            Navigator.pop(context); // close drawer
                          },
                        );
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.tv, color: Colors.amberAccent),
                    title: Text('TV Monitor View', style: GoogleFonts.inter(color: Colors.white70)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TvMonitorView())),
                  ),
                  ListTile(
                    leading: const Icon(Icons.tablet_android, color: Colors.tealAccent),
                    title: Text('Kiosk Mode', style: GoogleFonts.inter(color: Colors.white70)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KioskRegistrationView())),
                  ),
                  const Divider(color: Color(0xFF1E293B)),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: Text('Logout', style: GoogleFonts.inter(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    onTap: () => state.logout(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) buildSidebar(),
          Expanded(
            child: Column(
              children: [
                // Top Navbar
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    border: Border(bottom: BorderSide(color: Color(0xFF334155), width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Collapse Sidebar trigger
                      Row(
                        children: [
                          if (isMobile)
                            Builder(
                              builder: (context) => IconButton(
                                icon: const Icon(Icons.menu, color: Colors.white),
                                onPressed: () => Scaffold.of(context).openDrawer(),
                              ),
                            )
                          else
                            IconButton(
                              icon: Icon(
                                _isSidebarCollapsed ? Icons.menu_open : Icons.menu,
                                color: Colors.white,
                              ),
                              onPressed: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                            ),
                          const SizedBox(width: 12),
                          Text(
                            orgName,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      // API Connection status indicators
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'System Live',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF10B981),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                
                // Active Screen View Workspace
                Expanded(
                  child: Container(
                    color: const Color(0xFF0F172A),
                    child: _views[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;
  _SidebarItem({required this.icon, required this.label});
}

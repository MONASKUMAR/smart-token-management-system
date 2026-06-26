import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/app_state.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // Core controllers
  final _startingTokenController = TextEditingController();
  final _avgServiceTimeController = TextEditingController();
  final _orgNameController = TextEditingController();
  bool _enableBuzzer = true;

  // Printer controllers
  String _printerConnection = 'wire';
  String _selectedPrinterMac = '';
  List<Map<String, dynamic>> _discoveredPrinters = [];
  bool _isBluetoothScanning = false;

  // Theme & Logo
  final _primaryColorController = TextEditingController();
  final _bgColorController = TextEditingController();
  String _base64Logo = '';
  bool _isSavingTheme = false;

  // TTS configurations
  final _voiceTemplateController = TextEditingController();
  String _selectedVoiceLang = 'en-US';
  bool _isSavingTts = false;

  // Token features validations
  bool _requireCustomerName = false;
  bool _requireCustomerPhone = false;
  List<String> _serviceCategories = [];
  final _newServiceController = TextEditingController();
  bool _isSavingFeatures = false;

  // Credential controllers
  final _adminUsernameController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  
  // Email Provider controllers
  String _emailProvider = 'demo';
  final _resendApiKeyController = TextEditingController();
  final _resendSenderController = TextEditingController();
  final _smtpHostController = TextEditingController();
  final _smtpPortController = TextEditingController();
  final _smtpUsernameController = TextEditingController();
  final _smtpPasswordController = TextEditingController();
  final _smtpSenderController = TextEditingController();
  bool _smtpSsl = false;

  bool _isSavingCore = false;
  bool _isSavingCreds = false;
  bool _isSavingEmail = false;

  @override
  void initState() {
    super.initState();
    // Load initial values from AppState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<AppState>(context, listen: false);
      final s = state.settings;

      _startingTokenController.text = s['Starting Token Number'] ?? '100';
      _avgServiceTimeController.text = s['Average Service Time'] ?? '10';
      _orgNameController.text = s['Organization Name'] ?? 'Smart Token Management System';
      _enableBuzzer = (s['Enable Buzzer'] ?? 'true') == 'true';

      // Load printer settings
      try {
        final printerString = s['Thermal Printer Settings'] ?? '{}';
        final Map<String, dynamic> printerConfig = jsonDecode(printerString);
        _printerConnection = printerConfig['connection'] ?? 'wire';
        _selectedPrinterMac = printerConfig['device'] ?? '';
      } catch (_) {}

      // Load scanned printers list if any
      try {
        final listJson = s['Scanned Bluetooth Printers'] ?? '[]';
        final list = jsonDecode(listJson);
        if (list is List) {
          _discoveredPrinters = List<Map<String, dynamic>>.from(list);
        }
      } catch (_) {}

      // Brand Logo & Colors
      _base64Logo = s['Organization Logo'] ?? '';
      _primaryColorController.text = s['Theme Primary Color'] ?? '#6366F1';
      _bgColorController.text = s['Theme Background Color'] ?? '#0F172A';

      // TTS configurations
      _voiceTemplateController.text = s['Voice Announcement Template'] ?? 'Token number {token}, please proceed to counter.';
      _selectedVoiceLang = s['Voice Language'] ?? 'en-US';

      // Token features validations
      _requireCustomerName = (s['Require Customer Name'] ?? 'false') == 'true';
      _requireCustomerPhone = (s['Require Customer Phone'] ?? 'false') == 'true';
      
      try {
        final serviceJson = s['Queue Service Categories'] ?? '[]';
        final decoded = jsonDecode(serviceJson);
        if (decoded is List) {
          _serviceCategories = List<String>.from(decoded);
        } else {
          _serviceCategories = ['General Service', 'Consultation', 'Enquiry', 'Premium Service'];
        }
      } catch (_) {
        _serviceCategories = ['General Service', 'Consultation', 'Enquiry', 'Premium Service'];
      }

      // Credentials
      _adminUsernameController.text = s['Admin Username'] ?? 'admin';
      _adminEmailController.text = s['Admin Email'] ?? 'admin@example.com';
      _adminPasswordController.text = s['Admin Password'] ?? 'admin123';

      // Email Dispatcher Config
      try {
        final configString = s['Email Service Config'] ?? '{}';
        final Map<String, dynamic> config = jsonDecode(configString);
        _emailProvider = config['provider'] ?? 'demo';
        _resendApiKeyController.text = config['resend_api_key'] ?? '';
        _resendSenderController.text = config['resend_sender'] ?? 'onboarding@resend.dev';
        _smtpHostController.text = config['smtp_host'] ?? '';
        _smtpPortController.text = config['smtp_port']?.toString() ?? '587';
        _smtpUsernameController.text = config['smtp_username'] ?? '';
        _smtpPasswordController.text = config['smtp_password'] ?? '';
        _smtpSenderController.text = config['smtp_sender'] ?? 'noreply@yourdomain.com';
        _smtpSsl = config['smtp_ssl'] ?? false;
      } catch (_) {}

      setState(() {});
    });
  }

  @override
  void dispose() {
    _startingTokenController.dispose();
    _avgServiceTimeController.dispose();
    _orgNameController.dispose();
    _primaryColorController.dispose();
    _bgColorController.dispose();
    _voiceTemplateController.dispose();
    _newServiceController.dispose();
    _adminUsernameController.dispose();
    _adminEmailController.dispose();
    _adminPasswordController.dispose();
    _resendApiKeyController.dispose();
    _resendSenderController.dispose();
    _smtpHostController.dispose();
    _smtpPortController.dispose();
    _smtpUsernameController.dispose();
    _smtpPasswordController.dispose();
    _smtpSenderController.dispose();
    super.dispose();
  }

  Future<void> _pickLogoImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final base64String = base64Encode(bytes);
        final extension = result.files.single.extension ?? 'png';
        
        setState(() {
          _base64Logo = 'data:image/$extension;base64,$base64String';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select file: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _saveThemeSettings(AppState state) async {
    setState(() => _isSavingTheme = true);
    try {
      await state.saveSettings({
        'Organization Logo': _base64Logo,
        'Theme Primary Color': _primaryColorController.text.trim(),
        'Theme Background Color': _bgColorController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Theme and brand configurations updated!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingTheme = false);
    }
  }

  Future<void> _saveTtsSettings(AppState state) async {
    setState(() => _isSavingTts = true);
    try {
      await state.saveSettings({
        'Voice Announcement Template': _voiceTemplateController.text.trim(),
        'Voice Language': _selectedVoiceLang,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vocal speech template saved!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingTts = false);
    }
  }

  Future<void> _saveFeatureSettings(AppState state) async {
    if (_serviceCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one queue service category.'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isSavingFeatures = true);
    try {
      await state.saveSettings({
        'Require Customer Name': _requireCustomerName ? 'true' : 'false',
        'Require Customer Phone': _requireCustomerPhone ? 'true' : 'false',
        'Queue Service Categories': jsonEncode(_serviceCategories),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Feature and field validator rules updated!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingFeatures = false);
    }
  }

  Future<void> _saveCoreSettings(AppState state) async {
    setState(() => _isSavingCore = true);
    try {
      final printerSettings = jsonEncode({
        'connection': _printerConnection,
        'device': _selectedPrinterMac,
      });

      await state.saveSettings({
        'Starting Token Number': _startingTokenController.text.trim(),
        'Average Service Time': _avgServiceTimeController.text.trim(),
        'Organization Name': _orgNameController.text.trim(),
        'Enable Buzzer': _enableBuzzer ? 'true' : 'false',
        'Thermal Printer Settings': printerSettings,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Core system parameters updated!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingCore = false);
    }
  }

  Future<void> _triggerBluetoothScan(AppState state) async {
    setState(() {
      _isBluetoothScanning = true;
      _discoveredPrinters = [];
    });

    try {
      final list = await state.triggerBluetoothPrinterScan();
      setState(() {
        _discoveredPrinters = list;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Discovered ${list.length} Bluetooth devices.'), backgroundColor: Colors.indigo),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bluetooth scan failed: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isBluetoothScanning = false);
    }
  }

  Future<void> _saveCredentials(AppState state) async {
    setState(() => _isSavingCreds = true);
    try {
      await state.saveSettings({
        'Admin Username': _adminUsernameController.text.trim(),
        'Admin Email': _adminEmailController.text.trim(),
        'Admin Password': _adminPasswordController.text,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin credentials updated successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update credentials: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingCreds = false);
    }
  }

  Future<void> _saveEmailSettings(AppState state) async {
    setState(() => _isSavingEmail = true);
    try {
      final configJson = jsonEncode({
        'provider': _emailProvider,
        'resend_api_key': _resendApiKeyController.text,
        'resend_sender': _resendSenderController.text.trim(),
        'smtp_host': _smtpHostController.text.trim(),
        'smtp_port': int.tryParse(_smtpPortController.text) ?? 587,
        'smtp_username': _smtpUsernameController.text.trim(),
        'smtp_password': _smtpPasswordController.text,
        'smtp_sender': _smtpSenderController.text.trim(),
        'smtp_ssl': _smtpSsl,
      });

      await state.saveSettings({'Email Service Config': configJson});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email notification service saved!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isSavingEmail = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    Widget buildPanelWrapper(String title, List<Widget> children) {
      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(color: Color(0xFF334155), height: 32),
            ...children,
          ],
        ),
      );
    }

    Widget buildCoreSettingsPanel() {
      return buildPanelWrapper(
        'Queue Parameters & General Settings',
        [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _startingTokenController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Starting Token Number',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: TextField(
                  controller: _avgServiceTimeController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Average Service Time (mins)',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _orgNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Organization Name',
              labelStyle: TextStyle(color: Colors.white60),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Audio Buzz Announcement', style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  Text('Play chime sound at consoles when calling tokens.', style: GoogleFonts.inter(color: Colors.white60, fontSize: 12)),
                ],
              ),
              Switch(
                value: _enableBuzzer,
                activeColor: const Color(0xFF818CF8),
                onChanged: (val) => setState(() => _enableBuzzer = val),
              )
            ],
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _printerConnection,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Thermal Ticket Printer Interface',
              labelStyle: TextStyle(color: Colors.white60),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
            ),
            items: const [
              DropdownMenuItem(value: 'wire', child: Text('USB Serial Port Connection')),
              DropdownMenuItem(value: 'bluetooth', child: Text('Bluetooth Wireless SPP Connection')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _printerConnection = val);
            },
          ),
          if (_printerConnection == 'bluetooth') ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedPrinterMac.isEmpty ? null : _selectedPrinterMac,
                    dropdownColor: const Color(0xFF1E293B),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Select Discovered Printer',
                      labelStyle: TextStyle(color: Colors.white60),
                    ),
                    items: [
                      const DropdownMenuItem(value: '', child: Text('-- No Devices Discovered --')),
                      ..._discoveredPrinters.map((p) {
                        final address = p['address'] ?? '';
                        final name = p['name'] ?? 'Unknown Device';
                        return DropdownMenuItem(value: address, child: Text('$name ($address)'));
                      })
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedPrinterMac = val);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isBluetoothScanning ? null : () => _triggerBluetoothScan(state),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                  child: _isBluetoothScanning
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Scan Devices'),
                )
              ],
            )
          ],
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isSavingCore ? null : () => _saveCoreSettings(state),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
              child: _isSavingCore
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Save General Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      );
    }

    Widget buildThemeSettingsPanel() {
      return buildPanelWrapper(
        'Theme & Layout Customization',
        [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _primaryColorController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Primary Accent Color',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: TextField(
                  controller: _bgColorController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Background Color',
                    labelStyle: TextStyle(color: Colors.white60),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _pickLogoImage,
                icon: const Icon(Icons.photo_library),
                label: const Text('Upload Brand Logo (Photo)'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF475569)),
              ),
              const SizedBox(width: 24),
              if (_base64Logo.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    color: Colors.white,
                    child: Image.memory(
                      base64Decode(_base64Logo.split(',')[1]),
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => setState(() => _base64Logo = ''),
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  tooltip: 'Remove logo',
                )
              ] else
                const Text('No Logo Uploaded', style: TextStyle(color: Colors.white38, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isSavingTheme ? null : () => _saveThemeSettings(state),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
              child: _isSavingTheme
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Save Theme Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      );
    }

    Widget buildTtsSettingsPanel() {
      return buildPanelWrapper(
        'Vocal Announcement (TTS)',
        [
          TextField(
            controller: _voiceTemplateController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Lobby Speech Template',
              labelStyle: TextStyle(color: Colors.white60),
              helperText: 'Use {token} for token number and {service_type} for service.',
              helperStyle: TextStyle(color: Colors.white30),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedVoiceLang,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Speech Language',
              labelStyle: TextStyle(color: Colors.white60),
            ),
            items: const [
              DropdownMenuItem(value: 'en-US', child: Text('English (United States)')),
              DropdownMenuItem(value: 'en-GB', child: Text('English (United Kingdom)')),
              DropdownMenuItem(value: 'hi-IN', child: Text('Hindi (India)')),
              DropdownMenuItem(value: 'es-ES', child: Text('Spanish (Spain)')),
              DropdownMenuItem(value: 'fr-FR', child: Text('French (France)')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedVoiceLang = val);
            },
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isSavingTts ? null : () => _saveTtsSettings(state),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
              child: _isSavingTts
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Save Speech Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      );
    }

    Widget buildTokenFeaturesPanel() {
      return buildPanelWrapper(
        'Token Form & Queue Features',
        [
          SwitchListTile(
            title: const Text('Require customer name on registration', style: TextStyle(color: Colors.white, fontSize: 14)),
            value: _requireCustomerName,
            activeColor: const Color(0xFF818CF8),
            onChanged: (val) => setState(() => _requireCustomerName = val),
          ),
          SwitchListTile(
            title: const Text('Require customer phone number on registration', style: TextStyle(color: Colors.white, fontSize: 14)),
            value: _requireCustomerPhone,
            activeColor: const Color(0xFF818CF8),
            onChanged: (val) => setState(() => _requireCustomerPhone = val),
          ),
          const SizedBox(height: 20),
          const Text('Manage Available Queue Services', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _newServiceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Add New Category',
                    labelStyle: TextStyle(color: Colors.white38),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  final text = _newServiceController.text.trim();
                  if (text.isNotEmpty && !_serviceCategories.contains(text)) {
                    setState(() {
                      _serviceCategories.add(text);
                      _newServiceController.clear();
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                child: const Text('Add'),
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: _serviceCategories.isEmpty
                ? const Center(child: Text('No active service categories.', style: TextStyle(color: Colors.white38)))
                : ListView.builder(
                    itemCount: _serviceCategories.length,
                    itemBuilder: (context, index) {
                      final item = _serviceCategories[index];
                      return ListTile(
                        title: Text(item, style: const TextStyle(color: Colors.white, fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () => setState(() => _serviceCategories.removeAt(index)),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isSavingFeatures ? null : () => _saveFeatureSettings(state),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
              child: _isSavingFeatures
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Save Feature Rules', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      );
    }

    Widget buildCredentialsPanel() {
      return buildPanelWrapper(
        'Admin Username & Recovery Account Settings',
        [
          TextField(
            controller: _adminUsernameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Admin Login Username',
              labelStyle: TextStyle(color: Colors.white60),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _adminEmailController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'OTP Recovery Email Address',
              labelStyle: TextStyle(color: Colors.white60),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _adminPasswordController,
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Admin Password',
              labelStyle: TextStyle(color: Colors.white60),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
            ),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isSavingCreds ? null : () => _saveCredentials(state),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
              child: _isSavingCreds
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Save Account Details', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      );
    }

    Widget buildEmailDispatcherPanel() {
      return buildPanelWrapper(
        'Forgot Password Notification Service Settings',
        [
          DropdownButtonFormField<String>(
            value: _emailProvider,
            dropdownColor: const Color(0xFF1E293B),
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'OTP Dispatcher Provider',
              labelStyle: TextStyle(color: Colors.white60),
            ),
            items: const [
              DropdownMenuItem(value: 'demo', child: Text('Console Mode (Log/Debug Print Only)')),
              DropdownMenuItem(value: 'resend', child: Text('Resend email API Gateway')),
              DropdownMenuItem(value: 'smtp', child: Text('SMTP Server Connection')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _emailProvider = val);
            },
          ),
          const SizedBox(height: 20),
          if (_emailProvider == 'resend') ...[
            TextField(
              controller: _resendApiKeyController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Resend API Authorization Key (re_...)',
                labelStyle: TextStyle(color: Colors.white60),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _resendSenderController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Sender Email Address (e.g. name@resend.dev)',
                labelStyle: TextStyle(color: Colors.white60),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF334155))),
              ),
            ),
          ] else if (_emailProvider == 'smtp') ...[
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _smtpHostController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'SMTP Server Hostname',
                      labelStyle: TextStyle(color: Colors.white60),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _smtpPortController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Port',
                      labelStyle: TextStyle(color: Colors.white60),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _smtpUsernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'SMTP Login Username',
                labelStyle: TextStyle(color: Colors.white60),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _smtpPasswordController,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'SMTP Login Password',
                labelStyle: TextStyle(color: Colors.white60),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _smtpSenderController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'SMTP Sender Email (From)',
                labelStyle: TextStyle(color: Colors.white60),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Force SSL Connection (Secure TLS)', style: TextStyle(color: Colors.white70, fontSize: 14)),
                Switch(
                  value: _smtpSsl,
                  activeColor: const Color(0xFF818CF8),
                  onChanged: (val) => setState(() => _smtpSsl = val),
                ),
              ],
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Text(
                'Demo Mode is selected. Reset OTP codes will print in your terminal logs directly. No setup required.',
                style: GoogleFonts.inter(color: Colors.blueAccent[100], fontSize: 13),
              ),
            ),
          ],
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _isSavingEmail ? null : () => _saveEmailSettings(state),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
              child: _isSavingEmail
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Save Notification Settings', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
            ),
          )
        ],
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
                  'System Settings',
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Customize token printer configurations, recovery notification gateways, and credentials.',
                  style: GoogleFonts.inter(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        buildCoreSettingsPanel(),
                        buildThemeSettingsPanel(),
                        buildTtsSettingsPanel(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      children: [
                        buildTokenFeaturesPanel(),
                        buildCredentialsPanel(),
                        buildEmailDispatcherPanel(),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              buildCoreSettingsPanel(),
              buildThemeSettingsPanel(),
              buildTtsSettingsPanel(),
              buildTokenFeaturesPanel(),
              buildCredentialsPanel(),
              buildEmailDispatcherPanel(),
            ],
          ],
        ),
      ),
    );
  }
}

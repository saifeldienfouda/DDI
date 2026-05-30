import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../utils/theme.dart';
import '../utils/localization.dart';
import '../utils/constants.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({Key? key}) : super(key: key);

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  File? _image;
  bool _extracting = false;
  List<String> _extractedDrugs = [];
  String? _error;
  
  String? _selectedDrugA;
  String? _selectedDrugB;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _extractedDrugs = [];
          _error = null;
          _selectedDrugA = null;
          _selectedDrugB = null;
        });
        
        // Immediately scan image upon selection
        _uploadImage(_image!);
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to select image: ${e.toString()}';
      });
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      _extracting = true;
      _error = null;
    });

    try {
      final uri = Uri.parse('${AppConstants.baseUrl}/scan-drugs');
      final request = http.MultipartRequest('POST', uri);
      
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      final streamedResponse = await request.send().timeout(const Duration(seconds: 25));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> results = data['results'] ?? [];
          setState(() {
            _extractedDrugs = results.map((e) => e.toString()).toList();
            _extracting = false;
            if (_extractedDrugs.isEmpty) {
              _error = context.translate('no_drugs_detected');
            }
          });
        } else {
          setState(() {
            _error = data['error'] ?? context.translate('no_drugs_detected');
            _extracting = false;
          });
        }
      } else {
        setState(() {
          _error = 'Server error: ${response.statusCode}';
          _extracting = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to upload and scan image: ${e.toString()}';
        _extracting = false;
      });
    }
  }

  void _assignDrug(String drugName, bool isDrugA) {
    setState(() {
      if (isDrugA) {
        _selectedDrugA = drugName;
        // If already assigned to B, clear from B
        if (_selectedDrugB == drugName) _selectedDrugB = null;
      } else {
        _selectedDrugB = drugName;
        // If already assigned to A, clear from A
        if (_selectedDrugA == drugName) _selectedDrugA = null;
      }
    });

    HapticFeedback.lightImpact();
    
    // Auto-show floating feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDrugA 
              ? '$drugName ${context.translate('drug_a_assigned')}'
              : '$drugName ${context.translate('drug_b_assigned')}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _applyAndReturn() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop({
      'drugA': _selectedDrugA ?? '',
      'drugB': _selectedDrugB ?? '',
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark ? AppTheme.darkGradientBg : AppTheme.lightGradientBg,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header Bar
              _buildHeaderBar(isDark),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      // Subtitle Instructions
                      Text(
                        context.translate('ocr_subtitle'),
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Image Scanner Box
                      _buildScannerBox(isDark),
                      const SizedBox(height: 24),

                      // Selection Buttons (when no image picked)
                      if (_image == null) _buildImageSelectors(isDark),

                      // Loading Scan Animation
                      if (_image != null && _extracting) _buildScanningProgressCard(isDark),

                      // OCR Results checklist
                      if (_image != null && !_extracting && _extractedDrugs.isNotEmpty)
                        _buildOcrResultsCard(isDark),

                      // OCR Error feedback
                      if (_error != null) _buildErrorCard(isDark),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar (Apply results)
              if (_selectedDrugA != null || _selectedDrugB != null)
                _buildBottomActionBar(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface.withOpacity(0.3) : AppTheme.lightSurface.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              context.isArabic ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Text(
            context.translate('ocr_title'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
            ),
          ),
          const Spacer(),
          if (_image != null)
            IconButton(
              icon: Icon(Icons.refresh_rounded, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
              tooltip: 'Reset',
              onPressed: () {
                setState(() {
                  _image = null;
                  _extractedDrugs = [];
                  _error = null;
                  _selectedDrugA = null;
                  _selectedDrugB = null;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildScannerBox(bool isDark) {
    final size = MediaQuery.of(context).size.width - 40;
    
    return Container(
      width: size,
      height: size * 0.75,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _image == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(isDark ? 0.15 : 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.indigo,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  context.translate('ocr_desc'),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                  ),
                ),
              ],
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                Image.file(_image!, fit: BoxFit.cover),
                // Glowing Scanning laser line
                if (_extracting) ScannerLaserAnimation(height: size * 0.75),
              ],
            ),
    );
  }

  Widget _buildImageSelectors(bool isDark) {
    return Column(
      children: [
        _buildPickerButton(
          icon: Icons.camera_alt_rounded,
          title: context.translate('take_photo'),
          color: Colors.indigo,
          onTap: () => _pickImage(ImageSource.camera),
          isDark: isDark,
        ),
        const SizedBox(height: 14),
        _buildPickerButton(
          icon: Icons.photo_library_rounded,
          title: context.translate('choose_gallery'),
          color: Colors.indigo,
          onTap: () => _pickImage(ImageSource.gallery),
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildPickerButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanningProgressCard(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.indigo),
          ),
          const SizedBox(height: 16),
          Text(
            context.translate('extracting_drugs'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOcrResultsCard(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medication_rounded, color: Colors.indigo, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.translate('select_extracted'),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _extractedDrugs.length,
            separatorBuilder: (_, __) => Divider(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder, height: 1),
            itemBuilder: (context, index) {
              final d = _extractedDrugs[index];
              final isSelectedA = _selectedDrugA == d;
              final isSelectedB = _selectedDrugB == d;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        d,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drug A button
                        InkWell(
                          onTap: () => _assignDrug(d, true),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelectedA 
                                  ? Colors.indigo 
                                  : (isDark ? Colors.indigo.withOpacity(0.1) : Colors.indigo.shade50),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.indigo),
                            ),
                            child: Text(
                              'A',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelectedA ? Colors.white : Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Drug B button
                        InkWell(
                          onTap: () => _assignDrug(d, false),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelectedB 
                                  ? Colors.indigo 
                                  : (isDark ? Colors.indigo.withOpacity(0.1) : Colors.indigo.shade50),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.indigo),
                            ),
                            child: Text(
                              'B',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelectedB ? Colors.white : Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D1F00) : const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _error!,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
        border: Border(
          top: BorderSide(color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current Selection Summary Indicators
          Row(
            children: [
              if (_selectedDrugA != null)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.indigo.withOpacity(0.1) : Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Drug A',
                          style: TextStyle(color: Colors.indigo, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedDrugA!,
                          style: TextStyle(
                            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              if (_selectedDrugB != null)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.indigo.withOpacity(0.1) : Colors.indigo.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Drug B',
                          style: TextStyle(color: Colors.indigo, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedDrugB!,
                          style: TextStyle(
                            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _applyAndReturn,
              icon: const Icon(Icons.check_circle_rounded),
              label: Text(
                context.isArabic ? 'تطبيق التغييرات والرجوع' : 'Apply & Analyze',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerLaserAnimation extends StatefulWidget {
  final double height;
  
  const ScannerLaserAnimation({Key? key, required this.height}) : super(key: key);

  @override
  State<ScannerLaserAnimation> createState() => _ScannerLaserAnimationState();
}

class _ScannerLaserAnimationState extends State<ScannerLaserAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.05, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final top = _animation.value * widget.height;
        return Positioned(
          top: top,
          left: 10,
          right: 10,
          child: Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.greenAccent,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.8),
                  blurRadius: 12,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

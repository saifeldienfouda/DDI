import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../utils/theme.dart';
import '../providers/interaction_provider.dart';

typedef DrugSelectedCallback = void Function(String drugName);

class DrugSearchField extends StatefulWidget {
  final String label;
  final String initialValue;
  final DrugSelectedCallback onDrugSelected;

  const DrugSearchField({Key? key, required this.label, this.initialValue = '', required this.onDrugSelected}) : super(key: key);

  @override
  State<DrugSearchField> createState() => _DrugSearchFieldState();
}

class _DrugSearchFieldState extends State<DrugSearchField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  Timer? _debounce;
  List<String> _suggestions = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
    _focusNode.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant DrugSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  void _handleFocus() {
    if (!_focusNode.hasFocus) {
      _removeOverlay();
    } else if (_controller.text.trim().length >= 2 && _suggestions.isNotEmpty) {
      _showOverlay();
    }
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      final q = value.trim();
      if (q.length < 2) {
        setState(() {
          _suggestions = [];
          _loading = false;
        });
        _removeOverlay();
        return;
      }

      setState(() => _loading = true);
      try {
        final results = await ApiService.instance.searchDrugs(q);
        if (mounted) {
          // Update server health status to online since drug search succeeded
          Provider.of<InteractionProvider>(context, listen: false).setServerOnline(true);
          setState(() {
            _suggestions = results;
            _loading = false;
          });
          _showOverlay();
        }
      } catch (_) {
        if (mounted) setState(() => _loading = false);
      }
    });
  }

  void _showOverlay() {
    _overlayEntry?.remove();
  _overlayEntry = _createOverlay();
  Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 8),
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 260),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: _suggestions.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                      itemBuilder: (context, index) {
                        final s = _suggestions[index];
                        return InkWell(
                          splashColor: isDark ? AppTheme.darkBorder : AppTheme.lightSurfaceVariant,
                          highlightColor: isDark ? AppTheme.darkBorder : AppTheme.lightSurfaceVariant,
                          onTap: () {
                            _controller.text = s;
                            widget.onDrugSelected(s);
                            _removeOverlay();
                            _focusNode.unfocus();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.blue.withOpacity(0.15) : Colors.blue.shade50,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.medication, color: Colors.blue, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s, 
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Drug class: NSAID', 
                                        style: TextStyle(
                                          color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary, 
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.chevron_right, color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    _controller.dispose();
    _focusNode.removeListener(_handleFocus);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label, 
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _onChanged,
            style: TextStyle(color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: widget.label,
              hintStyle: TextStyle(color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted),
              filled: true,
              fillColor: isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurfaceVariant,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: Icon(Icons.medication_outlined, color: Colors.blue),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 44),
              suffixIcon: _loading
                  ? const Padding(padding: EdgeInsets.all(12.0), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)))
                  : (_controller.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                          onPressed: () {
                            _controller.clear();
                            widget.onDrugSelected('');
                            setState(() => _suggestions = []);
                            _removeOverlay();
                          },
                        )
                      : Icon(Icons.search, color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            ),
            onSubmitted: (value) {
              widget.onDrugSelected(value.trim());
              _removeOverlay();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/interaction_result.dart';
import '../widgets/severity_badge.dart';
import '../utils/theme.dart';
import '../utils/localization.dart';
import '../utils/translation_helper.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseService();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? AppTheme.darkGradientBg
                : AppTheme.lightGradientBg,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                    Expanded(
                      child: Text(
                        context.translate('history_title'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                        ),
                      ),
                    ),
                    if (firebase.isSignedIn)
                      IconButton(
                        icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      context.translate('clear_history_title'),
                                      style: TextStyle(color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                context.translate('clear_history_desc'),
                                style: TextStyle(color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text(
                                    context.translate('cancel'),
                                    style: const TextStyle(color: AppTheme.primaryColor),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text(context.translate('clear_all_btn')),
                                ),
                              ],
                            ),
                          );
                          
                          if (confirmed == true) {
                            await firebase.clearHistory();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.translate('history_cleared_msg')),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          }
                        },
                      ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: firebase.isSignedIn
                    ? StreamBuilder<List<InteractionResult>>(
                        stream: firebase.getInteractionHistoryStream(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 64,
                                    color: Colors.red[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    context.isArabic ? 'خطأ في تحميل السجل' : 'Error loading history',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    snapshot.error.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          }

                          final history = snapshot.data ?? [];

                          if (history.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history_rounded,
                                    size: 64,
                                    color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    context.translate('no_history_checks'),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    context.translate('check_first_drug_desc'),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              final item = history[index];
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppTheme.darkSurfaceVariant : AppTheme.lightSurface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ResultScreen(result: item),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppTheme.gradientStart,
                                                AppTheme.gradientEnd,
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.medication_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.drugPair,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                TranslationHelper.translateDescription(
                                                  item.description,
                                                  item.drugPair,
                                                  context.isArabic,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            SeverityBadge(severity: item.severity),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppTheme.primaryColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '${item.riskScore.round()}%',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.primaryColor,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_off_rounded,
                              size: 64,
                              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              context.translate('sign_in_history_desc'),
                              style: TextStyle(
                                fontSize: 18,
                                color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              context.translate('cloud_history_desc'),
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

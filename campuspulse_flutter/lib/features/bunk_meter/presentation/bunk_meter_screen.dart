import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/bunk_math.dart';

/// Section 5.2: Bunk-Meter (Attendance Predictor)
class BunkMeterScreen extends StatefulWidget {
  const BunkMeterScreen({Key? key}) : super(key: key);

  @override
  State<BunkMeterScreen> createState() => _BunkMeterScreenState();
}

class _BunkMeterScreenState extends State<BunkMeterScreen> {
  final double _defaultRequired = 75.0;
  int _whatIfBunks = 0;

  final List<Map<String, dynamic>> _subjects = [
    {
      'id': 1,
      'name': 'Database Management Systems',
      'code': 'CS501',
      'attended': 26,
      'total': 30,
      'plannedTotal': 45,
    },
    {
      'id': 2,
      'name': 'Operating Systems',
      'code': 'CS502',
      'attended': 21,
      'total': 28,
      'plannedTotal': 42,
    },
    {
      'id': 3,
      'name': 'Design & Analysis of Algorithms',
      'code': 'CS503',
      'attended': 14,
      'total': 22,
      'plannedTotal': 40,
    },
    {
      'id': 4,
      'name': 'Computer Networks',
      'code': 'CS504',
      'attended': 19,
      'total': 20,
      'plannedTotal': 35,
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'green':
        return AppColors.attendanceSafe;
      case 'amber':
        return AppColors.attendanceWarning;
      case 'red':
      default:
        return AppColors.attendanceDanger;
    }
  }

  void _markAttendance(int index, bool isPresent) {
    setState(() {
      _subjects[index]['total'] = (_subjects[index]['total'] as int) + 1;
      if (isPresent) {
        _subjects[index]['attended'] = (_subjects[index]['attended'] as int) + 1;
      }
    });

    final sub = _subjects[index];
    final pct = BunkMath.currentPercentage(sub['attended'], sub['total']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Marked ${isPresent ? "Present ✓" : "Absent ✗"} in ${sub['code']}. New attendance: ${pct.toStringAsFixed(1)}%',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Overall Calculation
    int totalAttended = 0;
    int totalHeld = 0;
    for (final s in _subjects) {
      totalAttended += (s['attended'] as int);
      totalHeld += (s['total'] as int);
    }

    final overallPct = BunkMath.currentPercentage(totalAttended, totalHeld);
    final overallSafeBunks = BunkMath.safeBunks(totalAttended, totalHeld, _defaultRequired);
    final overallRecovery = BunkMath.recoveryClasses(totalAttended, totalHeld, _defaultRequired);
    final overallColor = _getStatusColor(BunkMath.statusColor(totalAttended, totalHeld, _defaultRequired));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bunk-Meter', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Attendance Policy (75% Rule)',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Bunk-Meter Formulas'),
                  content: const Text(
                    '• Safe Bunks: floor(Attended / 0.75 - Total)\n'
                    '• Recovery: ceil((75 * Total - 100 * Attended) / 25)\n'
                    '• Green: Safe (> 75%)\n'
                    '• Amber: Danger zone (within 1-2 classes of dropping below 75%)\n'
                    '• Red: Critical shortage (< 75%)',
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Got it')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Overall Prediction Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    overallColor.withOpacity(0.9),
                    overallColor.withOpacity(0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: overallColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'OVERALL ATTENDANCE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${overallPct.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            '$totalAttended attended / $totalHeld held',
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          overallPct >= 75.0 ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Safe Bunks', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            '$overallSafeBunks classes',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                        ],
                      ),
                      Container(height: 24, width: 1, color: Colors.white24),
                      Column(
                        children: [
                          const Text('Recovery Needed', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 2),
                          Text(
                            overallRecovery > 0 ? '$overallRecovery classes' : '0 (Safe)',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Interactive What-If Simulator Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'What-If Attendance Simulator',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'If I bunk $_whatIfBunks more class${_whatIfBunks == 1 ? "" : "es"}, my overall attendance becomes:',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${BunkMath.whatIfPercentage(totalAttended, totalHeld, _whatIfBunks).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: _getStatusColor(
                        BunkMath.statusColor(totalAttended, totalHeld + _whatIfBunks, _defaultRequired),
                      ),
                    ),
                  ),
                  Slider(
                    value: _whatIfBunks.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    activeColor: AppColors.primary,
                    label: '$_whatIfBunks classes',
                    onChanged: (val) {
                      setState(() {
                        _whatIfBunks = val.round();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Subject-wise Breakdown Header
            const Text(
              'Subject Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),

            // Subject Cards
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final sub = _subjects[index];
                final attended = sub['attended'] as int;
                final total = sub['total'] as int;
                final pct = BunkMath.currentPercentage(attended, total);
                final safe = BunkMath.safeBunks(attended, total, _defaultRequired);
                final recovery = BunkMath.recoveryClasses(attended, total, _defaultRequired);
                final color = _getStatusColor(BunkMath.statusColor(attended, total, _defaultRequired));

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sub['name'],
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${sub['code']} • $attended/$total classes held',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${pct.toStringAsFixed(1)}%',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (pct / 100.0).clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (safe > 0)
                            Text(
                              '✓ Can safely bunk $safe class${safe == 1 ? "" : "es"}',
                              style: const TextStyle(
                                color: AppColors.attendanceSafe,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else if (recovery > 0)
                            Text(
                              '⚠ Must attend next $recovery class${recovery == 1 ? "" : "es"} consecutively',
                              style: const TextStyle(
                                color: AppColors.attendanceDanger,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            const Text(
                              'On the edge (0 safe bunks)',
                              style: TextStyle(
                                color: AppColors.attendanceWarning,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Quick Mark Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _markAttendance(index, true),
                              icon: const Icon(Icons.check, size: 16, color: AppColors.attendanceSafe),
                              label: const Text('Present Today', style: TextStyle(color: AppColors.attendanceSafe)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.attendanceSafe),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _markAttendance(index, false),
                              icon: const Icon(Icons.close, size: 16, color: AppColors.attendanceDanger),
                              label: const Text('Bunked Today', style: TextStyle(color: AppColors.attendanceDanger)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.attendanceDanger),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

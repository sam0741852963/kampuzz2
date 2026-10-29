import 'dart:math' as math;

/// CampusPulse Bunk-Meter calculation engine for Flutter UI & Unit Tests.
class BunkMath {
  /// Current attendance percentage with edge case handling (0 total classes = 100%).
  static double currentPercentage(int attended, int total) {
    if (total <= 0) return 100.0;
    if (attended <= 0) return 0.0;
    return (attended / total) * 100.0;
  }

  /// Safe bunks remaining:
  /// floor(attended / (required / 100) - total)
  static int safeBunks(int attended, int total, double requiredPercentage) {
    if (total <= 0) return 0;
    if (requiredPercentage <= 0) return 999;
    if (requiredPercentage >= 100.0) return 0;

    final threshold = requiredPercentage / 100.0;
    final value = (attended / threshold) - total;
    return math.max(0, value.floor());
  }

  /// Classes needed consecutively to recover back to required percentage:
  /// ceil((required * total - 100 * attended) / (100 - required))
  /// Returns -1 if mathematically unreachable (e.g. required is 100%).
  static int recoveryClasses(int attended, int total, double requiredPercentage) {
    if (total <= 0) return 0;
    final currentPct = currentPercentage(attended, total);
    if (currentPct >= requiredPercentage) return 0;

    if (requiredPercentage >= 100.0) {
      return -1;
    }

    final numerator = (requiredPercentage * total) - (100.0 * attended);
    final denominator = 100.0 - requiredPercentage;
    final needed = (numerator / denominator).ceil();
    return math.max(0, needed);
  }

  /// What-if calculation:
  /// "If I bunk X more classes, my percentage will become Y%"
  static double whatIfPercentage(
    int attended,
    int total,
    int bunkXMore, {
    int? projectedSemesterTotal,
  }) {
    if (bunkXMore < 0) bunkXMore = 0;
    final newTotal = projectedSemesterTotal ?? (total + bunkXMore);
    if (newTotal <= 0) return 100.0;
    return (attended / newTotal) * 100.0;
  }

  /// Status indicator: 'green', 'amber', 'red'
  static String statusColor(int attended, int total, double requiredPercentage) {
    if (total <= 0) return 'green';
    final currentPct = currentPercentage(attended, total);
    if (currentPct < requiredPercentage) return 'red';
    final bunks = safeBunks(attended, total, requiredPercentage);
    if (bunks <= 1 || (currentPct - requiredPercentage) < 3.0) return 'amber';
    return 'green';
  }
}

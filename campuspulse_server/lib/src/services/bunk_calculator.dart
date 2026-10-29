import 'dart:math' as math;

/// Core Bunk-Meter calculations conforming to CampusPulse specifications.
class BunkCalculator {
  /// Calculates current attendance percentage.
  /// Edge case: If total classes held is 0, defaults to 100.0%.
  static double calculateCurrentPercentage(int attended, int total) {
    if (total <= 0) return 100.0;
    if (attended < 0) return 0.0;
    return (attended / total) * 100.0;
  }

  /// Calculates safe bunks:
  /// floor(attended / (required / 100) - total) classes you can still skip
  /// without dropping below the required percentage (minimum 0).
  ///
  /// Edge cases:
  /// - If total is 0, safe bunks is 0.
  /// - If required is 0, infinite/all can be skipped.
  /// - If required is 100, safe bunks can only be 0 (cannot miss any class).
  static int calculateSafeBunks(int attended, int total, double requiredPercentage) {
    if (total <= 0) return 0;
    if (requiredPercentage <= 0) return 999;
    if (requiredPercentage >= 100.0) return 0;

    final threshold = requiredPercentage / 100.0;
    final value = (attended / threshold) - total;
    final safeBunks = value.floor();
    return math.max(0, safeBunks);
  }

  /// Calculates recovery classes needed consecutively to reach required percentage:
  /// ceil((required * total - 100 * attended) / (100 - required))
  ///
  /// Returns 0 if current attendance is already >= required percentage.
  /// Edge cases:
  /// - If required >= 100 and attended < total, recovery is impossible (returns -1 to signify unreachable).
  /// - If total == 0, returns 0.
  static int calculateRecoveryClasses(int attended, int total, double requiredPercentage) {
    if (total <= 0) return 0;
    final currentPct = calculateCurrentPercentage(attended, total);
    if (currentPct >= requiredPercentage) return 0;

    if (requiredPercentage >= 100.0) {
      // If 100% required and you missed even one class, mathematically (attended + x)/(total + x) = 1
      // has no finite solution if attended < total.
      return -1;
    }

    final numerator = (requiredPercentage * total) - (100.0 * attended);
    final denominator = 100.0 - requiredPercentage;
    final needed = (numerator / denominator).ceil();
    return math.max(0, needed);
  }

  /// Calculates projected attendance percentage if student bunks [bunkXMore] additional classes.
  /// [projectedSemesterTotal]: optional fixed total semester classes.
  /// If null, projected total becomes total + bunkXMore.
  static double calculateWhatIfPercentage(
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

  /// Returns attendance status category: 'green' (safe), 'amber' (warning/near limit), 'red' (danger/below).
  static String getStatusColor(int attended, int total, double requiredPercentage) {
    if (total <= 0) return 'green';
    final currentPct = calculateCurrentPercentage(attended, total);
    if (currentPct < requiredPercentage) {
      return 'red';
    }
    final safeBunks = calculateSafeBunks(attended, total, requiredPercentage);
    if (safeBunks <= 1 || (currentPct - requiredPercentage) < 3.0) {
      return 'amber';
    }
    return 'green';
  }
}

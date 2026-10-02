import 'package:flutter_test/flutter_test.dart';
import 'package:outgrow/features/habits/model/streak.dart';

void main() {
  // Fixed "now" in the evening, so same-day times earlier in the day are valid.
  final now = DateTime(2026, 3, 10, 20, 0);
  DateTime day(int d, [int hour = 9]) => DateTime(2026, 3, d, hour);

  group('calculateCurrentStreak', () {
    test('is 0 with no logs', () {
      expect(calculateCurrentStreak([], [], now), 0);
    });

    test('counts consecutive days ending today', () {
      expect(calculateCurrentStreak([day(8), day(9), day(10)], [], now), 3);
    });

    test('stays alive when today is not logged yet', () {
      expect(calculateCurrentStreak([day(8), day(9)], [], now), 2);
    });

    test('resets when a day is missed', () {
      // Logged on the 6th and 7th, nothing on the 8th or 9th.
      expect(calculateCurrentStreak([day(6), day(7)], [], now), 0);
    });

    test('only counts the run after a gap', () {
      expect(calculateCurrentStreak([day(5), day(6), day(8), day(9), day(10)], [], now), 3);
    });

    test('is 0 after a slip today', () {
      expect(calculateCurrentStreak([day(8), day(9)], [day(10, 18)], now), 0);
    });

    test('a slip breaks the run', () {
      expect(calculateCurrentStreak([day(7), day(9), day(10)], [day(8)], now), 2);
    });

    test('a slip outweighs a check-in on the same day', () {
      expect(calculateCurrentStreak([day(8), day(9), day(10)], [day(9, 22)], now), 1);
    });

    test('duplicate check-ins on one day count once', () {
      expect(calculateCurrentStreak([day(10, 8), day(10, 9), day(10, 10)], [], now), 1);
    });

    test('works across a month boundary', () {
      final april2 = DateTime(2026, 4, 2, 12);
      final logs = [DateTime(2026, 3, 31), DateTime(2026, 4, 1), DateTime(2026, 4, 2)];
      expect(calculateCurrentStreak(logs, [], april2), 3);
    });
  });

  group('calculateLongestStreak', () {
    test('is 0 with no logs', () {
      expect(calculateLongestStreak([], []), 0);
    });

    test('finds the longest run, not the latest one', () {
      final logs = [day(1), day(2), day(3), day(4), day(7), day(8)];
      expect(calculateLongestStreak(logs, []), 4);
    });

    test('ignores input order and duplicates', () {
      expect(calculateLongestStreak([day(3), day(1), day(2), day(2, 18)], []), 3);
    });

    test('slip days split runs', () {
      expect(calculateLongestStreak([day(1), day(2), day(3), day(4)], [day(3)]), 2);
    });
  });
}

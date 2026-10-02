// Streak maths derived from the logged dates, so streaks stay honest when
// days are skipped instead of drifting like a stored counter would.

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

// Day arithmetic via the constructor rather than Duration, so DST changes
// can't shift a date by an hour into the wrong day.
DateTime _previousDay(DateTime d) => DateTime(d.year, d.month, d.day - 1);
DateTime _nextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);

/// Days with a check-in and no slip. A slip on the same day wins.
Set<DateTime> cleanDays(List<DateTime> checkIns, List<DateTime> slips) {
  final slipDays = slips.map(dateOnly).toSet();
  return checkIns.map(dateOnly).where((d) => !slipDays.contains(d)).toSet();
}

/// Consecutive clean days ending today, or ending yesterday if today
/// hasn't been logged yet (the day isn't over, so the streak is still alive).
/// A slip today, or a day with no log, ends the streak.
int calculateCurrentStreak(
  List<DateTime> checkIns,
  List<DateTime> slips,
  DateTime now,
) {
  final today = dateOnly(now);
  if (slips.any((d) => isSameDay(d, today))) return 0;

  final clean = cleanDays(checkIns, slips);
  var day = clean.contains(today) ? today : _previousDay(today);
  var streak = 0;
  while (clean.contains(day)) {
    streak++;
    day = _previousDay(day);
  }
  return streak;
}

/// The longest run of consecutive clean days ever logged.
int calculateLongestStreak(List<DateTime> checkIns, List<DateTime> slips) {
  final days = cleanDays(checkIns, slips).toList()..sort();
  var longest = 0;
  var run = 0;
  DateTime? previous;
  for (final day in days) {
    run = (previous != null && _nextDay(previous) == day) ? run + 1 : 1;
    if (run > longest) longest = run;
    previous = day;
  }
  return longest;
}

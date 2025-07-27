enum DayOfWeek {
  sunday(7, "Sunday", "Sun"),
  monday(1, "Monday", "Mon"),
  tuesday(2, "Tuesday", "Tue"),
  wednesday(3, "Wednesday", "Wed"),
  thursday(4, "Thursday", "Thu"),
  friday(5, "Friday", "Fri"),
  saturday(6, "Saturday", "Sat");

  final String fullName;
  final String shortName;
  final int value;

  const DayOfWeek(this.value, this.fullName, this.shortName);
}

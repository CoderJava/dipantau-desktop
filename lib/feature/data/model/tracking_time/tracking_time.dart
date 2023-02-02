import 'package:equatable/equatable.dart';

class TrackingTime extends Equatable{
  final int hour;
  final int minute;
  final int second;

  TrackingTime({
    required this.hour,
    required this.minute,
    required this.second,
  });

  @override
  List<Object?> get props => [
    hour,
    minute,
    second,
  ];

  @override
  String toString() {
    return 'TrackingTime{hour: $hour, minute: $minute, second: $second}';
  }
}

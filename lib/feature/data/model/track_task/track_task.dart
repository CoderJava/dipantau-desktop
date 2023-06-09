class TrackTask {
  final int id;
  final String name;
  int trackedInSeconds;

  TrackTask({
    required this.id,
    required this.name,
    required this.trackedInSeconds,
  });

  @override
  String toString() {
    return 'TrackTask{id: $id, name: $name, trackedInSeconds: $trackedInSeconds}';
  }
}

class Weather {
  Weather({
    required this.currentTemp,
    required this.description,
    required this.maxTemp,
    required this.minTemp,
  });

  final double currentTemp;
  final String description;
  final double maxTemp;
  final double minTemp;

  @override
  String toString() => '''
  Current Temp: ${currentTemp.toStringAsFixed(0)}°C
  Condition:    $description
  Daily Min:    ${minTemp.toStringAsFixed(0)}°C
  Daily Max:    ${maxTemp.toStringAsFixed(0)}°C
    ''';
}

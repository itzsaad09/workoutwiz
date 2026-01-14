class Exercise {
  final String id;
  final String name;
  final String target;
  final String equipment;
  final String gifUrl;
  final List<String> instructions;

  Exercise({
    required this.id,
    required this.name,
    required this.target,
    required this.equipment,
    required this.gifUrl,
    required this.instructions,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      target: json['target'] ?? '',
      equipment: json['equipment'] ?? '',
      gifUrl: json['gifUrl'] ?? '',
      instructions:
          (json['instructions'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

class Character {
  final String name;
  final String type;
  final String imageUrl;

  const Character({required this.name, required this.type, required this.imageUrl});

  factory Character.fromJson(Map<String, dynamic> json) {
    final String name = (json['name'] as String?)?.trim() ?? 'Desconhecido';
    final String image = (json['imageUrl'] as String?) ?? (json['image'] as String?) ?? '';
    final String type = (json['type'] as String?)?.trim() ?? 'Desconhecido';
    return Character(name: name.isEmpty ? 'Desconhecido' : name, type: type.isEmpty ? 'Desconhecido' : type, imageUrl: image);
  }
}

class Role {
  final int id;
  final String name;
  final String? description;

  Role({
    required this.id,
    required this.name,
    this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class RoleCreate{
  final String name;
  final String? description;

  RoleCreate({
    required this.name,
    this.description
  });

  factory RoleCreate.fromJson(Map<String, dynamic> json){
    return RoleCreate(
      name: json['name'], 
      description: json['description'],
    );
  }
}
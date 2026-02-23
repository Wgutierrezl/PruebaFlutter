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

  Map<String, dynamic> toJson(){
    return {
      'name':name,
      'description':description
    };
  }
}

class RoleUpdated{
  final String? name;
  final String? description;

  RoleUpdated({
    this.name,
    this.description,
  });

  factory RoleUpdated.fromJson(Map<String, dynamic> json){
    return RoleUpdated(
      name:json['name'],
      description: json['description']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'name':name,
      'description':description
    };
  }
}
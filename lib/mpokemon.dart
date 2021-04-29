class ModelPokemon {
  String url;
  String name;

  ModelPokemon({this.name, this.url});

  factory ModelPokemon.fromJson(Map<String, dynamic> json) {
    return ModelPokemon(name: json['name'], url: json['url']);
  }
}

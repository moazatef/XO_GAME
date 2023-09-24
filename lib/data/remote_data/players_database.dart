class PlayersDB {
  String name;
  PlayersDB({required this.name});

  factory PlayersDB.fromJson(Map<String, dynamic> json) {
    return PlayersDB(
      name: json['name']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}


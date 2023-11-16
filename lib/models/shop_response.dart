class ShotResponse {
  final String message;
  final bool sunkShip;
  final bool won;

  ShotResponse({
    required this.message,
    required this.sunkShip,
    required this.won,
  });

  factory ShotResponse.fromJson(Map<String, dynamic> json) {
    return ShotResponse(
      message: json['message'],
      sunkShip: json['sunk_ship'],
      won: json['won'],
    );
  }
}

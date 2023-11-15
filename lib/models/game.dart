class Game {
  int id;
  String status;
  String gameId;
  List<String>? selectedByMe;
  List<String>? selectedByOpponent;
  List<String>? attackByMe;
  List<String>? attackByOponnet;
  Game({
    required this.id,
    required this.status,
    required this.gameId,
    this.selectedByMe,
    this.selectedByOpponent,
    this.attackByMe,
    this.attackByOponnet,
  });
}

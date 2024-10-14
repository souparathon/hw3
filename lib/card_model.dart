class CardModel {
  final String id;
  final String front;
  bool isFaceUp;

  CardModel({required this.id, required this.front, this.isFaceUp = false});
}

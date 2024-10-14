import 'dart:async';
import 'package:flutter/foundation.dart';
import 'card_model.dart';

class GameProvider with ChangeNotifier {
  List<CardModel> _cards = [];
  String? _firstCardId;
  String? _secondCardId;
  bool _isGameWon = false;
  Timer? _timer;
  int _elapsedTime = 0;

  List<CardModel> get cards => _cards;
  bool get isGameWon => _isGameWon;
  int get elapsedTime => _elapsedTime;

  void initializeGame(List<CardModel> cards) {
    _cards = cards.map((card) => CardModel(id: card.id, front: card.front, isFaceUp: false)).toList();
    _shuffleCards();
    _firstCardId = null;
    _secondCardId = null;
    _isGameWon = false;
    _elapsedTime = 0;
    _startTimer();
    notifyListeners();
  }

  void _shuffleCards() {
    _cards.shuffle();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _elapsedTime++;
      notifyListeners();
    });
  }

  void flipCard(String id) {
    final card = _cards.firstWhere((card) => card.id == id);
    card.isFaceUp = !card.isFaceUp;
    notifyListeners();
    
    if (_firstCardId == null) {
      _firstCardId = id;
    } else {
      _secondCardId = id;
      _checkMatch();
    }
  }

  void _checkMatch() {
    if (_firstCardId != null && _secondCardId != null) {
      final firstCard = _cards.firstWhere((card) => card.id == _firstCardId);
      final secondCard = _cards.firstWhere((card) => card.id == _secondCardId);
      
      if (firstCard.front != secondCard.front) {
        Future.delayed(Duration(seconds: 1), () {
          firstCard.isFaceUp = false;
          secondCard.isFaceUp = false;
          notifyListeners();
        });
      } else {
        _checkWinCondition();
      }
      
      _firstCardId = null;
      _secondCardId = null;
    }
  }

  void _checkWinCondition() {
    if (_cards.every((card) => card.isFaceUp)) {
      _isGameWon = true;
      _timer?.cancel();
      notifyListeners();
    }
  }
}

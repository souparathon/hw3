import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'game_provider.dart';
import 'card_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        home: GameScreen(),
      ),
    );
  }
}

class GameScreen extends StatelessWidget {
  final List<CardModel> initialCards = [
    CardModel(id: '1', front: 'star'),
    CardModel(id: '2', front: 'star'),
    CardModel(id: '3', front: 'heart'),
    CardModel(id: '4', front: 'heart'),
    // Add more pairs...
  ];

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    // Initialize and shuffle the game with cards only once
    if (gameProvider.cards.isEmpty) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        List<CardModel> shuffledCards = List.from(initialCards)..shuffle(Random());
        gameProvider.initializeGame(shuffledCards);
      });
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Time: ${gameProvider.elapsedTime}s'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: gameProvider.cards.length,
              itemBuilder: (context, index) {
                final card = gameProvider.cards[index];
                return GestureDetector(
                  onTap: () {
                    if (!card.isFaceUp) {
                      gameProvider.flipCard(card.id);
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: card.isFaceUp ? Colors.white : Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                    ),
                    child: Center(
                      child: card.isFaceUp
                          ? Icon(
                              card.front == 'star' ? Icons.star : Icons.favorite,
                              size: 48,
                              color: card.front == 'star' ? Colors.yellow : Colors.red,
                            )
                          : Text(
                              '?',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (gameProvider.isGameWon)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'You won!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
          ElevatedButton(
            onPressed: () {
              List<CardModel> shuffledCards = List.from(initialCards)..shuffle(Random());
              gameProvider.initializeGame(shuffledCards);
            },
            child: Text('Restart Game'),
          ),
        ],
      ),
    );
  }
}

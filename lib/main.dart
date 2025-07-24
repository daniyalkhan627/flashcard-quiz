import 'package:flashcard_quiz/flash_card_view.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flashcard_quiz/new_flash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final List<Flashcard> newFlash;


  MyApp({super.key})
      : newFlash = [
    Flashcard(question: "What is the capital of Japan?", answer: "Tokyo"),
    Flashcard(question: "Who wrote the play Romeo and Juliet?", answer: "William Shakespeare"),
    Flashcard(question: "Which planet is known as the Red Planet?", answer: "Mars"),
    Flashcard(question: "What is the fastest land animal?", answer: "Cheetah"),
  ];

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashCard Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: MyHomePage(
        title: 'FlashCard Quiz App',
        flashcards: widget.newFlash,

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.flashcards});
  final String title;
  final List<Flashcard> flashcards;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

class _MyHomePageState extends State<MyHomePage> {
  int _currIndex = 0;

  void nextCard() {
    setState(() {
      _currIndex = (_currIndex + 1 < widget.flashcards.length)
          ? _currIndex + 1
          : 0;
    });
  }

  void previousCard() {
    setState(() {
      _currIndex = (_currIndex - 1 >= 0)
          ? _currIndex - 1
          : widget.flashcards.length - 1;
    });
  }

  void _showCustomizeMenu() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Flashcard'),
            onTap: () {
              Navigator.pop(context);
              _showAddEditDialog();
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Current Flashcard'),
            onTap: () {
              Navigator.pop(context);
              _showAddEditDialog(isEdit: true);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete Current Flashcard'),
            onTap: () {
              Navigator.pop(context);
              _deleteCurrentCard();
            },
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog({bool isEdit = false}) {
    final questionController = TextEditingController(
      text: isEdit ? widget.flashcards[_currIndex].question : '',
    );
    final answerController = TextEditingController(
      text: isEdit ? widget.flashcards[_currIndex].answer : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit Flashcard' : 'Add Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final q = questionController.text.trim();
              final a = answerController.text.trim();

              if (q.isEmpty || a.isEmpty) return;

              setState(() {
                if (isEdit) {
                  widget.flashcards[_currIndex] = Flashcard(question: q, answer: a);
                } else {
                  widget.flashcards.add(Flashcard(question: q, answer: a));
                  _currIndex = widget.flashcards.length - 1;
                }
              });

              Navigator.of(ctx).pop();
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _deleteCurrentCard() {
    if (widget.flashcards.isEmpty) return;

    setState(() {
      widget.flashcards.removeAt(_currIndex);
      if (_currIndex >= widget.flashcards.length) {
        _currIndex = widget.flashcards.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.flashcards.isNotEmpty
        ? widget.flashcards[_currIndex]
        : Flashcard(question: 'No Cards', answer: 'Add one using + button');

    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 280,
              height: 280,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.cyan, width: 2),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: FlipCard(
                  key: cardKey,
                  front: FlashCardView(text: card.question),
                  back: FlashCardView(text: card.answer),
                ),

              ),

            ),
            SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [


                OutlinedButton.icon(
                  onPressed: previousCard,
                  icon: Icon(Icons.chevron_left),
                  label: Text("Prev"),


              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)
                )
              )
                ),
                OutlinedButton(
                    onPressed: () {
                      cardKey.currentState?.toggleCard();
                    },
                    child: Text("Answer"),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)
                        )
                    )
                ),
                OutlinedButton.icon(
                  onPressed: nextCard,
                  icon: Icon(Icons.chevron_right),
                  label: Text("Next"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)
                    )
                  )
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCustomizeMenu,
        child: Icon(Icons.settings),
        tooltip: 'Customize Flashcards',
      ),
    );
  }
}

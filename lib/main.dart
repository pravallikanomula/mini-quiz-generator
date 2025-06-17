import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  await dotenv.load();
  runApp(QuizApp());
}


class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Quiz Generator',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: QuizHomePage(),
    );
  }
}

class QuizHomePage extends StatefulWidget {
  @override
  _QuizHomePageState createState() => _QuizHomePageState();
}

class _QuizHomePageState extends State<QuizHomePage> {
  final TextEditingController _topicController = TextEditingController();
  bool _loading = false;
  List<Map<String, dynamic>> _questions = [];
  int _questionCount = 3;
  String _difficulty = "medium";


  Future<void> generateQuiz() async {
    final topic = _topicController.text.trim();
    if (topic.isEmpty) return;

    setState(() {
      _loading = true;
      _questions.clear();
    });

    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${dotenv.env['OPENAI_API_KEY']}"

        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content":
                  "Generate $_questionCount multiple choice questions on the topic \"$topic\" at a $_difficulty difficulty level. Each should have 4 options and one correct answer. Format the output strictly as JSON like this:\n[{\"question\": \"...\", \"options\": [\"...\", \"...\", \"...\", \"...\"], \"answer\": \"...\"}]"
            }
          ]
        }),
      );

      final data = jsonDecode(response.body);
      print("📦 OpenAI raw response: ${jsonEncode(data)}");

      print("🔎 API response: ${jsonEncode(data)}");

      if (data["choices"] == null) {
        print("❌ API failed: ${data["error"]}");
        return;
      }

      final content = data["choices"][0]["message"]["content"];
      final jsonQuiz = jsonDecode(content);

      setState(() {
        _questions = List<Map<String, dynamic>>.from(jsonQuiz.map((q) {
          q['selected'] = null;
          return q;
        }));
      });
    } catch (e) {
      print("❌ Exception: $e");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
  Future<void> _saveQuizToHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('quiz_history') ?? [];

    final quizToSave = jsonEncode({
      "timestamp": DateTime.now().toIso8601String(),
      "topic": _topicController.text.trim(),
      "questions": _questions,
    });

    history.add(quizToSave);
    await prefs.setStringList('quiz_history', history);
    print("✅ Quiz saved to history!");
  }
 
  Future<void> _loadQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('quiz_history') ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) => ListView.builder(
          controller: controller,
          itemCount: history.length,
          itemBuilder: (context, index) {
            final quiz = jsonDecode(history[index]);
            return ExpansionTile(
              title: Text("Quiz on ${quiz['topic']}"),
              subtitle: Text("Date: ${quiz['timestamp']}"),
              children: List.generate(quiz['questions'].length, (qIndex) {
                final q = quiz['questions'][qIndex];
                return ListTile(
                  title: Text("${qIndex + 1}. ${q['question']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...q['options'].map<Widget>((opt) => Text(
                        "- $opt ${opt == q['answer'] ? '(✔ Correct)' : ''} ${opt == q['selected'] && opt != q['answer'] ? '(✘ Your Answer)' : ''}",
                        style: TextStyle(
                          color: opt == q['answer']
                              ? Colors.green
                              : (opt == q['selected'] ? Colors.red : null),
                        ),
                      )),
                    ],
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  void _submitAnswers() {
    int score = 0;

    for (var q in _questions) {
      if (q['selected'] == q['answer']) {
        score++;
      }
    }
    

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Quiz Completed!"),
        content: Text("Your score is $score out of ${_questions.length}."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );
    _saveQuizToHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mini Quiz Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _topicController,
              onSubmitted: (_) => generateQuiz(),
              decoration: InputDecoration(
                labelText: "Enter a topic",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: "Number of Questions"),
              value: _questionCount,
              items: [3, 5, 10].map((count) {
                return DropdownMenuItem(
                  value: count,
                  child: Text("$count questions"),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _questionCount = value!;
                });
              },
            ),

            SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: "Difficulty"),
              value: _difficulty,
              items: ["easy", "medium", "hard"].map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level[0].toUpperCase() + level.substring(1)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _difficulty = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: generateQuiz,
              child: Text("Generate Quiz"),
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : _questions.isEmpty
                    ? Text("No quiz generated yet.")
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            final q = _questions[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${index + 1}. ${q['question']}"),
                                    ...List.generate(q['options'].length, (i) {
                                      final option = q['options'][i];
                                      return RadioListTile<String>(
                                        title: Text(option),
                                        value: option,
                                        groupValue: q['selected'],
                                        onChanged: (value) {
                                          setState(() {
                                            _questions[index]['selected'] =
                                                value;
                                          });
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            if (_questions.isNotEmpty) ...[
              ElevatedButton(
                onPressed: _submitAnswers,
                child: Text("Submit Quiz"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _loadQuizHistory,
                child: Text("View Saved Quizzes"),
              ),  
            ],  
          ],
        ),
      ),
    );
  }
}

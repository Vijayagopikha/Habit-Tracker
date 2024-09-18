import 'package:flutter/material.dart';

void main() {
  runApp(HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HabitTrackerPage(),
    );
  }
}

class HabitTrackerPage extends StatefulWidget {
  @override
  _HabitTrackerPageState createState() => _HabitTrackerPageState();
}

class _HabitTrackerPageState extends State<HabitTrackerPage> {
  List<Habit> habits = [];
  final _habitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Habit Tracker',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700],
        elevation: 6.0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _habitController,
                    decoration: InputDecoration(
                      labelText: 'Enter a new habit',
                      labelStyle: TextStyle(color: Colors.teal[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal[700]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: _addHabit,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: habits.isEmpty
                ? Center(
                    child: Text(
                      'No habits added.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (context, index) {
                      return HabitTile(
                        habit: habits[index],
                        onToggle: () {
                          setState(() {
                            habits[index].toggleCompletion();
                          });
                        },
                        onDelete: () {
                          setState(() {
                            habits.removeAt(index);
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _addHabit() {
    if (_habitController.text.isNotEmpty) {
      setState(() {
        habits.add(Habit(name: _habitController.text));
        _habitController.clear();
      });
    }
  }
}

class Habit {
  String name;
  bool completed;

  Habit({required this.name, this.completed = false});

  void toggleCompletion() {
    completed = !completed;
  }
}

class HabitTile extends StatelessWidget {
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const HabitTile({
    Key? key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: GestureDetector(
          onTap: onToggle,
          child: Icon(
            habit.completed ? Icons.check_circle : Icons.circle_outlined,
            color: habit.completed ? Colors.teal[600] : Colors.grey[600],
            size: 32,
          ),
        ),
        title: Text(
          habit.name,
          style: TextStyle(
            fontSize: 18,
            decoration: habit.completed ? TextDecoration.lineThrough : null,
            color: habit.completed ? Colors.teal[600] : Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red[400]),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

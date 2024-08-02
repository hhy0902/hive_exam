import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  await Hive.initFlutter();

  await Hive.openBox<String>("notes");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: NotePage(),
    );
  }
}

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {

  final TextEditingController _controller = TextEditingController();
  final Box<String> _notesBox  = Hive.box<String>("notes");

  void _addNote() {
    final note = _controller.text;
    if (note.isNotEmpty) {
      _notesBox.add(note);
      _controller.clear();
    }
  }

  void _deleteNote(int index) {
    _notesBox.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Notes'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: '노트 작성'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addNote,
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _notesBox.listenable(),
              builder: (context, Box<String> box, _) {
                if (box.values.isEmpty) {
                  return Center(
                    child: Text('No notes yet!'),
                  );
                }
                return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    final note = box.getAt(index);
                    return ListTile(
                      title: Text(note!),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteNote(index),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
















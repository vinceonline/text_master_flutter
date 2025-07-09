import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() => runApp(TextMasterApp());

class TextMasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Master',
      theme: ThemeData.dark(),
      home: TextEditorPage(),
    );
  }
}

class TextEditorPage extends StatefulWidget {
  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  String _fileContent = '';
  String _filePath = '';

  final TextEditingController _controller = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      String path = result.files.single.path!;
      File file = File(path);
      String content = await file.readAsString();
      setState(() {
        _fileContent = content;
        _filePath = path;
        _controller.text = content;
      });
    }
  }

  Future<void> _saveFile() async {
    if (_filePath.isNotEmpty) {
      final file = File(_filePath);
      await file.writeAsString(_controller.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Файл сохранён')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Файл не выбран')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Master'),
        actions: [
          IconButton(icon: Icon(Icons.folder_open), onPressed: _pickFile),
          IconButton(icon: Icon(Icons.save), onPressed: _saveFile),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: _controller,
          maxLines: null,
          style: TextStyle(fontFamily: 'monospace'),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Введите текст или откройте файл',
          ),
        ),
      ),
    );
  }
}

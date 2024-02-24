import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCP Keyboard Input',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();

  void sendTcpRequest() async {
    try {
      Socket socket = await Socket.connect(
        _ipController.text.trim(),
        int.parse(_portController.text.trim()),
      );
      socket.add([13]); // ASCII code for Enter key
      await socket.flush();
      await socket.close();
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('TCP Keyboard Input'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Button'),
              Tab(text: 'Settings & Owner'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Button Tab
            Center(
              child: IconButton(
                icon: Image.asset ('assets/aime.png'), // Specify your image path
                onPressed: sendTcpRequest,
                iconSize: 50.0,
              ),
            ),
            // Settings & Owner Tab
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _ipController,
                    decoration: InputDecoration(
                      labelText: 'Enter Computer IP Address',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _portController,
                    decoration: InputDecoration(
                      labelText: 'Enter Port Number',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Made by Nari@NarYuki',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

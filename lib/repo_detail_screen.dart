import 'package:flutter/material.dart';

class RepoDetailScreen extends StatelessWidget {
  final Map<String, dynamic> repo;

  RepoDetailScreen({required this.repo});

  @override
  Widget build(BuildContext context) {
    final files = repo['files'] as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Repository Files'),
      ),
      body: ListView(
        children: files.keys.map((fileName) {
          final file = files[fileName];
          return ListTile(
            title: Text(fileName),
            subtitle: Text('Type: ${file['type']}'),
          );
        }).toList(),
      ),
    );
  }
}

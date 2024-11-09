import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:repo_gallery_app/repo_detail_screen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RepoScreen extends StatefulWidget {
  @override
  _RepoScreenState createState() => _RepoScreenState();
}

class _RepoScreenState extends State<RepoScreen> {
  List<dynamic> _repositories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCachedRepositories();
  }
  Future<void> loadCachedRepositories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedRepos = prefs.getString('cached_repos');

    if (cachedRepos != null) {
      setState(() {
        _repositories = json.decode(cachedRepos);
        _isLoading = false;
      });
      fetchRepositories(refreshCache: true); 
    } else {
      fetchRepositories();
    }
  }

  Future<void> fetchRepositories({bool refreshCache = false}) async {
    final response = await http.get(Uri.parse("https://api.github.com/gists/public"));

    if (response.statusCode == 200) {
      List<dynamic> repos = json.decode(response.body);
      setState(() {
        _repositories = repos;
        _isLoading = false;
      });

      if (refreshCache) {
        cacheRepositories(repos);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception("Failed to load repositories");
    }
  }
  Future<void> cacheRepositories(List<dynamic> repos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_repos', json.encode(repos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Repositories")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _repositories.length,
              itemBuilder: (context, index) {
                final repo = _repositories[index];
                return ListTile(
                  title: Text(repo['description'] ?? 'No Description'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Comments: ${repo['comments']}'),
                      Text('Created: ${repo['created_at']}'),
                      Text('Updated: ${repo['updated_at']}'),
                    ],
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RepoDetailScreen(repo: repo),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'full_screen_image_screen.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<dynamic> _images = [];
  bool _isLoading = true;
  final String _accessKey = '5_uKojX2uu4tMCA1uQvaSQnMcnN9WxE5kQpAhRUn-nU';

  @override
  void initState() {
    super.initState();
    loadCachedImages();
  }

  Future<void> loadCachedImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedImages = prefs.getString('cached_images');

    if (cachedImages != null) {
      setState(() {
        _images = json.decode(cachedImages);
        _isLoading = false;
      });
      fetchImages(refreshCache: true); 
    } else {
      fetchImages();
    }
  }

  Future<void> fetchImages({bool refreshCache = false}) async {
    final response = await http.get(
      Uri.parse("https://api.unsplash.com/photos?client_id=$_accessKey"),
    );

    if (response.statusCode == 200) {
      List<dynamic> images = json.decode(response.body);
      setState(() {
        _images = images;
        _isLoading = false;
      });

      if (refreshCache) {
        cacheImages(images);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception("Failed to load images");
    }
  }
  Future<void> cacheImages(List<dynamic> images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cached_images', json.encode(images));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gallery")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                final imageUrl = _images[index]['urls']['small'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageScreen(
                          imageUrl: _images[index]['urls']['regular'],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

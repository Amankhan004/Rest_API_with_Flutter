import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_with_flutter/models/post_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<PostModel> allPosts = [];
  bool isloaded = false;

  Future<List<PostModel>> getPost() async {
    var url = Uri.https("jsonplaceholder.typicode.com", "/posts");
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        isloaded = !isloaded;
      });
    }
    for (var i in responseBody) {
      allPosts.add(PostModel.fromJson(i));
    }
    return allPosts;
  }

  @override
  void initState() {
    super.initState();
    // Your initialization code goes here
    getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Posts")),
        ),
        body: Center(
          child: isloaded
              ? ListView.builder(
                  itemCount: allPosts.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (isloaded) {
                      return ListTile(
                        leading: CircleAvatar(child: Text("${index + 1}")),
                        title: Text(
                          allPosts[index].title!,
                          maxLines: 1,
                          style: TextStyle(),
                        ),
                        subtitle: Text(
                          allPosts[index].body!,
                          maxLines: 3,
                        ),
                      );
                    }
                    return null;
                  })
              : const CircularProgressIndicator(),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'restClient.dart' as restClient;

class BlogDetailWidget extends StatefulWidget {
  final int blogId;

  BlogDetailWidget(this.blogId)  {
    if (blogId == null) {
      throw new ArgumentError("blogId of MemberWidget cannot be null. "
          "Received: '$blogId'");
    }
  }

  @override
  createState() => new BlogDetailState(blogId);
}

class BlogDetailState extends State<BlogDetailWidget> {
  final int blogId;

  BlogDetailState(this.blogId);

  var data;

  Future getData() async {
    var localData;

    var response = await restClient.getBlogDetail(blogId.toString(), false);

    //Refresh the token if expired.
    if (await response.statusCode == 403) {
      response = await restClient.getBlogDetail(blogId.toString(), true);

      if (await response.statusCode != 200) {
        response = await restClient.getBlogDetail(blogId.toString(), true);
      } else {
        localData = await json.decode(response.body);

        setBlogState(localData);
      }
    } else {
      localData = await json.decode(response.body);

      setBlogState(localData);
    }

    return "Success!";
  }

  setBlogState(localData) {
    this.setState(() {
      data = localData;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  final f = new DateFormat('yyyy-MM-dd hh:mm');

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0),
      child: data == null
          ? const Center(child: const CircularProgressIndicator())
          : new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Text(
            f.format(new DateTime.fromMillisecondsSinceEpoch(int.parse(data["createdDate"])))
            ,
            style: TextStyle(
              color: Color(0xFF757575),
              fontSize: 15.0,
            ),
          ),
          new Text(
            data["title"],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),

        ])
    );


    Widget dateSection = Container(
      padding: const EdgeInsets.all(1.0),
      child: data == null
          ? const Center(child: const CircularProgressIndicator())
          : new Text(
              f.format(new DateTime.fromMillisecondsSinceEpoch(int.parse(data["createdDate"])))
              ,
              style: TextStyle(
                color: Color(0xFF757575),
                fontSize: 15.0,
              ),
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(20.0),
      child: data == null
          ? const Center(child: const CircularProgressIndicator())
          : HtmlView(
            data: data["content"]
          ),
      );

    return new Scaffold (
        appBar: new AppBar(
          title: data == null
              ? const Center(child: const CircularProgressIndicator())
              : new Text(data["title"]),
        ),
        body: data == null
            ? const Center(child: const CircularProgressIndicator())
            : ListView(
          children: [
            Image.network(
              data["imageUrl"],
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),
            titleSection,
            textSection,
          ],
        ),
    );
  }
}
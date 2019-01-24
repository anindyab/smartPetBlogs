import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:convert';
import 'dart:async';
import 'blogDetail.dart';
import 'restClient.dart' as restClient;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter/Liferay Blogs Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter/Liferay Blog Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var data;

  //Navigation to blog detail page
  _pushMember(int blogId) {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) => new BlogDetailWidget(blogId)
        )
    );
  }

  Future getData() async {
    var response = await restClient.getAllBlogs();

    var localData = json.decode(response.body);

    this.setState(() {
      data = localData;
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();

    this.getData();
  }

  @override
  Widget build(BuildContext context) {

    Column buildButtonColumn(IconData icon) {
      Color color = Theme.of(context).primaryColor;
      return new Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          new Icon(icon, color: color),
        ],
      );
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new Column(children: <Widget>[
        new Padding(
          padding: new EdgeInsets.all(0.0),
          child: new PhysicalModel(
            color: Colors.white,
            elevation: 3.0,
          ),
        ),
        new Expanded(
          child: data == null
              ? const Center(child: const CircularProgressIndicator())
              : data["list"].length != 0
                  ? new ListView.builder(
                      itemCount: data == null ? 0 : data["list"].length,
                      padding: new EdgeInsets.all(8.0),
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
                          elevation: 1.7,
                          child: new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Column(
                              children: [
                                new Row(
                                  children: <Widget>[
                                    new Padding(
                                      padding: new EdgeInsets.only(left: 4.0),
                                      child: new Text(
                                        timeago.format(DateTime.parse(
                                            data["list"][index]
                                                ["createdDate"])),
                                        style: new TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    new Padding(
                                      padding: new EdgeInsets.all(5.0),
                                      child: new Text(
                                        data["list"][index]["title"],
                                        style: new TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                new Row(
                                  children: [
                                    new Expanded(
                                      child: new GestureDetector(
                                        child: new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            new Padding(
                                              padding: new EdgeInsets.only(
                                                  left: 4.0,
                                                  right: 8.0,
                                                  bottom: 8.0,
                                                  top: 8.0),
                                              child: new Text(
                                                data["list"][index]["title"],
                                                style: new TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            new Padding(
                                                padding: new EdgeInsets.only(
                                                    left: 4.0,
                                                    right: 4.0,
                                                    bottom: 4.0),
                                                child: new Text(data["list"][index]
                                                  ["content"],
                                                )
                                                ),
                                          ],
                                        ),
                                        onTap: () {
                                          _pushMember(data["list"][index]["id"]);
                                        },
                                      ),
                                    ),
                                    new Column(
                                      children: <Widget>[
                                        new Padding(
                                          padding:
                                              new EdgeInsets.only(top: 8.0),
                                          child: new SizedBox(
                                            height: 100.0,
                                            width: 100.0,
                                            child: new Image.network(
                                              data["list"][index]["imageUrl"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ), ////
                          ),
                        );
                      },
                    )
                  : new Center(),
        )
      ]),
    );
  }
}

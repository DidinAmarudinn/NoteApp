import 'package:flutter/material.dart';
import 'package:sqlite_app/helper/db_helper.dart';
import 'package:sqlite_app/model/mynote_model.dart';
import 'package:sqlite_app/screens/note_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      title: "note using sqlite",
      theme: ThemeData(
        accentColor: Color.fromRGBO(254, 210, 52, 1),
        scaffoldBackgroundColor: Color.fromRGBO(0, 0, 0, 1),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var db = DbHelper();
  Future<List<MyNote>> future;
  void updateList() {
    setState(() {
      future = db.getList();
    });
  }

  @override
  void initState() {
    super.initState();
    updateList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Note App",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color.fromRGBO(5, 5, 4, 1)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => NotePage(null, true),
            ),
          );
          if (result != null) {
            updateList();
          }
        },
        child: Icon(
          Icons.edit,
          color: Colors.black,
        ),
      ),
      body: FutureBuilder<List<MyNote>>(
        future: future,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          var data = snapshot.data;
          return snapshot.hasData
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: StaggeredGridView.countBuilder(
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 2
                        : 3,
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.count(1, index.isEven ? 1 : 1.2);
                    },
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NotePage(data[index], false),
                            ),
                          );
                          if (result != null) {
                            updateList();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF1F1F1F),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8),
                                width: double.infinity,
                                child: Text(
                                  data[index].title,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      data[index].note,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white24),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(254, 210, 52, 1)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  data[index].updateDate,
                                  style: TextStyle(
                                      color: Color.fromRGBO(254, 210, 52, 1),
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    "You don't have a note",
                    style: TextStyle(color: Colors.white),
                  ),
                );
        },
      ),
    );
  }
}

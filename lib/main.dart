import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:bm_board/bm.dart';
import 'package:bm_board/bm_tile.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show json, utf8;

void main() => runApp(BMBoard());

class BMBoard extends StatelessWidget {
  static const _title = 'BM Board';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(title: _title),
    );
  }
}

class Homepage extends StatefulWidget {
  Homepage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var _items = <BM>[];
  bool _loading = false;
  bool _safeMode = true;
  var _allItems = <BM>[];
  var _safeItems = <BM>[];
  var _proModeColor = Colors.red;
  var _safeModeColor = Colors.white;

  AudioCache player = new AudioCache(prefix: 'audio/');

  @override
  void initState() {
    super.initState();
    load();
  }

  List<BM> parseItems(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<BM>((json) => BM.fromJson(json)).toList();
  }

  load() async {
    setState(() {
      _loading = true;
    });

    String json =
        await DefaultAssetBundle.of(context).loadString("assets/data.json");

    final items = parseItems(json);
    _allItems = items;
    _safeItems = items.where((i) => !i.blasphemy).toList();

    // Create list of sound locations
    var sounds = List<String>();
    for (final item in items) {
      sounds.add(item.audioLocation);
    }

    List<File> fileList = await player.loadAll(sounds);
    print('Loading finished');
    if (fileList.isNotEmpty) {
      setState(() {
        _loading = false;
        _items = _safeItems;
      });
    }
  }

  Widget _buildBMItems(double smallestDimension) {
    if (smallestDimension < 600) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return BMTile(bmItem: _items[index], player: player);
        },
        itemCount: _items.length,
      );
    } else {
      // Build grid view
      return GridView.count(
        crossAxisCount: 4,
        childAspectRatio: 3.0,
        children: _items.map((BM bm) {
          return BMTile(bmItem: bm, player: player);
        }).toList(),
      );
    }
  }

  var bodyProgress = Center(
    child: Center(
        child: Column(
      children: <Widget>[
        new CircularProgressIndicator(
          value: null,
          strokeWidth: 5.0,
        ),
        new Container(
            padding: EdgeInsets.all(16.0), child: Text("Loading data"))
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    )),
  );

  void handleSwitchChange(bool value) {
    setState(() {
      _safeMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: _safeMode ? Colors.black : Colors.white),
          ),
          backgroundColor: _safeMode ? _safeModeColor : _proModeColor,
          actions: <Widget>[
            Switch(
                value: _safeMode,
                activeColor: Colors.black,

                onChanged: (bool value) {
                  if (value) {
                    setState(() {
                      _items = _safeItems;
                      _safeMode = value;
                    });
                  } else {
                    setState(() {
                      _items = _allItems;
                      _safeMode = value;
                    });
                  }
                }),
          ],
        ),
        body: Center(
          child: _loading
              ? bodyProgress
              : _buildBMItems(MediaQuery.of(context).size.shortestSide),
        ));
  }
}

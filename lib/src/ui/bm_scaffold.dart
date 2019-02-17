import 'package:bm_board/src/blocs/tiles_bloc.dart';
import 'package:bm_board/src/blocs/tiles_bloc_provider.dart';
import 'package:bm_board/src/data/blash_repository.dart';
import 'package:bm_board/src/models/bm.dart';
import 'package:bm_board/src/models/scaffold_status.dart';
import 'package:bm_board/src/style/app_style.dart';
import 'package:bm_board/src/ui/blasph_home_list.dart';
import 'package:bm_board/src/ui/page.dart';
import 'package:flutter/material.dart';
import 'blasph_starred_list.dart';
import 'blasph_macro_list.dart';

class BMScaffold extends StatefulWidget {
  @override
  BMScaffoldState createState() {
    return new BMScaffoldState();
  }
}

class BMScaffoldState extends State<BMScaffold>
    with SingleTickerProviderStateMixin {
  final scaffoldBloc = TilesBloc();
  final repository = BlasphRepository();

  List<Page> _allPages = <Page>[
    Page(widget: BlasphHomeList()),
    Page(widget: BlasphStarredList()),
    Page(widget: BlasphMacroList()),
  ];

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TilesBlocProvider(
      scaffoldBloc: scaffoldBloc,
      child: StreamBuilder(
        initialData: ScaffoldStatus.empty(),
        stream: scaffoldBloc.scaffoldStatus,
        builder: _buildBody,
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, AsyncSnapshot<ScaffoldStatus> snapshot) {
    bool _safeMode = snapshot.data.isSafeMode;
    Color _toolbarColor = snapshot.data.toolbarColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BM Board",
          style: TextStyle(
              color: _safeMode
                  ? AppStyle.safe_mode_text_color
                  : AppStyle.pro_mode_text_color),
        ),
        backgroundColor: _toolbarColor,
        actions: <Widget>[
          Switch(
              value: _safeMode,
              activeColor: Colors.black,
              onChanged: (bool value) {
                scaffoldBloc.isSafeMode.add(value);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.shuffle),
        label: const Text('Random'),
        onPressed: () {
          BM randomBlasph = scaffoldBloc.getRandomBlasph(_safeMode);
          repository.player.play(randomBlasph.audioLocation);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
      body: TabBarView(
          controller: _controller,
          children: _allPages.map<Widget>((Page page) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Container(
                  key: ObjectKey(page.widget),
                  padding: const EdgeInsets.all(12.0),
                  child: page.widget),
            );
          }).toList()),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new ListTile(
                            leading: new Icon(Icons.home),
                            title: new Text('Home'),
                            onTap: () {
                              _controller.animateTo(0);
                              Navigator.pop(context);
                            },
                          ),
                          new ListTile(
                            leading: new Icon(Icons.star),
                            title: new Text('Starred Blasphs'),
                            onTap: () {
                              _controller.animateTo(1);
                              Navigator.pop(context);
                            },
                          ),
                          new ListTile(
                            leading: new Icon(Icons.category),
                            title: new Text('Macro'),
                            onTap: () {
                              _controller.animateTo(2);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              }),
        ],
      ),
    );
  }
}

import 'package:bm_board/src/blocs/tiles_bloc.dart';
import 'package:bm_board/src/blocs/tiles_bloc_provider.dart';
import 'package:bm_board/src/data/blash_repository.dart';
import 'package:bm_board/src/models/bm.dart';
import 'package:bm_board/src/models/scaffold_status.dart';
import 'package:bm_board/src/style/app_style.dart';
import 'package:bm_board/src/ui/blasph_list.dart';
import 'package:flutter/material.dart';

class BMScaffold extends StatelessWidget {
  final scaffoldBloc = TilesBloc();
  final repository = BlasphRepository();

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
      bottomNavigationBar: BottomAppBar(
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
                              leading: new Icon(Icons.music_note),
                              title: new Text('Music'),
                              onTap: () {
//                                _controller.animateTo(0);
                                Navigator.pop(context);
                              },
                            ),
                            new ListTile(
                              leading: new Icon(Icons.photo_album),
                              title: new Text('Photos'),
                              onTap: () {
//                                _controller.animateTo(1);
                                Navigator.pop(context);
                              },
                            ),
                            new ListTile(
                              leading: new Icon(Icons.videocam),
                              title: new Text('Video'),
                              onTap: () {
//                                _controller.animateTo(2);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                }),
          ],
        ),
      ),
      body: BlasphList(),
    );
  }
}


/*

 return new Scaffold(
      appBar: AppBar(title: const Text('Tasks - Bottom App Bar')),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.add),
        label: const Text('Add a task'),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      body: _children[_currentIndex],
      body: TabBarView(
          controller: _controller,
          children: _allPages.map<Widget>((_Page page) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Container(
                key: ObjectKey(page.widget),
                padding: const EdgeInsets.all(12.0),
                child: page.widget
              ),
            );
          }).toList()
      ),
      bottomNavigationBar: BottomAppBar(
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
                              leading: new Icon(Icons.music_note),
                              title: new Text('Music'),
                              onTap: () {
                                _controller.animateTo(0);
                                Navigator.pop(context);
                              },
                            ),
                            new ListTile(
                              leading: new Icon(Icons.photo_album),
                              title: new Text('Photos'),
                              onTap: () {
                                _controller.animateTo(1);
                                Navigator.pop(context);
                              },
                            ),
                            new ListTile(
                              leading: new Icon(Icons.videocam),
                              title: new Text('Video'),
                              onTap: () {
                                _controller.animateTo(2);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                }),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showBottomSheet(
                    context: context, builder: (BuildContext context) {
                  TextField(
                    onChanged: (text) {
                      print("First text field: $text");
                    },
                  );
                });
              },
            )
          ],
        ),
      ),
    );
  }



 */

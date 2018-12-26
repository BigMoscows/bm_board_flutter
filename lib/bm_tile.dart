import 'package:flutter/material.dart';
import 'package:bm_board/bm.dart';
import 'package:audioplayers/audio_cache.dart';

class BMTile extends StatelessWidget {
  final BM bmItem;
  final AudioCache player;

  const BMTile({
    Key key,
    @required this.bmItem,
    @required this.player,
  })  : assert(bmItem != null),
        assert(player != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Row(
          children: <Widget>[
            Text(bmItem.name),
            IconButton(
              icon: new Icon(Icons.play_arrow),
              onPressed: () {
                print('item pressed');
                player.play(bmItem.audioLocation);
              },
            )
          ],
        ),
      ),
    );
  }
}

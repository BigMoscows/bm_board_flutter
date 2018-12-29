import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bm_board/bm.dart';
import 'package:flutter/material.dart';

class BMTile extends StatefulWidget {
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
  State<StatefulWidget> createState() => BMTileState();
}

class BMTileState extends State<BMTile> {
  bool _playing = false;
  AudioPlayer _audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        decoration: new BoxDecoration(
          color: Colors.grey.shade300.withOpacity(0.3),
          borderRadius: new BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.bmItem.name),
            IconButton(
              icon:
                  _playing ? new Icon(Icons.stop) : new Icon(Icons.play_arrow),
              onPressed: () {
                if (!_playing) {
                  setState(() {
                    _playing = true;
                  });
                  widget.player
                      .play(widget.bmItem.audioLocation)
                      .then((result) {
                    setState(() {
                      _audioPlayer = result;
                      result.completionHandler = () {
                        print("Stopped");
                        setState(() {
                          _playing = false;
                        });
                      };
                    });
                  });
                } else {
                  setState(() {
                    _playing = false;
                  });
                  _audioPlayer.stop();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

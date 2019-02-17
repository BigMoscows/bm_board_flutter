import 'package:bm_board/src/data/blash_repository.dart';
import 'package:bm_board/src/models/bm.dart';
import 'package:flutter/material.dart';

class BMTile extends StatefulWidget {
  final BM bmItem;

  const BMTile({
    Key key,
    @required this.bmItem,
  })  : assert(bmItem != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => BMTileState();
}

class BMTileState extends State<BMTile> {
  bool _playing = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: new BoxDecoration(
          color: widget.bmItem.blasphemy
              ? Colors.red.withOpacity(0.7)
              : Colors.grey.shade300.withOpacity(0.3),
          borderRadius: new BorderRadius.circular(5.0),
        ),
        child: InkWell(
          onTap: () {
            if (!_playing) {
              setState(() {
                _playing = true;
              });
              BlasphRepository()
                  .player
                  .play(widget.bmItem.audioLocation)
                  .then((result) {
                setState(() {
                  result.completionHandler = () {
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
            }
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.bmItem.name,
                  style: widget.bmItem.blasphemy
                      ? TextStyle(color: Colors.white)
                      : TextStyle(color: Colors.black),
                ),
                IconButton(
                  icon: _playing
                      ? new Icon(
                          Icons.stop,
                          color: widget.bmItem.blasphemy
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey,
                        )
                      : new Icon(
                          Icons.play_arrow,
                          color: widget.bmItem.blasphemy
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

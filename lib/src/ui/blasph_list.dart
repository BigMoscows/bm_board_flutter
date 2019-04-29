import 'dart:async';

import 'package:bm_board/src/models/bm.dart';
import 'package:bm_board/src/ui/bm_tile.dart';
import 'package:flutter/material.dart';

class BlasphList extends StatefulWidget {
  final String emptyMessage;
  final Stream<List<BM>> blasphStream;

  BlasphList(this.blasphStream, this.emptyMessage);

  @override
  _BlasphListState createState() => _BlasphListState();
}

class _BlasphListState extends State<BlasphList>
    with AutomaticKeepAliveClientMixin<BlasphList> {
  // Prevent the recreation when changing tab
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: List<BM>(),
      stream: widget.blasphStream,
      builder: _buildBody,
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<List<BM>> snapshot) {
    // Decide if show data or the loader
    if (snapshot.hasData) {
      if (snapshot.data.isEmpty) {
        return Center(
          child: Text(widget.emptyMessage),
        );
      } else {
        // Check if the device is a tablet
        if (MediaQuery.of(context).size.shortestSide < 600) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return BMTile(bmItem: snapshot.data[index]);
            },
            itemCount: snapshot.data.length,
          );
        } else {
          // Build grid view
          int columns =
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 4
                  : 3;
          return GridView.count(
            crossAxisCount: columns,
            childAspectRatio: 3.0,
            children: snapshot.data.map((BM bm) {
              return BMTile(bmItem: bm);
            }).toList(),
          );
        }
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

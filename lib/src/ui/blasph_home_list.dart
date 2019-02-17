import 'package:bm_board/src/blocs/tiles_bloc_provider.dart';
import 'package:bm_board/src/models/bm.dart';
import 'package:bm_board/src/ui/bm_tile.dart';
import 'package:flutter/material.dart';

class BlasphHomeList extends StatefulWidget {
  @override
  BlasphHomeListState createState() {
    return new BlasphHomeListState();
  }
}

class BlasphHomeListState extends State<BlasphHomeList> with AutomaticKeepAliveClientMixin<BlasphHomeList> {

  // Prevent the recreation when changing tab
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final tilesBloc = TilesBlocProvider.of(context);
    return StreamBuilder(
      initialData: List<BM>(),
      stream: tilesBloc.blasphStream,
      builder: _buildBody,
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<List<BM>> snapshot) {
    // Decide if show data or the loader
    if (snapshot.hasData && snapshot.data.isNotEmpty) {
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
        return GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 3.0,
          children: snapshot.data.map((BM bm) {
            return BMTile(bmItem: bm);
          }).toList(),
        );
      }
    } else {

      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }


}

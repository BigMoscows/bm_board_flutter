import 'package:bm_board/src/blocs/tiles_bloc_provider.dart';
import 'package:bm_board/src/models/bm.dart';
import 'package:bm_board/src/ui/bm_tile.dart';
import 'package:flutter/material.dart';

class BlasphList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tilesBloc = TilesBlocProvider.of(context);

    return StreamBuilder<List<BM>>(
      // TODO: provide from BLOC
      initialData: List<BM>(),
      stream: tilesBloc.blasphStream,
      builder: _buildBody,
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<List<BM>> snapshot) {
    /* if (snapshot.data.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }*/
    //TODO: add loading
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('${snapshot.data[index].name}'),
        );
      },
    );
  }
}

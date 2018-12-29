import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:bm_board/bm.dart';
import 'package:bm_board/bm_tile.dart';
import 'package:flutter/material.dart';

void main() => runApp(BMBoard());

class BMBoard extends StatelessWidget {
  static const _title = 'BM Board';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  final _items = <BM>[];

  bool _loading = false;

  AudioCache player = new AudioCache(prefix: 'audio/');

  static const _sounds = <String>[
    'ahah.mp3',
    'austra.mp3',
    'blasphemy_0.mp3',
    'blasphemy_1.mp3',
    'blasphemy_2.mp3',
    'blasphemy_3.mp3',
    'brrr.mp3',
    'calm.mp3',
    'cant_understand_stuff.mp3',
    'diosss.mp3',
    'distracted.mp3',
    'do_again.mp3',
    'dog_x3.mp3',
    'dont_entry_0.mp3',
    'dont_entry_1.mp3',
    'dont_entry_2.mp3',
    'door_0.mp3',
    'door_1.mp3',
    'door_3.mp3',
    'dots_and_capital_less.mp3',
    'dunno.mp3',
    'each_start.mp3',
    'ex_deputy_major.mp3',
    'fantoni_score.mp3',
    'fuck.mp3',
    'gaetano.mp3',
    'goodmorning.mp3',
    'goodnight.mp3',
    'head_breaker.mp3',
    'hope_0.mp3',
    'hope_1.mp3',
    'if_i_dont_blaspheme_look.mp3',
    'iron_toucher.mp3',
    'it_was_beauty.mp3',
    'lets_go.mp3',
    'long_field.mp3',
    'lot_of_time.mp3',
    'madonna_0.mp3',
    'madonna_1.mp3',
    'no_nobody_jesus_christ.mp3',
    'of_god.mp3',
    'paparapapapa.mp3',
    'passed_and_gone.mp3',
    'phone.mp3',
    'pig_x3.mp3',
    'punch.mp3',
    'repeat_again.mp3',
    'retry_because_bubu.mp3',
    'romano_0.mp3',
    'romano_1.mp3',
    'short_was_written.mp3',
    'sigh.mp3',
    'simpaty_cortesy.mp3',
    'six_ahead_length.mp3',
    'sneeze.mp3',
    'table.mp3',
    'thinking_listening.mp3',
    'tu_quoque.mp3',
    'vocalizations.mp3',
    'wait_a_moment.mp3',
    'watta_kind_of_news.mp3',
    'why_you_blaspheme.mp3',
    'will_found.mp3',
  ];

  static const _labels = <String>[
    // The starting comments are used only for reference with the audio files
    /*ahah*/ 'Ah Ah',
    /*austra*/ 'Austra',
    /*blasphemy_0*/ 'Blasphemy 0',
    /*blasphemy_1*/ 'Blasphemy 1',
    /*blasphemy_2*/ 'Blasphemy 2',
    /*blasphemy_3*/ 'Blasphemy 3',
    /*brrr*/ 'Brrr',
    /*calm*/ 'Calm',
    /*cant_understand_stuff*/ 'Can\'t understand stuff',
    /*diosss*/ 'Diosss',
    /*distracted*/ 'Distracted',
    /*do_again*/ 'Do again',
    /*dog_x3*/ 'Dog X3',
    /*dont_entry_0*/ 'Don\'t entry 0',
    /*dont_entry_1*/ 'Don\'t entry 1',
    /*dont_entry_2*/ 'Don\'t entry 2',
    /*door_0*/ 'Door 0',
    /*door_1*/ 'Door 1',
    /*door_2*/ 'Door 2',
    /*dots_and_capital_less*/ 'Dots and capital less',
    /*dunno*/ 'Don\'t know',
    /*each_start*/ 'Each start',
    /*ex_deputy_major*/ 'Ex deputy major',
    /*fantoni_score*/ 'Fantoni score',
    /*fuck*/ 'Fuck',
    /*gaetano*/ 'Gaetano',
    /*goodmorning*/ 'Good Morning',
    /*goodnight*/ 'Good Night',
    /*head_breaker*/ 'Head Breaker',
    /*hope_0*/ 'Hope 0',
    /*hope_1*/ 'Hope 1 ',
    /*if_i_dont_blaspheme_look*/ 'If I dont\' blaspheme look',
    /*iron_toucher*/ 'Iron toucher',
    /*it_was_beauty*/ 'It was beauty',
    /*lets_go*/ 'Let\'s go',
    /*long_field*/ 'Long Field',
    /*lot_of_time*/ 'Lot\'s of time',
    /*madonna_0*/ 'Madonna 0',
    /*madonna_1*/ 'Madonna 1',
    /*no_nobody_jesus_christ*/ 'No nobody, Jesus Christ',
    /*of_god*/ 'De dio',
    /*paparapapapa*/ 'Paparapapapa',
    /*passed_and_gone*/ 'Passed and gone',
    /*phone*/ 'Phone',
    /*pig_x3*/ 'Pig X3',
    /*punch*/ 'Punch',
    /*repeat_again*/ 'Repeat Again',
    /*retry_because_bubu*/ 'Retry because Bubu',
    /*romano_0*/ 'Romano 0',
    /*romano_1*/ 'Romano 1',
    /*short_was_written*/ 'Short was written',
    /*sigh*/ 'Sigh',
    /*simpaty_cortesy*/ 'Simpaty courtesy',
    /*six_ahead_length*/ 'Six ahead length',
    /*sneeze*/ 'Sneeze',
    /*table*/ 'Table',
    /*thinking_listening*/ 'Thinking Listening',
    /*tu_quoque*/ 'Tu quoqu',
    /*vocalizations*/ 'Vocalizations',
    /*wait_a_moment*/ 'Wait a moment',
    /*watta_kind_of_news*/ 'What a kind of news',
    /*why_you_blaspheme*/ 'Why you blaspheme',
    /*will_found*/ 'Will Found',
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    setState(() {
      _loading = true;
    });
    List<File> fileList = await player.loadAll(_sounds);
    print('Loading finished');
    if (fileList.isNotEmpty) {
      setState(() {
        _loading = false;
      });
      for (var i = 0; i < _sounds.length; i++) {
        _items.add(BM(name: _labels[i], audioLocation: _sounds[i]));
      }
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
      // TODO: improve with a grid layout
      return GridView.count(
        crossAxisCount: 3,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: _loading
              ? bodyProgress
              : _buildBMItems(MediaQuery.of(context).size.shortestSide),
        ));
  }
}

import 'dart:async';
import 'dart:io';
import 'package:bm_board/src/blocs/tiles_bloc.dart';
import 'package:bm_board/src/utils/dsn.dart';
import 'package:bm_board/src/style/app_theme.dart';
import 'package:bm_board/src/ui/bm_scaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

final SentryClient _sentry = new SentryClient(dsn: dsn);

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');
  _sentry.captureException(exception: error, stackTrace: stackTrace);
}

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BM Board',
      theme: appTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final tilesBloc = TilesBloc();


  @override
  void initState() {
    super.initState();
    listenForFirebaseMessages();
  }

  @override
  void dispose() {
    super.dispose();
    tilesBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BMScaffold();
  }
}

void listenForFirebaseMessages() {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  if (Platform.isAndroid) {
    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        const url = 'https://install.appcenter.ms/users/prof18/apps/bm-board/distribution_groups/testers';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      onResume: (Map<String, dynamic> message) async {
        const url = 'https://install.appcenter.ms/users/prof18/apps/bm-board/distribution_groups/testers';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
}

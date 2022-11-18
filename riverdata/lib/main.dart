import 'package:flutter/material.dart';

void main() => runApp(App08Main());

class App08Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    for (var i = 0; i < 25; i++) {}
    return MaterialApp(
      home: MovieTitlePage(),
    );
  }
}

var movies = List<Movie>.empty(
  growable: true,
);

// Don't forget to show them how to get movie info from db
// Also, why you don't want the main page to block

class Movie {
  int index = 0;
  bool like = false;
  bool likeKnown = false;

  Movie(
      this.index,
      this.like,
      this.likeKnown,
      );
}

class MovieTitlePage extends StatefulWidget {
  @override
  MovieTitlePageState createState() => MovieTitlePageState();
}

class MovieTitlePageState extends State<MovieTitlePage> {
  @override
  initState() {
    super.initState();
    for (var i = 1; i <= 50; i++) {
      movies.add(
        Movie(
          i,
          false,
          false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'States 1-50',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: buildTitlePageCore(),
        ),
      ),
    );
  }

  goToDetailPage(Movie movie) async {
    Movie newMovie = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(),
        settings: RouteSettings(
          arguments: movie,
        ),
      ),
    );
    movie
      ..index = newMovie.index
      ..like = newMovie.like
      ..likeKnown = newMovie.likeKnown;
    setState(() {});
  }

  Widget buildTitlePageCore() {
    return ListView(
      children: <Widget>[
        for (var movie in movies)
          ListTile(
            title: Row(
              children: [
                SizedBox(
                  width: 30,
                ),
                Text(
                  'State ${movie.index}',
                  textScaleFactor: 2.0,
                ),
              ],
            ),
            onTap: () => goToDetailPage(movie),
          ),
      ],
    );
  }
}

class DetailPage extends StatefulWidget {
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: buildDetailPageCore(context),
        ),
      ),
    );
  }

  var switchState = false;
  var fromMainPage = true;

  setSwitch(newValue) {
    fromMainPage = false;
    setState(() {
      switchState = newValue;
    });
  }

  Widget buildDetailPageCore(context) {
    var movie = ModalRoute
        .of(context)!
        .settings
        .arguments as Movie;
    var sequelNumber = movie.index;
    if (fromMainPage) switchState = movie.like;
    final overview =
        'The $sequelNumber${getSuffix(sequelNumber as int)} state in our list ';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          overview,
          textScaleFactor: 2.0,
        ),
        ElevatedButton(
            child: Text(
              'Go Back',
              textScaleFactor: 1.5,
            ),
            onPressed: () {
              Navigator.pop(
                context,
                Movie(
                  sequelNumber,
                  switchState,
                  true,
                ),
              );
            }),
      ],
    );
  }

  String getSuffix(int sequelNumber) {
    String suffix;
    switch (sequelNumber) {
      case 1:
      case 21:
      case 31:
      case 41:
        suffix = 'st';
        break;
      case 2:
      case 22:
      case 32:
      case 42:
        suffix = 'nd';
        break;
      case 3:
      case 23:
      case 33:
      case 43:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
    return suffix;
  }
}
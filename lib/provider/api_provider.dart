import 'package:http/http.dart' as http;
import 'dart:convert' show json, jsonDecode;

import 'package:search/models/movies.dart';

class MoviesAPI {
  List<Movies> mymovies = [];

  processMovieInfos(
    movieList,
  ) async {
    mymovies = [];
    for (int i = 0; i < movieList.length; i++) {
      Movies movie =
          Movies(movieName: '', movieYear: '', movieID: '', imageLink: '');
      movie.movieName = movieList[i]['title'];
      movie.movieYear = movieList[i]['description'];
      movie.movieID = movieList[i]['id'];
      movie.imageLink = movieList[i]['image'];

      mymovies.add(movie);
      print(mymovies[i].movieName);
    }
    print('length : ${mymovies.length}');
  }

  void getallMovieDetailsFromServer() async {
    var url = 'https://imdb-api.com/en/API/Search/k_jdss7eo7/{queary}';

    var response;
    var responseDetails;
    response = await http.get(Uri.parse(url));
    if (response.statusCode == 200 || response.statusCode == 204) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> movieList = data["results"];
      processMovieInfos(movieList);
      // print('legth : ${data.length}');
      // responseDetails = json.decode(response.body);
      // print('respopnseDetails:${responseDetails}');
      // String data = responseDetails["results"]['id'];
      // print('data${token}');
    } else {
      print('api call failed');
    }
  }
}

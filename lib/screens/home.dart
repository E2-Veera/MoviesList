import 'package:flutter/material.dart';
import 'package:search/models/movies.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, jsonDecode;

import 'package:search/screens/detail.dart';

class HomePageMovies extends StatefulWidget {
  const HomePageMovies({Key? key}) : super(key: key);

  @override
  State<HomePageMovies> createState() => _HomePageMoviesState();
}

class _HomePageMoviesState extends State<HomePageMovies> {
  TextEditingController searchController = TextEditingController();

  List<Movies> mymovies = [];
  List<Movies> _foundUsers = [];

  @override
  void initState() {
    getallMovieDetailsFromServer();
    refreshtheInitialUI();
    super.initState();
  }

  void refreshtheInitialUI() {
    setState(() {
      _foundUsers = mymovies;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Movies> results = [];
    if (enteredKeyword.isEmpty) {
      results = mymovies;
      print('the result : ${results}');
    } else {
      results = mymovies
          .where((user) => user.movieName
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundUsers = results;
    });
  }

  // Future<dynamic> addMovieNameIntoList(movieList) async {
  //   movieNameList = [];
  //   for (int j = 0; j < movieList.length; j++) {
  //     var movieName = movieList[j]['title'];
  //     movieNameList.add(movieName);
  //     // print('name list : ${movieNameList}');
  //   }
  //   return movieNameList;
  // }

  Future<dynamic> processMovieInfos(
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
      _foundUsers.clear();
      _foundUsers.addAll(mymovies);
    }
    print('length : ${mymovies.length}');

    return mymovies;
  }

  void getallMovieDetailsFromServer() async {
    try {
      var url = 'https://imdb-api.com/en/API/Search/k_jdss7eo7/{queary}';
      var response;
      var responseDetails;
      response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 || response.statusCode == 204) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> movieList = data["results"];

        setState(() {
          processMovieInfos(movieList);
        });
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget inputsearch = TextField(
      onChanged: ((value) {
        _runFilter(value);
      }),
      controller: searchController,
      decoration: const InputDecoration(
        labelText: "Search",
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(Icons.search, color: Colors.black),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: inputsearch,
            ),
            Container(
              height: 680,
              width: double.infinity,
              child: mymovies.isEmpty
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Loading...   ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          CircularProgressIndicator(),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _foundUsers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 150,
                                    width: 130,
                                    child: Image.network(
                                      _foundUsers[index].imageLink,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Container(
                                    width: 200,
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _foundUsers[index].movieName,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 9,
                                        ),
                                        Text(_foundUsers[index].movieYear),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => Details(
                                          index: index,
                                          mymovies: _foundUsers,
                                        )));
                              },
                            ),
                          ),
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}

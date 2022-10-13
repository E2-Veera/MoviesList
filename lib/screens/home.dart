import 'package:flutter/material.dart';
import 'package:search/models/movies.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, jsonDecode;

class HomePageMovies extends StatefulWidget {
  const HomePageMovies({Key? key}) : super(key: key);

  @override
  State<HomePageMovies> createState() => _HomePageMoviesState();
}

class _HomePageMoviesState extends State<HomePageMovies> {
  TextEditingController searchController = TextEditingController();

  List<Movies> mymovies = [];
  bool isFetchdata = false;
  @override
  void initState() {
    getallMovieDetailsFromServer();
    super.initState();
  }

  // void searchFunction() {
  //   if (mymovies.contains(searchController.text)) {
  //     print('Search found');
  //   } else {
  //     print('Search Not found');
  //   }
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

      isFetchdata = true;
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
        if (mymovies.contains(value)) {
          print('Search found');
        } else {
          print('Not found movies');
        }
      }),
      controller: searchController,
      decoration: const InputDecoration(
        labelText: "Search",
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black,
        ),
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
                      itemCount: mymovies.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Column(
                            children: [
                              Container(
                                  height: 300,
                                  width: double.infinity,
                                  child:
                                      Image.network(mymovies[index].imageLink)),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                mymovies[index].movieName,
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          subtitle: Text(mymovies[index].movieYear),
                          onTap: () {
                            Navigator.pushNamed(context, '/details');
                          },
                        );
                      }),
            ),
          ],
        ),
      ),
    );
  }
}


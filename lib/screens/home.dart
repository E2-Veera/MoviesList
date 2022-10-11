import 'package:flutter/material.dart';
import '../provider/api_provider.dart';

class HomePageMovies extends StatefulWidget {
  const HomePageMovies({Key? key}) : super(key: key);

  @override
  State<HomePageMovies> createState() => _HomePageMoviesState();
}

class _HomePageMoviesState extends State<HomePageMovies> {
  TextEditingController searchController = TextEditingController();
  MoviesAPI apiProvider = MoviesAPI();

  @override
  void initState() {
    apiProvider.getallMovieDetailsFromServer();
    apiProvider.mymovies;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          labelText: "Search",
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      )),
      body: ListView.builder(
          itemCount: apiProvider.mymovies.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Column(
                children: [
                  Container(
                      height: 300,
                      width: double.infinity,
                      child:
                          Image.network(apiProvider.mymovies[index].imageLink)),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    apiProvider.mymovies[index].movieName,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Text(apiProvider.mymovies[index].movieYear),
            );
          }),
    );
  }
}

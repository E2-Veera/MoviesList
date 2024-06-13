import 'package:flutter/material.dart';
import 'package:search/models/movies.dart';

class Details extends StatefulWidget {
  final List<Movies> mymovies;
  final int index;
  const Details({Key? key, required this.mymovies, required this.index})
      : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mymovies[widget.index].movieName),
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                height: 300,
                width: 500,
                child: Image.network(
                  widget.mymovies[widget.index].imageLink,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                widget.mymovies[widget.index].movieName,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.mymovies[widget.index].movieYear.substring(
                  5,
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              width: 100,
              child: Card(
                color: Colors.blue,
                elevation: 2,
                child: Center(
                  child: Text(
                    widget.mymovies[widget.index].movieYear.substring(0, 4),
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

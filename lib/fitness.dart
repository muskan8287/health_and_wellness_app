import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gif_view/gif_view.dart'; // Import GifView package

class FitnessScreen extends StatefulWidget {
  @override
  _FitnessScreenState createState() => _FitnessScreenState();
}

class _FitnessScreenState extends State<FitnessScreen> {
  List<dynamic> exercises = [];
  List<String> gifFileNames = List.generate(10, (index) => 'assets/gifs/gif${index + 1}.gif');

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    final String apiUrl = 'https://exercisedb.p.rapidapi.com/exercises?limit=10';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "X-Rapidapi-Key": "403889ec54msh351e652c412353bp1e4306jsncb2beeb307b0",
        "X-Rapidapi-Host": "exercisedb.p.rapidapi.com",
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        exercises = json.decode(response.body);
      });
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fitness Screen',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF535878),
      ),
      backgroundColor: Color(0xFF535878),
      body: exercises.isEmpty
          ? Center(child: CircularProgressIndicator())
          : CarouselSlider.builder(
        itemCount: exercises.length,
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
          autoPlay: true,
        ),
        itemBuilder: (BuildContext context, int index, int realIndex) {
          final exercise = exercises[index];
          final gifIndex = index % gifFileNames.length;
          final gifFileName = gifFileNames[gifIndex];
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(8),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 290,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF535878),
                        width: 2.0,
                      ),
                    ),
                    child: GifView.asset(
                      gifFileName,
                      fit: BoxFit.cover,
                      // No errorBuilder since GifView handles errors internally
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${exercise['name']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Body Part: ${exercise['bodyPart']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Target: ${exercise['target']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          exercise['instructions'].length,
                              (index) => Text(
                            '${index + 1}. ${exercise['instructions'][index]}',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

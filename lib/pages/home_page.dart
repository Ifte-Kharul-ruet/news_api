import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ts_news/pages/models.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List<NewsQueryModel> newModelList = [];
  List<String> navBarItem = [
    'Top News',
    'Bangladesh',
    'World',
    'Finance',
    'Health'
  ];
  getNewsByQuery(String query) async {
    String url =
        'https://newsapi.org/v2/everything?q=$query&from=2021-11-25&to=2021-11-25&sortBy=popularity&apiKey=77c216c476d4411d8f2939834f75ab0b';
    var response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data['articles'].forEach((element) {
        // print(element);
        NewsQueryModel newsQueryModel = NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newModelList.add(newsQueryModel);
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    getNewsByQuery('tesla      ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> newsSuggestion = [
      'Corona',
      'Local',
      'International',
      'Recent Issues'
    ];
    String suggest = newsSuggestion[Random().nextInt(newsSuggestion.length)];
    return Scaffold(
      appBar: AppBar(
        title: const Text('TS News'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //Search Bar
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              //color: Colors.grey,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print('Search me');
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                      child: const Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (val) {
                        print(val);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search $suggest',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ), //Search Container Finished
            Container(
              height: 50,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navBarItem.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        print(navBarItem[index]);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 5,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            navBarItem[index],
                            style: const TextStyle(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  }),
            ), //Finished Navigation Controller
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: CarouselSlider(
                items: _items.map((item) {
                  return Builder(builder: (BuildContext context) {
                    return Container(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/news.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black12.withOpacity(0),
                                      Colors.black,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Text(
                                  'New Headlline',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
                }).toList(),
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.25,
                  autoPlay: true,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                ),
              ),
            ), //Slider Finished
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Latest News',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                  //Start Here
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newModelList.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                      newModelList[index].newsImg),
                                ),
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black12.withOpacity(0),
                                            Colors.black,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            newModelList[index].newsHead,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            newModelList[index].newsDes.length >
                                                    50
                                                ? newModelList[index]
                                                    .newsDes
                                                    .substring(0, 55)
                                                : newModelList[index].newsDes,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {}, child: Text('Show More'))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Color> _items = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.grey,
    Colors.black,
  ];
}

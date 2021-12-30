import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipezilla_app/models/recipe_model.dart';
import 'package:recipezilla_app/secret.dart';
import 'package:recipezilla_app/views/recipe_details.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipeModel> recipes = new List<RecipeModel>.empty();

  TextEditingController textEditingController = new TextEditingController();

  getRecipes(query) async {
    recipes = [];
    var url1 =
        "https://api.edamam.com/search?q=$query&app_id=$appId&app_key=$appKey";
    // var response = await http.get(url);
    final Uri url = Uri.parse(url1);
    final response = await http.get(url);
    // var response = await http
    //     .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    print(jsonData);

    jsonData["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel(
          image: "image", label: "label", source: "source", url: "url");
      recipeModel = RecipeModel.fromMap(element['recipe']);

      recipes.add(recipeModel);
    });

    setState(() {});
  }

  Widget recipeGrid() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        padding: EdgeInsets.only(top: 16),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 25, crossAxisSpacing: 30, crossAxisCount: 2),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeTile(
              imgUrl: recipes[index].image,
              label: recipes[index].label,
              recipeDetailsUrl: recipes[index].url,
              source: recipes[index].source);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Color(0xFF210cae).withOpacity(0.75),
        title: Center(
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 4.2,
              ),
              Icon(
                Icons.youtube_searched_for_outlined,
              ),
              SizedBox(
                width: 7,
              ),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Recipe'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OleoScript',
                        letterSpacing: 0.4,
                      ),
                    ),
                    TextSpan(
                      text: 'Zilla'.toUpperCase(),
                      style: TextStyle(
                          color: Color(0xFF4dc9e6),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OleoScript'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 24, right: 16, left: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF4dc9e6).withOpacity(0.9),
                Color(0xFF210cae).withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            children: [
              Text(
                "What would you like to eat today?",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          hintText: "Enter food item",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        getRecipes(textEditingController.text);
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              recipeGrid()
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final String label, source, imgUrl, recipeDetailsUrl;
  RecipeTile(
      {required this.imgUrl,
      required this.label,
      required this.recipeDetailsUrl,
      required this.source});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeDetails(recipeDetailsUrl)));
      },
      child: Container(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                image: NetworkImage(imgUrl),
              ),
            ),
            Container(
              // color: Colors.white.withOpacity(0.6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF4dc9e6).withOpacity(0.65),
              ),
              height: 42,
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 5),
                  Text(
                    label,
                    style: TextStyle(
                        color: Color(0xFF210cae),
                        fontSize: 15,
                        fontWeight: FontWeight.w900),
                  ),
                  // Text(
                  //   source,
                  //   style: TextStyle(color: Colors.black),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

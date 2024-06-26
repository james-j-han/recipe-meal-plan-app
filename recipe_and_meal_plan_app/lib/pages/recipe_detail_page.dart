import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_and_meal_plan_app/database_helper.dart';
import 'package:recipe_and_meal_plan_app/recipe.dart';

class RecipeDetail extends StatefulWidget {
  final Isar isar;
  final Recipe recipe;

  const RecipeDetail({super.key, required this.isar, required this.recipe});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> with SingleTickerProviderStateMixin {
  late DatabaseHelper databaseHelper;
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    databaseHelper = Provider.of<DatabaseHelper>(context, listen: false);
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.recipe.title!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0, color: Color(0xFF4D4D4D))),
        backgroundColor: const Color(0xFFDDEFDD),
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.5),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  widget.recipe.photoUrl!,
                  fit: BoxFit.cover,
                  height: 200.0,
                ),
              ],
            ),
            TabBar(
              controller: _controller,
              dividerColor: const Color.fromARGB(255, 239, 149, 156),
              indicatorColor: const Color.fromARGB(255, 239, 149, 156),
              labelColor: const Color.fromARGB(255, 239, 149, 156),
              unselectedLabelColor: const Color.fromARGB(255, 86, 77, 74),
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              tabs: const [
                Tab(
                  text: "Overview",
                ),
                Tab(text: "Ingredients",),
                Tab(text: "Directions",),
              ]
            ),
            buildTabBar(),
          ],
        ),
      ),
    );
  }

  Widget buildTabBar() {
    return Expanded(
      child: TabBarView(
        controller: _controller,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: buildOverviewTab(),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: buildIngredientsTab(),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: buildDirectionTab(),
          ),
          // buildIngredientsTab(),
          // buildDirectionTab(),
        ],
      ),
    );
  }

  Widget buildOverviewTab() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color.fromARGB(255, 239, 244, 250),
            ),
            child: ListTile(
              leading: SizedBox(
                height: 30.0,
                child: Image.asset(
                  "icons/serving.png",
                  color: const Color.fromARGB(255, 143, 199, 142),
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
              title: const Text(
                "Servings",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 86, 77, 74),
                ),
              ),
              trailing: const Text(
                "4",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 86, 77, 74),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color.fromARGB(255, 239, 244, 250),
            ),
            child: ListTile(
              leading: SizedBox(
                height: 30.0,
                child: Image.asset(
                  "icons/calories.png",
                  color: const Color.fromARGB(255, 143, 199, 142),
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
              title: const Text(
                "Calories per serving",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 86, 77, 74),
                ),
              ),
              trailing: Text(
                "${widget.recipe.calories}",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 86, 77, 74),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color.fromARGB(255, 239, 244, 250),
            ),
            child: ListTile(
              leading: SizedBox(
                height: 30.0,
                child: Image.asset(
                  "icons/time.png",
                  color: const Color.fromARGB(255, 143, 199, 142),
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
              title: const Text(
                "Total time",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 86, 77, 74),
                ),
              ),
              trailing: Text(
                "${widget.recipe.totalTimeMinutes}m",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 86, 77, 74),
                ),
              ),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text(
                    "Protein",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 86, 77, 74),
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  Text(widget.recipe.protein!, style: const TextStyle(fontSize: 40.0, color: Color.fromARGB(255, 239, 149, 156))),
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Carbs",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 86, 77, 74),
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  Text(
                    widget.recipe.carbs!,
                    style: const TextStyle(
                      fontSize: 40.0,
                      color: Color.fromARGB(255, 239, 149, 156),
                    )
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    "Fat",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 86, 77, 74),
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text(widget.recipe.fat!, style: const TextStyle(fontSize: 40.0, color: Color.fromARGB(255, 239, 149, 156))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildIngredientsTab() {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.recipe.ingredients!.length,
              itemBuilder: (context, index) => buildIngredientRow(widget.recipe.ingredients![index]),
            )
          ),
          Container(
            padding: const EdgeInsets.only(top: 2.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 239, 244, 250),
              ),
              onPressed: () {
                databaseHelper.addAllItems(widget.recipe.ingredients!);
                Navigator.pop(context);
                // _addAll(widget.recipe.ingredients!);
              },
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 30.0,
                      child: Image.asset(
                        "icons/add_bag.png",
                        color: const Color.fromARGB(255, 239, 149, 156),
                        colorBlendMode: BlendMode.srcIn,
                      ),
                    ),
                    const Text(
                      "Add all to grocery list",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 239, 149, 156),
                      ),
                    ),
                  ],
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildIngredientRow(String colData) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color.fromARGB(255, 239, 244, 250),
        ),
        child: ListTile(
          leading: SizedBox(
            height: 30.0,
            child: GestureDetector(
              onTap: () {
                final String ingredientName = colData;
                databaseHelper.addItem(ingredientName);
                // _addItem(ingredientName);
              },
              child: Image.asset(
                "icons/add_shopping.png",
                color: const Color.fromARGB(255, 143, 199, 142),
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
          title: Text(
            colData,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 86, 77, 74),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDirectionTab() {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.recipe.instructions!.length,
              itemBuilder: (context, index) => buildDirectionRow(index, widget.recipe.instructions![index]),
            )
          )
        ],
      )
    );
  }

  Widget buildDirectionRow(int index, String insData) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color.fromARGB(255, 239, 244, 250),
        ),
        child: ListTile(
          leading: SizedBox(
            width: 40.0,
            child: Text(
              (index + 1).toString(),
              style: const TextStyle(
                color: Color.fromARGB(255, 150, 171, 217),
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              )
            )
          ),
          title: Text(
            insData,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 86, 77, 74),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String>{

  // TODO: Get all categories from DB
  final categories = [
    "Controlling Abortion",
    "Lamb Survival",
    "Feeding Ewes",
    "Nutrition"
  ];

  final recents = [
    "Feeding Ewes",
    "Nutrition"
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
        onPressed: () => {query = ""},
        icon: const Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: () => {close(context, "done")},
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        )
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList;
    if (query.isEmpty) {
      suggestionList = recents;
    } else {
      suggestionList = categories.where((element) => element.toLowerCase().startsWith(query.toLowerCase())).toList();
    }
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
            onTap: () => {showResults(context)},
            leading: const Icon(Icons.pets),
            title: RichText(
              text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold
                ),
                children: [
                  TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: const TextStyle(color: Colors.grey)
                  )
                ],
              ),
            )
        )
    );
  }
}
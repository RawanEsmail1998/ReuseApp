import 'package:flutter/material.dart';
class DataSearch extends SearchDelegate<String>{

  @override


  final recentItems = ['item1','item2'] ;
  final items = ['item1']; // from database .
  @override
  List<Widget> buildActions(BuildContext context) {
    // action for app bar
    return [IconButton(
      icon: Icon(Icons.clear),
      onPressed: (){
        query = "";
      },
    ),];

  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading button in the left of app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone search for something.
    final suggestionList = query.isEmpty?recentItems:items;
    return ListView.builder(itemBuilder: (context,index)=>ListTile(
      title: Text(suggestionList[index]),
    ),
      itemCount: suggestionList.length,
    );
  }

}
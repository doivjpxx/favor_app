import 'package:favors/constants/mock_values.dart';
import 'package:favors/models/favor.dart';
import 'package:favors/pages/requests.dart';
import 'package:favors/widgets/card_item.dart';
import 'package:favors/widgets/favor_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavorsPage extends StatefulWidget {
  FavorsPage({Key key}) : super(key: key);

  @override
  FavorsPageState createState() => FavorsPageState();
}

class FavorsPageState extends State<FavorsPage> {
  List<Favor> pendingAnswerFavors;
  List<Favor> acceptedFavors;
  List<Favor> completedFavors;
  List<Favor> refusedFavors;

  @override
  void initState() {
    super.initState();

    pendingAnswerFavors = List();
    acceptedFavors = List();
    completedFavors = List();
    refusedFavors = List();

    loadFavors();
  }

  void loadFavors() {
    pendingAnswerFavors.addAll(mockPendingFavors);
    acceptedFavors.addAll(mockDoingFavors);
    completedFavors.addAll(mockCompletedFavors);
    refusedFavors.addAll(mockRefusedFavors);
  }

  static FavorsPageState of(BuildContext context) {
    return context.ancestorStateOfType(TypeMatcher<FavorsPageState>());
  }

  void refuseToDo(Favor favor) {
    setState(() {
      pendingAnswerFavors.remove(favor);

      refusedFavors.add(favor.copyWith(accepted: false));
    });
  }

  void acceptToDo(Favor favor) {
    setState(() {
      pendingAnswerFavors.remove(favor);

      acceptedFavors.add(favor.copyWith(accepted: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Your Favors"),
            bottom: TabBar(isScrollable: true, tabs: [
              _buildCategoryTab("Requests"),
              _buildCategoryTab("Doing"),
              _buildCategoryTab("Completed"),
              _buildCategoryTab("Refused")
            ]),
          ),
          body: TabBarView(
            children: [
              FavorsList(
                  title: "Pending Requests", favors: this.pendingAnswerFavors),
              FavorsList(title: "Doing", favors: this.acceptedFavors),
              FavorsList(title: "Completed", favors: this.completedFavors),
              FavorsList(title: "Refused", favors: this.refusedFavors)
            ],
          ),
          floatingActionButton: FloatingActionButton(
              heroTag: "request_favor",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RequestsFavorPage(
                          friends: mockFriends,
                        )));
              },
              tooltip: 'Ask a favor',
              child: Icon(Icons.add)),
        ));
  }

  Widget _buildCategoryTab(String title) {
    return Tab(
      child: Text(title),
    );
  }
}

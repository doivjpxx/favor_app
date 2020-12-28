import 'dart:math';

import 'package:favors/pages/detail.dart';
import 'package:flutter/material.dart';

import '../models/favor.dart';
import 'card_item.dart';

const kFavorCardMaxWidth = 450.0;

class FavorsList extends StatelessWidget {
  final String title;
  final List<Favor> favors;

  FavorsList({Key key, this.favors, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Padding(child: Text(title), padding: EdgeInsets.only(top: 16.0)),
      Expanded(child: _buildCardList(context))
    ]);
  }

  Widget _buildCardList(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardsPerRow = max(screenWidth ~/ kFavorCardMaxWidth, 1);

    if (screenWidth > 400) {
      return GridView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: favors.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          final favor = favors[index];
          return FavorCardItem(favor: favor);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2.8,
          crossAxisCount: cardsPerRow,
        ),
      );
    }

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: favors.length,
        itemBuilder: (BuildContext context, int index) {
          final favor = favors[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionDuration: Duration(seconds: 3),
                      pageBuilder: (_, __, ___) =>
                          FavorDetailsPage(favor: favor)));
            },
            child: FavorCardItem(favor: favor),
          );

          // return FavorCardItem(favor: favor);
        });
  }
}

import 'package:favors/models/favor.dart';
import 'package:favors/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavorCardItem extends StatelessWidget {
  final Favor favor;

  const FavorCardItem({Key key, this.favor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        key: ValueKey(favor.uuid),
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              _itemHeader(favor),
              Hero(
                tag: "description_${favor.uuid}",
                child: Text(favor.description),
              ),
              _itemFooter(context, favor)
            ])));
  }

  Row _itemHeader(Favor favor) {
    return Row(children: <Widget>[
      Hero(
        tag: "avatar_${favor.uuid}",
        child: CircleAvatar(
          backgroundImage: NetworkImage(
            favor.friend.photoURL,
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text("${favor.friend.name} asked you to.."),
        ),
      )
    ]);
  }

  Widget _itemFooter(BuildContext context, Favor favor) {
    if (favor.isCompleted) {
      final format = DateFormat();
      return Container(
          margin: EdgeInsets.only(top: 8.0),
          alignment: Alignment.centerRight,
          child: Chip(label: Text("Completed at: ")));
    }

    if (favor.isRequested) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        FlatButton(
          child: Text("Refused"),
          onPressed: () {
            FavorsPageState.of(context).refuseToDo(favor);
          },
        ),
        FlatButton(
          child: Text("Do"),
          onPressed: () {
            FavorsPageState.of(context).acceptToDo(favor);
          },
        )
      ]);
    }

    if (favor.isDoing) {
      return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        FlatButton(
          child: Text("give up"),
          onPressed: () {},
        ),
        FlatButton(
          child: Text("complete"),
          onPressed: () {},
        )
      ]);
    }

    return Container();
  }
}

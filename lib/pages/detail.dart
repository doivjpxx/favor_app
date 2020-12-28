import 'package:favors/models/favor.dart';
import 'package:flutter/material.dart';

class FavorDetailsPage extends StatefulWidget {
  final Favor favor;
  final String title;

  FavorDetailsPage({Key key, this.favor, this.title}) : super(key: key);

  @override
  _FavorDetailsPageState createState() => _FavorDetailsPageState();
}

class _FavorDetailsPageState extends State<FavorDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(context).textTheme.headline4;

    return Scaffold(
      body: Card(
          child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _itemHeader(context, widget.favor),
            Container(
              height: 16.0,
            ),
            Expanded(
                child: Center(
              child: Hero(
                tag: "description_${widget.favor.uuid}",
                child: Text(
                  widget.favor.description,
                  style: bodyStyle,
                ),
              ),
            ))
          ],
        ),
      )),
    );
  }

  Widget _itemHeader(BuildContext context, Favor favor) {
    final headerStyle = Theme.of(context).textTheme.headline3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Hero(
          tag: "avatar_${favor.uuid}",
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(favor.friend.photoURL),
          ),
        ),
        Container(
          height: 16.0,
        ),
        Text(
          "${favor.friend.name} asked you to..",
          style: headerStyle,
        )
      ],
    );
  }
}

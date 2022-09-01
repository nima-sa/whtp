import 'package:flutter/material.dart';
import 'dart:core';

class PersonListItem extends StatelessWidget {
  final Map<String, dynamic> person;
  final Function onTap;
  final Function onLongPress;
  PersonListItem(this.person, {this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(this.person['name']),
          trailing: Icon(Icons.chevron_right),
          subtitle: Text(double.parse(person['value']).abs().toString() +
              (double.parse(person['value']) >= 0 ? ' (my turn)' : ' (their turn)')),
          onTap: onTap,
          onLongPress: onLongPress,
        ),
        Divider(height: 0),
      ],
    );
  }
}

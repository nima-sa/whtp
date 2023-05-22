import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whtp/InsideScreen.dart';
import 'package:whtp/PersonListItem.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _listKey = GlobalKey<AnimatedListState>();
  List people = [];
  final _textController = TextEditingController();
  bool isInitiated = false;
  bool isEditing = false;

  void _savePeople() {
    SharedPreferences.getInstance().then((SharedPreferences mem) {
      final text = json.encode(people);
      mem.setString('people', text);
    });
  }

  void retrivePeople() {
    SharedPreferences.getInstance().then((SharedPreferences mem) {
      final people = mem.getString('people') ?? '[]';
      final tmpPeople = json.decode(people);
      for (Map<String, dynamic> person in tmpPeople) {
        this.people.add(person);
        _listKey.currentState.insertItem(this.people.length - 1);
      }
      // _listKey.currentState.reassemble();
    });
  }

  @override
  void initState() {
    super.initState();
    retrivePeople();
  }

  void _showInside(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsideScreen(
          person: people[index],
          onPersonUpdated: (person) {
            setState(() {
              this.people[index] = person;
            });
            _savePeople();
          },
        ),
      ),
    );
  }

  void _addPerson() {
    final dialog = AlertDialog(
      title: Text('Enter name'),
      content: TextField(
        autofocus: true,
        controller: _textController,
        decoration: InputDecoration(
          hintText: "name",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
          ),
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: Text('Add'),
          onPressed: () {
            final newID = people.length > 0
                ? people.map((e) => int.parse(e['id'])).reduce(max) + 1
                : 1;

            final person = {
              'id': '$newID',
              'name': _textController.text.trim(),
              'value': '0'
            };
            this._textController.clear();
            this.people.insert(0, person);
            _listKey.currentState.insertItem(0);
            _savePeople();
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  void _removePerson(int index) {
    final dialog = AlertDialog(
      title: Text('Delete ' + people[index]['name'] + '?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
          ),
          style: TextButton.styleFrom(
            primary:
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
          ),
        ),
        // FlatButton(
        //   textColor:
        //       MediaQuery.of(context).platformBrightness == Brightness.light
        //           ? Colors.black
        //           : Colors.white,
        //   child: Text('Cancel'),
        //   onPressed: () => Navigator.pop(context),
        // ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            primary: Colors.white,
          ),
          child: Text(
            'Delete',
            // style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            final removedPerson = this.people[index];
            this.people.removeAt(index);
            _listKey.currentState.removeItem(
              index,
              (context, animation) => PersonListItem(removedPerson),
            );
            SharedPreferences.getInstance().then((SharedPreferences mem) {
              mem.remove('history__' + removedPerson['id']);
            });
            _savePeople();
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  void once(BuildContext context) {
    if (people.length == 1) {
      _showInside(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitiated) {
      isInitiated = true;
      once(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Hold to delete' : 'Home'),
        // leading: IconButton(
        //     tooltip: isEditing ? 'End editting' : 'Start editing',
        //     icon: Icon(isEditing ? Icons.done : Icons.edit),
        //     onPressed: () => this.setState(() => isEditing = !isEditing)),
        actions: <Widget>[
          IconButton(
            tooltip: 'Add new person',
            onPressed: _addPerson,
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: people.length,
        itemBuilder: (context, index, animation) => PersonListItem(
          this.people[index],
          onTap: () => _showInside(index),
          onLongPress: () => _removePerson(index),
        ),
      ),
    );
  }
}

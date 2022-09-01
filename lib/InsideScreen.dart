import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class InsideScreen extends StatefulWidget {
  final Map<String, dynamic> person;
  final Function(Map<String, dynamic>) onPersonUpdated;
  InsideScreen({@required this.person, this.onPersonUpdated});
  @override
  _InsideScreenState createState() => _InsideScreenState();
}

class _InsideScreenState extends State<InsideScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 500);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));
  final _textController = TextEditingController();
  final _describeController = TextEditingController();
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
    _focus.addListener(_onFocusChange);

    retriveHistory();
  }

  void _onFocusChange() {
    _toggleHistory(forceClose: true);
  }

  List histories = [];

  void retriveHistory() {
    SharedPreferences.getInstance().then((SharedPreferences mem) {
      final people = mem.getString('history__' + widget.person['id']) ?? '[]';
      this.setState(() {
        this.histories = json.decode(people);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _describeHistory(int index, {BuildContext context}) {
    _describeController.text = histories[index]['description'] ?? '';
    _describeController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: histories[index]['description']?.length ?? 0);

    final dialog = AlertDialog(
      title: Text('Describe'),
      content: TextField(
        autofocus: true,
        controller: _describeController,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          textColor:
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
          child: Text(
            'Cancel',
          ),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Done'),
          onPressed: () {
            this.setState(() {
              this.histories[index]['description'] =
                  _describeController.text.trim();
            });
            this._describeController.clear();
            _saveHistory();
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  void _pay(bool me, [bool _double = false]) {
    if (_textController.text.isEmpty) {return;}
    var value = double.parse(_textController.text.trim());
    if (_double) {
      value *= 2;
    }

    final newID = histories.length > 0
        ? histories.map((e) => int.parse(e['id'])).reduce(max) + 1
        : 1;

    Map<String, dynamic> entery = {
      'id': '$newID',
      'value': (me ? -value : value).toString()
    };

    setState(() {
      widget.person['value'] =
          (double.parse(widget.person['value']) + (me ? -value / 2 : value / 2))
              .toString();

      histories.insert(0, entery);
    });
    widget.onPersonUpdated(widget.person);
    _textController.clear();
    FocusScope.of(context).requestFocus(FocusNode());

    _saveHistory();
  }

  void _saveHistory() {
    SharedPreferences.getInstance().then((SharedPreferences mem) {
      final text = json.encode(histories);
      mem.setString('history__' + widget.person['id'], text);
    });
  }

  Widget _makeHistoryView() {
    return Builder(
      builder: (context) => SizedBox.expand(
        child: SlideTransition(
          position: _tween.animate(_controller),
          child: DraggableScrollableSheet(
            minChildSize: 0.15,
            initialChildSize: 0.15,
            // maxChildSize: 0.80,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? MyApp.kWhiteThemeColor
                      : Colors.grey[900],
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 1),
                        blurRadius: 5)
                  ],
                ),
                child: Container(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: histories.length,
                    itemBuilder: (context, index) {
                      final history = histories[index];
                      return Dismissible(
                        key: Key(history['id']),
                        onDismissed: (DismissDirection direction) {
                          this.setState(() {
                            histories.removeAt(index);
                          });
                          _saveHistory();
                        },
                        secondaryBackground: Container(
                          padding: EdgeInsets.only(right: 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.delete, color: Colors.white)
                              ]),
                          color: Colors.red,
                        ),
                        background: Container(
                            padding: EdgeInsets.only(left: 16),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.delete, color: Colors.white),
                                ]),
                            color: Colors.red),
                        // empty space
                        // empty space
                        // empty space
                        child: Column(
                          children: <Widget>[
                            Material(
                              child: ListTile(
                                title: Text(
                                  double.parse(history['value'])
                                      .abs()
                                      .toString(),
                                  // style: TextStyle(color: Colors.white),
                                ),
                                subtitle: history['description'] != null
                                    ? Text(
                                        history['description'],
                                        // style: TextStyle(color: Colors.white),
                                      )
                                    : null,
                                trailing: Text(
                                  double.parse(history['value']) >= 0
                                      ? 'They'
                                      : 'Me',
                                  // style: TextStyle(color: Colors.white),
                                ),
                                // onTap: () =>
                                //     _describeHistory(index, context: context),
                                onLongPress: () =>
                                    _describeHistory(index, context: context),
                              ),
                            ),
                            Divider(height: 0),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _toggleHistory({bool forceClose = false}) {
    if (forceClose) {
      _controller.reverse();
      return;
    }
    if (_controller.isDismissed)
      _controller.forward();
    else if (_controller.isCompleted) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person['name']),
      ),
      floatingActionButton: GestureDetector(
        child: FloatingActionButton(
          child: AnimatedIcon(
              icon: AnimatedIcons.menu_close, progress: _controller),
          elevation: 5,
          onPressed: _toggleHistory,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragStart: (info) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(8, 64, 8, 8),
                child: Column(
                  children: <Widget>[
                    Text(
                      double.parse(widget.person['value']).abs().toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      double.parse(widget.person['value']) >= 0
                          ? 'My turn'
                          : 'Their turn',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 32),
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextField(
                        focusNode: _focus,
                        textAlign: TextAlign.center,

                        decoration: InputDecoration(
                          hintText: "amount",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        // inputFormatters: <TextInputFormatter>[
                        // WhitelistingTextInputFormatter.digitsOnly,
                        // ], //
                        controller: _textController,
                      ),
                    ),
                    SizedBox(height: 16),
                    FlatButton(
                      child:
                          Text('I paid', style: TextStyle(color: Colors.blue)),
                      onPressed: () => _pay(true),
                      onLongPress: () => _pay(true, true),
                    ),
                    FlatButton(
                      child: Text('They paid',
                          style: TextStyle(color: Colors.blue)),
                      onPressed: () => _pay(false),
                      onLongPress: () => _pay(false, true),
                    ),
                  ],
                ),
              ),
            ),
            // ttttt(),
            _makeHistoryView(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const Map<int, Color> kBColor = {
    50: Color.fromRGBO(2, 2, 2, 1),
    100: Color.fromRGBO(5, 5, 5, 1),
    200: Color.fromRGBO(11, 11, 11, 1),
    300: Color.fromRGBO(17, 17, 17, 1),
    400: Color.fromRGBO(22, 22, 22, 1),
    500: Color.fromRGBO(27, 27, 27, 1),
    600: Color.fromRGBO(32, 32, 32, 1),
    700: Color.fromRGBO(39, 39, 39, 1),
    800: Color.fromRGBO(45, 45, 45, 1),
    900: Color.fromRGBO(51, 51, 51, 1),
  };

  static const kThemeColor = MaterialColor(0xFF303030, kBColor);
  //
  //
  //

  static const Map<int, Color> kFColor = {
    50: Color.fromRGBO(2, 2, 2, 1),
    100: Color.fromRGBO(5, 5, 5, 1),
    200: Color.fromRGBO(11, 11, 11, 1),
    300: Color.fromRGBO(17, 17, 17, 1),
    400: Color.fromRGBO(22, 22, 22, 1),
    500: Color.fromRGBO(27, 27, 27, 1),
    600: Color.fromRGBO(32, 32, 32, 1),
    700: Color.fromRGBO(39, 39, 39, 1),
    800: Color.fromRGBO(45, 45, 45, 1),
    900: Color.fromRGBO(51, 51, 51, 1),
  };

  static const kAccentThemeColor = MaterialColor(0xFFAAAAAA, kBColor);

//
//
//

  static const Map<int, Color> kWhiteColor = {
    50: Color.fromRGBO(202, 202, 202, 1),
    100: Color.fromRGBO(205, 205, 205, 1),
    200: Color.fromRGBO(211, 211, 211, 1),
    300: Color.fromRGBO(217, 217, 217, 1),
    400: Color.fromRGBO(222, 222, 222, 1),
    500: Color.fromRGBO(227, 227, 227, 1),
    600: Color.fromRGBO(232, 232, 232, 1),
    700: Color.fromRGBO(239, 239, 239, 1),
    800: Color.fromRGBO(245, 245, 245, 1),
    900: Color.fromRGBO(251, 251, 251, 1),
  };

  static const kWhiteThemeColor = MaterialColor(0xFFFFFFFF, kBColor);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WHTP',
      theme: ThemeData(primarySwatch: kWhiteThemeColor),
      darkTheme: ThemeData.dark().copyWith(
          accentColor: kAccentThemeColor,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: kAccentThemeColor)),
      home: HomeScreen(),
      // home: ColorFiltersDemo(),
    );
  }
}

class ColorFiltersDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ColorFilterDemoState();
}

class ColorFilterDemoState extends State<ColorFiltersDemo> {
  int selectedBlendModeIndex = 0;

  Map<String, BlendMode> blendModeMap = Map();

  @override
  void initState() {
    super.initState();
    blendModeMap.putIfAbsent("Normal", () => BlendMode.clear);
    blendModeMap.putIfAbsent("Color Burn", () => BlendMode.colorBurn);
    blendModeMap.putIfAbsent("Color Dodge", () => BlendMode.colorDodge);
    blendModeMap.putIfAbsent("Saturation", () => BlendMode.saturation);
    blendModeMap.putIfAbsent("Hue", () => BlendMode.hue);
    blendModeMap.putIfAbsent("Soft light", () => BlendMode.softLight);
    blendModeMap.putIfAbsent("Overlay", () => BlendMode.overlay);
    blendModeMap.putIfAbsent("Multiply", () => BlendMode.multiply);
    blendModeMap.putIfAbsent("Luminosity", () => BlendMode.luminosity);
    blendModeMap.putIfAbsent("Plus", () => BlendMode.plus);
    blendModeMap.putIfAbsent("Exclusion", () => BlendMode.exclusion);
    blendModeMap.putIfAbsent("Hard Light", () => BlendMode.hardLight);
    blendModeMap.putIfAbsent("Lighten", () => BlendMode.lighten);
    blendModeMap.putIfAbsent("Screen", () => BlendMode.screen);
    blendModeMap.putIfAbsent("Modulate", () => BlendMode.modulate);
    blendModeMap.putIfAbsent("Difference", () => BlendMode.difference);
    blendModeMap.putIfAbsent("Darken", () => BlendMode.darken);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage('assets/pic.png'),
            ),
            backgroundBlendMode: BlendMode.hardLight,
            color: Colors.red,
            // gradient: LinearGradient(colors: [Colors.red, Colors.blue]),
          ),
          child: Center(
              child: Text(
            'nima',
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
      //   home: Scaffold(
      //     body: Stack(
      //       children: <Widget>[
      //         Image.asset(
      //           "pic.png",
      //           height: double.maxFinite,
      //           width: double.maxFinite,
      //           fit: BoxFit.fitHeight,
      //           color: selectedBlendModeIndex == 0 ? null : Colors.red,
      //           colorBlendMode: selectedBlendModeIndex == 0
      //               ? null
      //               : blendModeMap.values.elementAt(selectedBlendModeIndex),
      //         ),
      //         Positioned(
      //           left: 0.0,
      //           bottom: 0.0,
      //           height: 100.0,
      //           right: 0.0,
      //           child: Container(
      //             color: Colors.black.withOpacity(0.5),
      //             child: Center(
      //               child: Container(
      //                 margin: EdgeInsets.only(bottom: 20.0),
      //                 height: 40.0,
      //                 child: ListView.builder(
      //                   padding: EdgeInsets.symmetric(horizontal: 8.0),
      //                   shrinkWrap: true,
      //                   scrollDirection: Axis.horizontal,
      //                   itemCount: blendModeMap.keys.length,
      //                   itemBuilder: (context, index) {
      //                     return Container(
      //                       padding: EdgeInsets.all(4.0),
      //                       child: ChoiceChip(
      //                           padding: EdgeInsets.symmetric(
      //                               horizontal: 8.0, vertical: 0.0),
      //                           labelStyle: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: (selectedBlendModeIndex == index)
      //                                   ? 15.0
      //                                   : 13.0,
      //                               fontWeight: (selectedBlendModeIndex == index)
      //                                   ? FontWeight.bold
      //                                   : FontWeight.normal),
      //                           backgroundColor: Colors.black.withOpacity(0.8),
      //                           selectedColor: Colors.blue,
      //                           label: Center(
      //                             child: Text(blendModeMap.keys.elementAt(index)),
      //                           ),
      //                           selected: selectedBlendModeIndex == index,
      //                           onSelected: (bool selected) {
      //                             setState(() {
      //                               selectedBlendModeIndex =
      //                                   selected ? index : null;
      //                             });
      //                           }),
      //                     );
      //                   },
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
    );
  }
}

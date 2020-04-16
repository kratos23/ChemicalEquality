import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'formula_input.dart';

void main() => runApp(MyApp());

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child,
          );
        },
        title: 'Уравниватель реакций',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          accentColor: Colors.indigoAccent,
          primaryColorBrightness: Brightness.dark,
          accentColorBrightness: Brightness.dark,
        ),
        home: MyHomePage(title: 'Уравниватель реакций'),
        themeMode: ThemeMode.light,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ru'),
          Locale('en')
        ]);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var myController = TextEditingController();

  void formulaSubmit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: ListView(
            children: <Widget>[FormulaInputWidget(this.formulaSubmit)],

          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marvel_characters/descriptionScreen.dart';

Future<void> main() async {
  // to transparent
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: "Revalia"),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List characters = [];

  TextStyle _textStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  Widget _itemBuilder(BuildContext context, int index) {
    Size screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DescriptionScreen(
                      id: characters[index],
                    )))
      },
      child: Container(
        height: 80,
        width: screenSize.width,
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            characters[index],
            style: _textStyle,
            textAlign: TextAlign.center,
          ),
          width: screenSize.width - 40,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6f00ff), Color(0xFF9d00ff)],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                offset: const Offset(
                  0,
                  5,
                ),
                blurRadius: 5.0,
                spreadRadius: 3.0,
              ), //BoxShadow
            ],
          ),
        ),
      ),
    );
  }

  Widget separatorBuilder(BuildContext context, int index) {
    return Divider(
      height: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection("characters").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
            try {
              snapshot.data!.docs.forEach((element) {
                characters.add(element.get("name"));
              });
            } catch (Exception) {
              return Container(
                child: Text("error"),
              );
            }
            return Container(
              width: screenSize.width,
              height: screenSize.height - 25,
              margin: EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF9d00ff), Color(0xFF6f00ff)],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.separated(
                        itemBuilder: _itemBuilder,
                        separatorBuilder: separatorBuilder,
                        itemCount: characters.length),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

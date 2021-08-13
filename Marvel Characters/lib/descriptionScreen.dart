import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DescriptionScreen extends StatelessWidget {
  String id = "";
  DescriptionScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    var data = {};
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(r"characters")
              .where("name", isEqualTo: id)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            try {
              snapshot.data?.docs.forEach((element) {
                element.data().forEach((key, value) {
                  data[key] = value + "\n";
                });
              });
            } catch (Exception) {}
            return Container(
              width: screenSize.width,
              height: screenSize.height,
              margin: EdgeInsets.only(top: 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF9d00ff), Color(0xFF6f00ff)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    alignment: Alignment.center,
                    child: Text(data["name"] ?? "name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          // letterSpacing: 2,
                        )),
                  ),
                  Container(
                    height: screenSize.height - 160,
                    width: screenSize.width - 25,
                    decoration: BoxDecoration(
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
                          ),
                        ]),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        data["description"] ?? "des",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, color: Colors.white, height: 1.5),
                        softWrap: true,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

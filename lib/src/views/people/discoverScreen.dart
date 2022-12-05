// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/PeopleController.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/chat/chatUserListScreen.dart';
import 'package:shnatter/src/views/chat/emoticonScreen.dart';
import 'package:shnatter/src/views/chat/newMessageScreen.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/people/searchScreen.dart';

import '../../controllers/ChatController.dart';

class PeopleDiscoverScreen extends StatefulWidget {
  PeopleDiscoverScreen({Key? key})
      : con = PeopleController(),
        super(key: key);
  final PeopleController con;
  @override
  State createState() => PeopleDiscoverScreenState();
}

class PeopleDiscoverScreenState extends mvc.StateMVC<PeopleDiscoverScreen> {
  bool showMenu = false;
  late PeopleController con;
  //route variable
  Map isFriendRequest = {};
  String tabName = 'Discover';
  Color color = Color.fromRGBO(230, 236, 245, 1);
  List gender = [
    {'value': 'Any', 'title': 'Any'},
    {'value': 'Male', 'title': 'male'},
    {'value': 'Female', 'title': 'female'},
    {'value': 'Other', 'title': 'other'},
  ];
  List relationShip = [
    {'value': 'Any', 'title': 'Any'},
    {'value': 'Single', 'title': 'Single'},
    {'value': 'In a relationship', 'title': 'In a relationship'},
    {'value': 'Married', 'title': 'Married'},
    {'value': "It's complicated", 'title': "It's complicated"},
    {'value': "Separated", 'title': "Separated"},
    {'value': "Divorced", 'title': "Divorced"},
    {'value': "Widowed", 'title': "Widowed"},
  ];
  List onlineStatus = [
    {'value': 'Any', 'title': 'Any'},
    {'value': 'Online', 'title': 'Online'},
    {'value': 'Offline', 'title': 'Offline'},
  ];
  List religion = [
    {'value': 'Any', 'title': 'Any'},
    {'value': 'Jewish', 'title': 'Jewish'},
    {'value': 'Lizard', 'title': 'Lizard'},
    {'value': 'world', 'title': 'world'},
    {
      'value': 'Serbian Christian Orthodox',
      'title': 'Serbian Christian Orthodox'
    },
  ];
  @override
  void initState() {
    add(widget.con);
    con = controller as PeopleController;
    // con.getUserList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeConfig(context).screenWidth > 900
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              userListWidget(),
              Padding(padding: EdgeInsets.only(left: 20)),
              SearchScreen(
                onChange: () {},
                onClick: (value) async {
                  await con.fieldSearch(value);
                  setState(() {});
                },
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchScreen(
                onChange: () {},
                onClick: (value) {
                  setState(() {});
                },
              ),
              userListWidget(),
            ],
          );
  }

  Widget userListWidget() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        color: Colors.white,
        width: SizeConfig(context).screenWidth < 900
            ? SizeConfig(context).screenWidth - 60
            : SizeConfig(context).screenWidth * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(top: 25)),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'People You May Know',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Container(
              height: 1,
              color: color,
            ),
            Column(
                children: con.userList
                    .asMap()
                    .entries
                    .map((e) => Container(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 10)),
                                  e.value['avatar'] == ''
                                      ? CircleAvatar(
                                          radius: 20,
                                          child:
                                              SvgPicture.network(Helper.avatar))
                                      : CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              NetworkImage(e.value['avatar'])),
                                  Container(
                                    padding: EdgeInsets.only(left: 10, top: 5),
                                    child: Text(
                                      '${e.value['firstName']} ${e.value['lastName']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 11),
                                    ),
                                  ),
                                  Flexible(
                                      fit: FlexFit.tight, child: SizedBox()),
                                  Container(
                                    padding: EdgeInsets.only(top: 6),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          setState(() {});
                                          await con.requestFriend(
                                              e.value['userName'],
                                              '${e.value['firstName']} ${e.value['lastName']}',
                                              e.value['avatar'],
                                              e.key);
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(
                                                255, 33, 37, 41),
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(2.0)),
                                            minimumSize: con.isFriendRequest[e.key] !=
                                                        null &&
                                                    con.isFriendRequest[e.key]
                                                ? const Size(90, 35)
                                                : const Size(110, 35),
                                            maximumSize: con.isFriendRequest[e.key] !=
                                                        null &&
                                                    con.isFriendRequest[e.key]
                                                ? const Size(90, 35)
                                                : const Size(110, 35)),
                                        child: con.isFriendRequest[e.key] !=
                                                    null &&
                                                con.isFriendRequest[e.key]
                                            ? SizedBox(
                                                width: 10,
                                                height: 10,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Row(
                                                children: const [
                                                  Icon(
                                                    Icons
                                                        .person_add_alt_rounded,
                                                    color: Colors.white,
                                                    size: 18.0,
                                                  ),
                                                  Text(' Add Friend',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w900)),
                                                ],
                                              )),
                                  )
                                ]),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Container(
                              height: 1,
                              color: color,
                            ),
                          ],
                        )))
                    .toList()),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: InkWell(
                onTap: () async {
                  con.pageIndex++;
                  con.isShowProgressive = true;
                  setState(() {});
                  await con.getUserList();
                  con.isShowProgressive = false;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(55, 213, 242, 1),
                      borderRadius: BorderRadius.all(Radius.circular(3))),
                  alignment: Alignment.center,
                  height: 45,
                  child: con.isShowProgressive
                      ? const SizedBox(
                          width: 20,
                          height: 20.0,
                          child: CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        )
                      : Text('See More', style: TextStyle(color: Colors.white)),
                ),
              ),
            )
          ],
        ));
  }
}
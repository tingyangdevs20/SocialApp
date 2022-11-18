import 'dart:html';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/routes/route_names.dart';
import 'package:shnatter/src/views/box/searchbox.dart';
import 'package:shnatter/src/views/chat/chatScreen.dart';
import 'package:shnatter/src/views/events/panel/allevents.dart';
import 'package:shnatter/src/views/events/panel/goingevents.dart';
import 'package:shnatter/src/views/events/panel/interestedevents.dart';
import 'package:shnatter/src/views/events/panel/invitedevents.dart';
import 'package:shnatter/src/views/events/panel/myevents.dart';
import 'package:shnatter/src/views/navigationbar.dart';
import 'package:shnatter/src/views/panel/leftpanel.dart';
import 'package:shnatter/src/views/panel/rightpanel.dart';
import 'package:shnatter/src/widget/createEventWidget.dart';

import '../../controllers/PostController.dart';
import '../../utils/size_config.dart';
import '../../widget/mprimary_button.dart';
import '../../widget/list_text.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/gestures.dart';
import '../box/notification.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key? key})
      : con = PostController(),
        super(key: key);
  final PostController con;

  @override
  State createState() => EventsScreenState();
}

class EventsScreenState extends mvc.StateMVC<EventsScreen>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  bool showSearch = false;
  late FocusNode searchFocusNode;
  bool showMenu = false;
  late AnimationController _drawerSlideController;
  var suggest = <String, bool>{
    'friends': true,
    'pages': true,
    'groups': true,
    'events': true
  };
  //route variable
  String eventSubRoute = '';


  @override
  void initState() {
    add(widget.con);
    con = controller as PostController;
    super.initState();
    searchFocusNode = FocusNode();
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  late PostController con;
  void onSearchBarFocus() {
    searchFocusNode.requestFocus();
    setState(() {
      showSearch = true;
    });
  }

  void clickMenu() {
    //setState(() {
    //  showMenu = !showMenu;
    //});
    //Scaffold.of(context).openDrawer();
    //print("showmenu is {$showMenu}");
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  void onSearchBarDismiss() {
    if (showSearch)
      setState(() {
        showSearch = false;
      });
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    _drawerSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: Drawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            ShnatterNavigation(
              searchController: searchController,
              onSearchBarFocus: onSearchBarFocus,
              onSearchBarDismiss: onSearchBarDismiss,
              drawClicked: clickMenu,
            ),
            Padding(
                padding: EdgeInsets.only(top: SizeConfig.navbarHeight),
                child:
                    //AnimatedPositioned(
                    //top: showMenu ? 0 : -150.0,
                    //duration: const Duration(seconds: 2),
                    //curve: Curves.fastOutSlowIn,
                    //child:
                    SingleChildScrollView(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizeConfig(context).screenWidth <
                                SizeConfig.smallScreenSize
                            ? const SizedBox()
                            : LeftPanel(),
                        //    : SizedBox(width: 0),
                        Expanded(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Container(padding: const EdgeInsets.only(top: 20, left:0),
                                  child: 
                                    Column(children: [
                                      Container(
                                        width: SizeConfig(context).screenWidth*0.6,
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 1.0,
                                              spreadRadius: 0.1,
                                              offset: Offset(
                                                0.1,
                                                0.11,
                                              ),
                                            )
                                          ],
                                        ),
                                        child: Row(children: [
                                          Container(
                                            width: SizeConfig(context).screenWidth*0.4,
                                            child: Row(
                                              children: [
                                                const Padding(padding: EdgeInsets.only(left: 30)),
                                                Expanded(
                                                  child: RichText(
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'Discover',
                                                          style: const TextStyle(
                                                              color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                                                          recognizer: TapGestureRecognizer()
                                                            ..onTap = () {
                                                              eventSubRoute = '';
                                                              setState(() { });
                                                            }
                                                        ),
                                                      ]),
                                                    ),
                                                ),
                                                const Padding(padding: EdgeInsets.only(left: 5)),
                                                Expanded(
                                                  child: RichText(
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'Going',
                                                          style: const TextStyle(
                                                              color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                                                          recognizer: TapGestureRecognizer()
                                                            ..onTap = () {
                                                              eventSubRoute = 'going';
                                                              setState(() { });
                                                            }
                                                        ),
                                                      ]),
                                                    ),
                                                ),
                                                const Padding(padding: EdgeInsets.only(left: 5)),
                                                Expanded(
                                                  child: RichText(
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'Interested',
                                                          style: const TextStyle(
                                                              color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                                                          recognizer: TapGestureRecognizer()
                                                            ..onTap = () {
                                                              eventSubRoute = 'interested';
                                                              setState(() { });
                                                            }
                                                        ),
                                                      ]),
                                                    ),
                                                ),
                                                const Padding(padding: EdgeInsets.only(left: 5)),
                                                Expanded(
                                                  child: RichText(
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'Invited',
                                                          style: const TextStyle(
                                                              color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                                                          recognizer: TapGestureRecognizer()
                                                            ..onTap = () {
                                                              eventSubRoute = 'invited';
                                                              setState(() { });
                                                            }
                                                        ),
                                                      ]),
                                                    ),
                                                ),
                                                const Padding(padding: EdgeInsets.only(left: 5)),
                                                Expanded(
                                                  child: RichText(
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'My Events',
                                                          style: const TextStyle(
                                                              color: Color.fromARGB(255, 90, 90, 90), fontSize: 14),
                                                          recognizer: TapGestureRecognizer()
                                                            ..onTap = () {
                                                              eventSubRoute = 'manage';
                                                              setState(() { });
                                                            }
                                                        ),
                                                      ]),
                                                    ),
                                                ),
                                            ]),
                                          ),
                                          const Flexible(fit: FlexFit.tight, child: SizedBox()),
                                          Container(
                                            width: 120,
                                            margin: const EdgeInsets.only(right: 20),
                                            child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      padding: EdgeInsets.all(3),
                                                      backgroundColor: Color.fromARGB(255, 45, 206, 137),
                                                      // elevation: 3,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(3.0)),
                                                      minimumSize: const Size(120, 50),
                                                      maximumSize: const Size(120, 50),
                                                    ),
                                                    onPressed: () {
                                                      (showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) =>
                                                          AlertDialog(
                                                            title: Row(children: const [
                                                              Icon(Icons.event,color: Color.fromARGB(255, 247, 159, 88),),
                                                              Text('Create New Event',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontStyle: FontStyle.italic
                                                              ),),
                                                            ],),
                                                            content: CreateEventModal(context: context)
                                                          )
                                                    ));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: const [
                                                      Icon(Icons.add_circle),
                                                      Padding(padding: EdgeInsets.only(left: 4)),
                                                      Text('Create Event', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold))
                                                    ],)),
                                          )
                                        ],)
                                      )
                                    ],),
                                  ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 20)),
                                eventSubRoute == ''
                                    ? AllEvents()
                                    : const SizedBox(),
                                eventSubRoute == 'going'
                                    ? GoingEvents()
                                    : const SizedBox(),
                                eventSubRoute == 'interested'
                                    ? InterestedEvents()
                                    : const SizedBox(),
                                eventSubRoute == 'invited'
                                    ? InvitedEvents()
                                    : const SizedBox(),
                                eventSubRoute == 'manage'
                                    ? MyEvents()
                                    : const SizedBox(),
                              ],
                            )),
                          ],
                        )),
                      ]),
                )),
            showSearch
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showSearch = false;
                      });
                    },
                    child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: const Color.fromARGB(0, 214, 212, 212),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                    )),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, right: 9),
                                  width: SizeConfig(context).screenWidth * 0.4,
                                  child: TextField(
                                    focusNode: searchFocusNode,
                                    controller: searchController,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.search,
                                          color: Color.fromARGB(
                                              150, 170, 212, 255),
                                          size: 20),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xff202020),
                                      hintText: 'Search',
                                      hintStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            ShnatterSearchBox()
                          ],
                        )),
                  )
                : const SizedBox(),
            ChatScreen(),
          ],
        ));
  }
}
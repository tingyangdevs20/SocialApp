// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart' as mvc;
import 'package:shnatter/src/controllers/UserController.dart';
import 'package:shnatter/src/managers/user_manager.dart';
import 'package:shnatter/src/utils/size_config.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';
import 'package:shnatter/src/widget/primaryInput.dart';

import '../../controllers/ChatController.dart';
import '../../models/chatModel.dart';

class WriteMessageScreen extends StatefulWidget {
  String type;
  Function goMessage;
  WriteMessageScreen({Key? key,required this.type,required this.goMessage})
      : con = ChatController(),
        super(key: key);
  late ChatController con;
  State createState() => WriteMessageScreenState();
}

class WriteMessageScreenState extends mvc.StateMVC<WriteMessageScreen> {
  bool check1 = false;
  bool check2 = false;
  late ChatController con;
  var userInfo = UserManager.userInfo;
  @override
  void initState() {
    add(widget.con);
    con = controller as ChatController;
    setState(() {});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
                height: 35,
                child: TextFormField(
                  onChanged: (value) {
                    con.data = value;
                    con.setState(() {});
                  },
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Write message',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 0, right: 15),
                  ),
                ),
              ),
              Container(
                child: Row(children: [
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  const Icon(
                    Icons.photo_size_select_actual_rounded,
                    size: 20,
                    color: Color.fromRGBO(175, 175, 175, 1),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  const Icon(
                    Icons.mic,
                    size: 20,
                    color: Color.fromRGBO(175, 175, 175, 1),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  const Icon(
                    Icons.emoji_emotions,
                    size: 20,
                    color: Color.fromRGBO(175, 175, 175, 1),
                  ),
                  Flexible(fit: FlexFit.tight, child: SizedBox()),
                  ElevatedButton(
                    onPressed: () async {
                      try{
                        await con.sendMessage(widget.type);
                        if(widget.type == 'new'){
                          widget.goMessage('message-list');
                        }
                      }
                      catch(e){

                      }
                      
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(33, 37, 41, 1),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        minimumSize: Size(60, 38),
                        maximumSize: Size(60, 38)),
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 10)),
                ]),
              )
            ],
          );
  }
}
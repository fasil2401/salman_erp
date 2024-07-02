import 'dart:developer';

import 'package:axolon_erp/controller/app%20controls/Hr%20Controller/my_task_controller.dart';
import 'package:axolon_erp/controller/app%20controls/Sales%20Controls/salesman_activity_controller.dart';
import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final ScrollController listScrollController = ScrollController();
  final mytaskController = Get.put(MyTaskController());
  @override
  void initState() {
    //mytaskController.populateChatList();
    mytaskController.getChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        mytaskController.chatList.clear();
        return true;
      },
      child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Text("Comment"),
              ), // Custom app bar for chat screen
              body: Stack(children: <Widget>[
                Obx(() => Column(
                      children: <Widget>[
                        Flexible(
                            child: ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          itemBuilder: (context, index) => ChatItemWidget(
                              mytaskController.chatList[index].createdBy ==
                                      UserSimplePreferences.getUsername()
                                  ? true
                                  : false,
                              index),
                          itemCount: mytaskController.chatList.length,
                          reverse: true,
                          controller: listScrollController,
                        )),
                        Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                style: TextStyle(
                                    fontSize: 15, color: AppColors.mutedColor),
                                decoration: InputDecoration(
                                    isCollapsed: true,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    hintText: 'Type a message',
                                    hintStyle:
                                        TextStyle(color: AppColors.mutedColor),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none)),
                                autofocus: false,
                                maxLines: null,
                                controller: mytaskController.chatControl,
                                textInputAction: TextInputAction.newline,
                              ),
                            ),
                            IconButton(
                              icon: mytaskController.chatsend.value == false
                                  ? Icon(
                                      Icons.send,
                                    )
                                  : SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        color: AppColors.mutedColor,
                                        strokeWidth: 2,
                                      ),
                                    ),
                              onPressed: () {
                                log("${mytaskController.chatControl.text.trim() != ""}");
                                if (mytaskController.chatControl.text.trim() !=
                                    "") {
                                  mytaskController.sendChat();
                                }
                                //  salesmanActivityController.chatsended();
                              },
                              color: AppColors.mutedColor,
                            ),
                          ],
                        ),
                      ],
                    ))
              ]))),
    );
  }
}

class ChatItemWidget extends StatelessWidget {
  bool isSend;
  var index;

  ChatItemWidget(this.isSend, this.index);

  final mytaskController = Get.put(MyTaskController());

  @override
  Widget build(BuildContext context) {
    log("${isSend} issend");
    if (isSend == true) {
      return Container(
          child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              child: Text(
                '${mytaskController.chatList[index].note}',
                style: TextStyle(color: AppColors.primary),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: AppColors.mutedBlueColor,
                  borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(right: 10.0),
            )
          ],
          mainAxisAlignment:
              MainAxisAlignment.end, // aligns the chatitem to right end
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Container(
            child: Text(
              '${mytaskController.chatList[index].dateCreated.toString().split('.')[0].split(' ')[1]}',
              style: TextStyle(
                  color: AppColors.mutedColor,
                  fontSize: 8.0,
                  fontStyle: FontStyle.normal),
            ),
            margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
          )
        ])
      ]));
    } else {
      // This is a received message
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    '${mytaskController.chatList[index].note}',
                    style: TextStyle(color: AppColors.lightGrey),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                )
              ],
            ),
            Container(
              child: Text(
                '${mytaskController.chatList[index].createdBy} ${mytaskController.chatList[index].dateCreated.toString().split('.')[0].split(' ')[1]}',
                style: TextStyle(
                    color: AppColors.mutedColor,
                    fontSize: 8.0,
                    fontStyle: FontStyle.normal),
              ),
              margin: EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
}

import 'package:axolon_erp/utils/constants/colors.dart';
import 'package:axolon_erp/view/Announcement%20Screen/my_announcements_screen.dart';
import 'package:axolon_erp/view/Announcement%20Screen/my_follow_up_screen.dart';
import 'package:flutter/material.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
          bottom: const TabBar(
            labelStyle: TextStyle(
                color: AppColors.mutedBlueColor, fontWeight: FontWeight.w500),
            tabs: <Widget>[
              Tab(
                text: "My Follow up",
              ),
              Tab(
                text: "My Announcements",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[MyFollowUpScreen(), MyAnnouncementScreen()],
        ),
      ),
    );
  }
}

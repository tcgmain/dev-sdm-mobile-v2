import 'package:flutter/material.dart';
import 'package:sdm/models/Bdnotification.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/bdnotification_block.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({
    super.key
  });

  @override
  State<NotificationView> createState() => _NotificationView();
}

class _NotificationView extends State<NotificationView> {
  late BdnotificationBlock _bdnotificationBlock;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bdnotificationBlock = BdnotificationBlock();
    _fetchOrgDetails();
  }

  Future<String?> getTerritoryNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ttNumb = prefs.getString('userTerritoryNumber');
    if (ttNumb != null) {
      print(ttNumb);
      return ttNumb;
    } else {
      print("Error in TT");
      return null;
    }
  }

  void _fetchOrgDetails() async {
    String? tt = await getTerritoryNumber();
    if (tt != null) {
      _bdnotificationBlock.getBdnotification(tt);
    } else {
      print("Failed to fetch territory number");
    }
  }

  bool isBirthday(String? orgOwnerBd) {
    try {
      if (orgOwnerBd == null) return false;
      //String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      DateTime userBirthDate = DateFormat('dd/MM/yyyy').parse(orgOwnerBd);

      DateTime today = DateTime.now();

      return userBirthDate.day == today.day && userBirthDate.month == today.month;

      //return orgOwnerBd == currentDate;
    } catch (e) {
      print("Error in isBirthday: $e");
      return false;
    }
  }

  @override
  void dispose() {
    _bdnotificationBlock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Notifications',
        onBackButtonPressed: () {
          Navigator.pop(context, false);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: BackgroundImage(
          isTeamMemberUi: false,
          child: StreamBuilder<ResponseList<Bdnotification>>(
            stream: _bdnotificationBlock.bdnotificationStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data!.status) {
                  case Status.LOADING:
                    return const Center(child: CircularProgressIndicator());
                  case Status.COMPLETED:
                    List<Bdnotification> notifications = snapshot.data!.data!;
                    List<Bdnotification> birthdayNotifications = notifications
                        .where((notification) => isBirthday(notification.yorgowndob))
                        .toList();
                        
                    if (birthdayNotifications.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Birthdays Today.",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: birthdayNotifications.length,
                        itemBuilder: (context, index) {
                          return listItemView(birthdayNotifications[index]);
                        },
                      );
                    }
                  case Status.ERROR:
                    return Center(
                      child: Text(
                        "Error: ${snapshot.data!.message}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  case null:
                }
              }
              return const Center(child: Loading());
            },
          ),
        ),
      ),
    );
  }

  Widget listItemView(Bdnotification notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prefxIcon(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${notification.yowname}'s Birthday is Today",
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  const Text(
                    "Don't miss the chnace to wish Him!",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget prefxIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.notifications, size: 25, color: Colors.black),
    );
  }
}

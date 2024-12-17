import 'package:flutter/material.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:intl/intl.dart';
import 'package:sdm/blocs/bdnotification_block.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NotificationView extends StatefulWidget {

  const NotificationView({
    super.key
  });
  
  @override
  State<NotificationView> createState() => _NotificationView();

}

class _NotificationView extends State<NotificationView>{
  late BdnotificationBlock _bdnotificationBlock;

  @override
  void initState() {
    super.initState();
    _bdnotificationBlock = BdnotificationBlock();
    // _bdnotificationBlock.getBdnotification(UserTerritoruNumber() as String);

    UserTerritoruNumber().then((territoryNumber) {
    if (territoryNumber != null) {
      _bdnotificationBlock.getBdnotification(territoryNumber); 
    } else {
      print("No territory number available.");
    }
  });

    printUserTerritoryNumber();

  }

  Future<void> printUserTerritoryNumber() async{
    SharedPreferences prefsUserTerritoryNumber = await SharedPreferences.getInstance();
    String? territoryNumber = prefsUserTerritoryNumber.getString('userTerritoryNumber');

     if (territoryNumber != null) {
      print("territoryNumber: $territoryNumber");
    } else {
      print("No territory number found in SharedPreferences.");
    }
  }

  Future<String?> UserTerritoruNumber() async{
    SharedPreferences UserTerritoryNumber = await SharedPreferences.getInstance();
    String? ttNumb = UserTerritoryNumber.getString('userTerritoryNumber');

    if (ttNumb != null) {
      print("vvvvvvv");
      return ttNumb;
    } else {
      print("Error in TT");
    }
  }

  @override
  void dispose() {
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
        child: ListView.separated(itemBuilder: (context, index) {
          return listItemView(index);
        }, separatorBuilder:(context, index) {
          return const Divider(height: 0);
        }, itemCount: 15,
        ), ), 
      ),
    );
  }
  
  Widget listItemView(int index) {
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
                  message(index),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget message(int index){
    final String currentTime = DateFormat('hh:mm a').format(DateTime.now());

    return Container(
      child: Text("Vinuk Lakvindu - $currentTime",
      style: const TextStyle(color: Colors.white, fontSize: 17)
      ),
    );
  }

  Widget prefxIcon() {
    return Container(
      height: 50,
      width: 50,
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.notifications, size: 25, color: Colors.black,)
    );
  }
}


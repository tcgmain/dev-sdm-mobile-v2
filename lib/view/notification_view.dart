import 'package:flutter/material.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/birthday_popup.dart';


class NotificationView extends StatefulWidget{
  final String username;
  final String userNummer;
  final String userId;
  final bool userOrganizationNummer;
  final String userDesignationNummer;

  const NotificationView({
    super.key,
    required this.username,
    required this.userNummer,
    required this.userId,
    required this.userOrganizationNummer,
    required this.userDesignationNummer,
  });

  @override
  State<StatefulWidget> createState() => _NotificationView();

}

class _NotificationView extends State<NotificationView>{

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: CommonAppBar(
        title: "Notifications", 
        onBackButtonPressed: (){
           Navigator.pop(context);
        }, 
        isHomePage: false
        ),

        body: SafeArea(
          child: Stack(
            children: [
              
            ],
          ),
        ),
    );
  }
  
}
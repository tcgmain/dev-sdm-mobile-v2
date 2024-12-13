import 'package:flutter/material.dart';
import 'package:sdm/widgets/appbar.dart';

class NotificationView extends StatefulWidget {

  const NotificationView({
    super.key
  });
  
  @override
  State<NotificationView> createState() => _NotificationView();

}

class _NotificationView extends State<NotificationView>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
      body: const SafeArea(
        child: Text("data"),
      ),
    );
  }
}


// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sdm/blocs/mark_visit_bloc.dart';
import 'package:sdm/models/mark_visit.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_stock_view.dart';
import 'package:sdm/view/visit_history_view.dart';
import 'package:sdm/widgets/app_button.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/icon_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:sdm/widgets/location_util.dart';
import 'package:sdm/widgets/map_widget.dart';
import 'package:sdm/widgets/success_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sdm/widgets/birthday_popup.dart';
import 'package:intl/intl.dart';


class MarkVisitView extends StatefulWidget {
  final String username;
  final String userNummer;
  final String routeNummer;
  final String organizationId;
  final String organizationNummer;
  final String organizationName;
  final String organizationTypeNamebspr;
  final String organizationPhone1;
  final String organizationPhone2;
  final String organizationWhatsapp;
  final String organizationAddress1;
  final String organizationAddress2;
  final String organizationAddress3;
  final String organizationTown;
  final String organizationColour;
  final String organizationLongitude;
  final String organizationLatitude;
  final String organizationDistance;
  final String organizationMail;
  final bool isTeamMemberUi;
  final String loggedUserNummer;
  final String ysuporgNummer;
  final String ysuporgNamebspr;
  final String ownerBirthday;
  final String ownerName;


  const MarkVisitView(
      {super.key,
      required this.username,
      required this.userNummer,
      required this.routeNummer,
      required this.organizationId,
      required this.organizationNummer,
      required this.organizationName,
      required this.organizationPhone1,
      required this.organizationPhone2,
      required this.organizationWhatsapp,
      required this.organizationAddress1,
      required this.organizationAddress2,
      required this.organizationAddress3,
      required this.organizationTown,
      required this.organizationColour,
      required this.organizationLongitude,
      required this.organizationLatitude,
      required this.organizationDistance,
      required this.organizationMail,
      required this.isTeamMemberUi,
      required this.loggedUserNummer,
      required this.ysuporgNummer,
      required this.ysuporgNamebspr,
      required this.organizationTypeNamebspr,
      required this.ownerBirthday,
      required this.ownerName});

  @override
  State<MarkVisitView> createState() => _MarkVisitViewState();
}

class _MarkVisitViewState extends State<MarkVisitView> {
  String _locationMessage = "";
  bool _isSuccessMessageShown = false;
  bool _isErrorMessageShown = false;
  late double organizationLatitude = double.parse(widget.organizationLatitude);
  late double organizationLongitude =
      double.parse(widget.organizationLongitude);
  late double organizationDistance = double.parse(widget.organizationDistance);
  bool _isLoading = false;

  bool _isWithinRadius = false;
  late MarkVisitBloc _markVisitBloc;

  bool _isBirthdayMessageShown = false;


  @override
  void initState() {
    super.initState();
    print("widget.ownerBirthday.toString()");
    print(widget.ownerBirthday.toString());
    _getCurrentLocation();
    _markVisitBloc = MarkVisitBloc();

  DateTime currentDate = DateTime.now();
  String birthdayString = widget.ownerBirthday;

  try {
    DateTime userBirthDate = DateFormat("dd/MM/yyyy").parse(birthdayString);

    if (currentDate.day == userBirthDate.day && currentDate.month == userBirthDate.month) {
      if (!_isBirthdayMessageShown) {
        _isBirthdayMessageShown = true;
        SchedulerBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => BirthdayPopup(
              ownerName: widget.ownerName,
            ),
          );
        });
      }
    }
  } catch (e) {
    print("Error parsing or comparing birthday: $e");
  }
}

  @override
  void dispose() {
    _markVisitBloc.dispose();
    super.dispose();
  }

  getFullAddress() {
    String fullAddress = "";
    if (widget.organizationAddress1.isNotEmpty)
      fullAddress += widget.organizationAddress1;
    if (widget.organizationAddress2.isNotEmpty)
      fullAddress += ", ${widget.organizationAddress2}";
    if (widget.organizationAddress3.isNotEmpty)
      fullAddress += ", ${widget.organizationAddress3}";
    if (widget.organizationTown.isNotEmpty)
      fullAddress += ", ${widget.organizationTown}";
    return fullAddress;
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Location permissions are permanently denied.";
      });
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double currentLat = position.latitude;
    double currentLon = position.longitude;

    bool isWithin = LocationUtils.isWithinRadius(currentLat, currentLon,
        organizationLatitude, organizationLongitude, organizationDistance);

    if (isWithin) {
      setState(() {
        _isWithinRadius = isWithin;
        _locationMessage += "You are within the range of this organization.";
      });
    } else {
      setState(() {
        _locationMessage +=
            "You are not within the ${widget.organizationDistance} range of this organization.";
      });
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Subject&body=Body',
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'No email clients installed or could not launch email app')),
      );
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: phoneNumber,
    );

    if (await canLaunch(whatsappUri.toString())) {
      await launch(whatsappUri.toString());
    } else {
      throw 'Could not launch $whatsappUri';
    }
  }

  Future<void> _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.isTeamMemberUi == true
            ? 'Mark Visit - ${widget.username} '
            : 'Mark Visit',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        isHomePage: false,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BackgroundImage(
              isTeamMemberUi: widget.isTeamMemberUi,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CommonAppButton(
                        buttonText: 'Visit History',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => VisitHistoryView(
                                      userNummer: widget.userNummer,
                                      organizationNummer:
                                          widget.organizationNummer,
                                      organizationName: widget.organizationName,
                                      isTeamMemberUi: widget.isTeamMemberUi,
                                    )),
                          );
                        },
                      ),
                    ],
                  ),
                  CircleAvatar(
                    backgroundColor: getColor(widget.organizationColour),
                    radius: 40,
                    child: const Icon(
                      Icons.business,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.organizationName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CustomColors.textColor),
                  ),
                  Text(
                    widget.organizationTypeNamebspr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: getFontSize(),
                        fontWeight: FontWeight.normal,
                        color: CustomColors.textColor2),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(
                        Icons.location_on,
                        color: CustomColors.textColor,
                        size: 25,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          getFullAddress(),
                          style: TextStyle(
                            color: CustomColors.textColor,
                            fontSize: getFontSize(),
                          ),
                        ),
                      ),
                      CustomIconButton(
                          tooltip: 'Navigate to google map',
                          icon: const Icon(Icons.directions),
                          onPressed: () {
                            openGoogleMaps(
                                double.parse(widget.organizationLatitude),
                                double.parse(widget.organizationLongitude));
                          })
                    ],
                  ),
                  const SizedBox(height: 15),
                  widget.organizationPhone1.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.phone,
                              color: CustomColors.textColor,
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.organizationPhone1,
                              style: TextStyle(
                                color: CustomColors.textColor,
                                fontSize: getFontSize(),
                              ),
                            ),
                            widget.organizationPhone2.isNotEmpty
                                ? Text(
                                    " / ${widget.organizationPhone2}",
                                    style: TextStyle(
                                      color: CustomColors.textColor,
                                      fontSize: getFontSize(),
                                    ),
                                  )
                                : Container(),
                            const Spacer(),
                            CustomIconButton(
                                tooltip: 'Call',
                                icon: const Icon(Icons.call),
                                onPressed: () {
                                  _showCallOptions(
                                      context,
                                      widget.organizationPhone1,
                                      widget.organizationPhone2,
                                      widget.organizationWhatsapp);
                                })
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 15),
                  widget.organizationMail.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.mail,
                              color: CustomColors.textColor,
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.organizationMail,
                              style: TextStyle(
                                color: CustomColors.textColor,
                                fontSize: getFontSize(),
                              ),
                            ),
                            const Spacer(),
                            CustomIconButton(
                                tooltip: 'E-Mail',
                                icon: const Icon(Icons.send),
                                onPressed: () {
                                  _launchEmail(widget.organizationMail);
                                })
                          ],
                        )
                      : Container(),
                  const SizedBox(height: 10),
                  MapWidget(
                    latitude: double.parse(widget.organizationLatitude),
                    longitude: double.parse(widget.organizationLongitude),
                  ),
                  const SizedBox(height: 10),
                  if (_isWithinRadius)
                    CommonAppButton(
                      buttonText: 'Mark Visit',
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                          _isSuccessMessageShown = false;
                          _isErrorMessageShown = false;
                        });
                        _markVisitBloc.markVisit(
                            widget.loggedUserNummer,
                            widget.organizationNummer,
                            widget.routeNummer,
                            getCurrentDate(),
                            getCurrentTime());
                      },
                    ),
                  const SizedBox(height: 5),
                  Text(_locationMessage,
                      style: TextStyle(
                          color: _isWithinRadius ? Colors.green : Colors.red,
                          fontSize: getFontSize()),
                      textAlign: TextAlign.center),
                  markVisitResponse()
                ],
              ),
            ),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }

  void _showCallOptions(
      BuildContext context, String phone1, String phone2, String whatsapp) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (phone1.isNotEmpty)
                Ink(
                  child: ListTile(
                    leading: const Icon(Icons.call),
                    title: Text(phone1),
                    onTap: () {
                      _launchDialer(phone1);

                      Navigator.pop(context);
                    },
                  ),
                ),
              if (phone2.isNotEmpty)
                Ink(
                  child: ListTile(
                    leading: const Icon(Icons.call),
                    title: Text(phone2),
                    onTap: () {
                      _launchDialer(phone2);

                      Navigator.pop(context);
                    },
                  ),
                ),
              if (whatsapp.isNotEmpty)
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.whatsapp),
                  title: Text(whatsapp),
                  onTap: () {
                    Navigator.pop(context);

                    _launchWhatsApp(whatsapp);
                  },
                ),
              if (widget.organizationPhone1.isEmpty &&
                  widget.organizationPhone2.isEmpty &&
                  widget.organizationWhatsapp.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No contact numbers available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

Widget markVisitResponse() {
  return StreamBuilder<Response<MarkVisit>>(
    stream: _markVisitBloc.markVisitStream,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        switch (snapshot.data!.status!) {
          case Status.LOADING:
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLoading = true;
              });
            });
            break;
          case Status.COMPLETED:
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLoading = false;
              });
            });

            if (!_isSuccessMessageShown) {
              String visitNummer = snapshot.data!.data!.nummer.toString();
              SchedulerBinding.instance.addPostFrameCallback((_) {
                showSuccessAlertDialog(
                  context, "Visit Successfully Marked", () {}
                ).then((_) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeStockView(
                        userNummer: widget.userNummer,
                        username: widget.username,
                        organizationId: widget.organizationId,
                        organizationNummer: widget.organizationNummer,
                        routeNummer: widget.routeNummer,
                        visitNummer: visitNummer,
                        loggedUserNummer: widget.loggedUserNummer,
                        isTeamMemberUi: widget.isTeamMemberUi,
                        organizationName: widget.organizationName,
                        ysuporgNummer: widget.ysuporgNummer,
                        ysuporgNamebspr: widget.ysuporgNamebspr,
                      ),
                    ),
                  );
                });
                _isSuccessMessageShown = true;
              });
            }
           
            break;
          case Status.ERROR:
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _isLoading = false;
              });
            });
            if (!_isErrorMessageShown) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                showErrorAlertDialog(
                    context, snapshot.data!.message.toString());
              });
              _isErrorMessageShown = true;
            }
            break;
        }
      }
      return Container();
    },
  );
}


//   Widget customIconButton(BuildContext context, String tooltip){
// return CircleAvatar(
//                         radius: 20,
//                         backgroundColor: CustomColors.buttonColor1,
//                         child: IconButton(
//                           splashColor: CustomColors.buttonColor2,
//                           highlightColor: CustomColors.buttonColor2,
//                           hoverColor: CustomColors.buttonColor2,
//                           focusColor: CustomColors.buttonColor2,
//                           color: CustomColors.buttonTextColor,
//                           icon: const Icon(Icons.directions),
//                           tooltip: 'Navigate to google map',
//                           onPressed: () {},
//                         ),
//                       );
//   }
}

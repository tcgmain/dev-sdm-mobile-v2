import 'package:flutter/material.dart';
import 'package:sdm/blocs/route_organization_bloc.dart';
import 'package:sdm/models/route_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/utils/constants.dart';
import 'package:sdm/view/home_organization_view.dart';
import 'package:sdm/view/update_organization_view.dart';
import 'package:sdm/widgets/appbar.dart';
import 'package:sdm/widgets/background_decoration.dart';
import 'package:sdm/widgets/error_alert.dart';
import 'package:sdm/widgets/list_button.dart';
import 'package:sdm/widgets/loading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class RouteOrganizationView extends StatefulWidget {
  final String userNummer;
  final String username;
  final String routeNummer;
  final bool isTeamMemberUi;
  final String loggedUserNummer;
  final String designationNummer;

  const RouteOrganizationView({
    Key? key,
    required this.userNummer,
    required this.username,
    required this.routeNummer,
    required this.isTeamMemberUi,
    required this.loggedUserNummer,
    required this.designationNummer,
  }) : super(key: key);

  @override
  State<RouteOrganizationView> createState() => _RouteOrganizationViewState();
}

class _RouteOrganizationViewState extends State<RouteOrganizationView> {
  late RouteOrganizationBloc _routeOrganizationBloc;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    _routeOrganizationBloc = RouteOrganizationBloc();
    _routeOrganizationBloc.getRouteOrganization(widget.routeNummer);
  }

  @override
  void dispose() {
    _routeOrganizationBloc.dispose();
    super.dispose();
  }

    Future<void> _navigateToUpdateOrganizationView(
      organizationId,
      organizationNummer,
      organizationName,
      organizationTypeId,
      organizationMail,
      organizationPhone1,
      organizationPhone2,
      organizationWhatsapp,
      organizationAddress1,
      organizationAddress2,
      organizationAddress3,
      organizationAddress4) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateOrganizationView(
              userNummer: widget.userNummer,
              loggedUserNummer: widget.loggedUserNummer,
              username: widget.username,
              isTeamMemberUi: widget.isTeamMemberUi,
              organizationId: organizationId,
              organizationNummer: organizationNummer,
              organizationName: organizationName,
              organizationTypeId: organizationTypeId,
              organizationMail: organizationMail,
              organizationPhone1: organizationPhone1,
              organizationPhone2: organizationPhone2,
              organizationWhatsapp: organizationWhatsapp,
              organizationAddress1: organizationAddress1,
              organizationAddress2: organizationAddress2,
              organizationAddress3: organizationAddress3,
              organizationAddress4: organizationAddress4)),
    );

    if (result == true) {
      setState(() {
        _routeOrganizationBloc.getRouteOrganization(widget.routeNummer);
        _isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.isTeamMemberUi == true ? 'Organizations - ${widget.username} ' : 'Organizations',
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
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<ResponseList<RouteOrganization>>(
                      stream: _routeOrganizationBloc.routeOrganizationStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.status!) {
                            case Status.LOADING:
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isLoading = true;
                                });
                              });

                            case Status.COMPLETED:
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                              int noOfOrganizations = snapshot.data!.data!.length;
                              if (noOfOrganizations == 0) {
                                return Center(
                                  child: Text(
                                    "No organizations have been assigned for this route.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: getFontSize(), color: CustomColors.textColor),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data!.data!.length,
                                  itemBuilder: (context, index) {
                                    final organizations = snapshot.data!.data![index];
                                    final organizationId = organizations.ysdmorgId.toString();
                                    final organizationNummer = organizations.orgnummer.toString();
                                    final organizationName = organizations.namebspr?.toString() ?? 'Unnamed Route';
                                    final organizationTypeId = organizations.ycustypId?.toString() ?? 'Unnamed Route';
                                    final organizationPhone1 = organizations.yphone1?.toString() ?? 'Unnamed Route';
                                    final organizationPhone2 = organizations.yphone2?.toString() ?? 'Unnamed Route';
                                    final organizationWhatsapp = organizations.ywhtapp?.toString() ?? 'Unnamed Route';
                                    final organizationAddress1 =
                                        organizations.yaddressl1?.toString() ?? 'Unnamed Route';
                                    final organizationAddress2 =
                                        organizations.yaddressl2?.toString() ?? 'Unnamed Route';
                                    final organizationAddress3 =
                                        organizations.yaddressl3?.toString() ?? 'Unnamed Route';
                                    final organizationAddress4 =
                                        organizations.yaddressl4?.toString() ?? 'Unnamed Route';
                                    final organizationColour = organizations.colour?.toString() ?? 'Unnamed Route';
                                    final organizationLongitude =
                                        organizations.longitude?.toString() ?? 'Unnamed Route';
                                    final organizationLatitude = organizations.latitude?.toString() ?? 'Unnamed Route';
                                    final organizationDistance = organizations.distance?.toString() ?? 'Unnamed Route';
                                    final organizationMail = organizations.yemail?.toString() ?? 'Unnamed Route';
                                    final ysuporgNummer = organizations.ysuporgNummer?.toString() ?? 'Unnamed Route';
                                    final ysuporgNamebspr = organizations.ysuporgNamebspr?.toString() ?? 'Unnamed Route';
    final organizationTypeNamebspr = organizations.ycustypNamebspr?.toString() ?? 'Unnamed Route';

                                    return Padding(
                                        padding: const EdgeInsets.only(bottom: 3, top: 3),
                                        child: Slidable(
                                           key: const ValueKey(0),

                                              // The end action pane is the one at the right or the bottom side.
                                              endActionPane: ActionPane(
                                                extentRatio: 0.2,
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    onPressed: (context) {
                                                      print("Pressed");

                                                      _navigateToUpdateOrganizationView(
                                                          organizationId,
                                                          organizationNummer,
                                                          organizationName,
                                                          organizationTypeId,
                                                          organizationMail,
                                                          organizationPhone1,
                                                          organizationPhone2,
                                                          organizationWhatsapp,
                                                          organizationAddress1,
                                                          organizationAddress2,
                                                          organizationAddress3,
                                                          organizationAddress4);
                                                    },
                                                    backgroundColor: CustomColors.buttonColor,
                                                    foregroundColor: CustomColors.buttonTextColor,
                                                    icon: Icons.edit,
                                                  ),
                                                ],
                                              ),

                                          child: ListButton(
                                            displayName: organizationName,
                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) => HomeOrganizationView(
                                                        userNummer: widget.userNummer,
                                                        username: widget.username,
                                                        routeNummer: widget.routeNummer,
                                                        organizationId: organizationId,
                                                        organizationNummer: organizationNummer,
                                                        organizationName: organizationName,
                                                        organizationPhone1: organizationPhone1,
                                                        organizationPhone2: organizationPhone2,
                                                        organizationWhatsapp:  organizationWhatsapp,
                                                        organizationAddress1: organizationAddress1,
                                                        organizationAddress2: organizationAddress2,
                                                        organizationAddress3: organizationAddress3,
                                                        organizationAddress4: organizationAddress4,
                                                        organizationColour: organizationColour,
                                                        organizationLongitude: organizationLongitude,
                                                        organizationLatitude: organizationLatitude,
                                                        organizationDistance: organizationDistance,
                                                        organizationMail: organizationMail,
                                                        isTeamMemberUi: widget.isTeamMemberUi,
                                                        loggedUserNummer: widget.loggedUserNummer,
                                                        ysuporgNummer: ysuporgNummer,
                                                        ysuporgNamebspr: ysuporgNamebspr, 
                                                        designationNummer: widget.designationNummer, 
                                                        organizationTypeNamebspr: organizationTypeNamebspr,
                                                      )));
                                            },
                                          ),
                                        )
                                        );
                                  },
                                );
                              }

                            case Status.ERROR:
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                setState(() {
                                  _isLoading = false;
                                });
                                showErrorAlertDialog(context, snapshot.data!.message.toString());
                              });
                          }
                        }
                        return Container();
                      },
                    ),
                  )
                ],
              ),
            ),
            if (_isLoading) const Loading(),
          ],
        ),
      ),
    );
  }
}

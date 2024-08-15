// ignore_for_file: file_names

import 'dart:async';
import 'package:sdm/models/add_organization.dart';
import 'package:sdm/networking/response.dart';
import 'package:sdm/repository/add_organization_repository.dart';

class AddOrganizationBloc {
  late AddOrganizationRepository _addOrganizationRepository;
  StreamController? _addOrganizationController;

  StreamSink<Response<AddOrganization>> get addOrganizationSink =>
      _addOrganizationController!.sink as StreamSink<Response<AddOrganization>>;
  Stream<Response<AddOrganization>> get addOrganizationStream =>
      _addOrganizationController!.stream as Stream<Response<AddOrganization>>;

  AddOrganizationBloc() {
    _addOrganizationController = StreamController<Response<AddOrganization>>.broadcast();
    _addOrganizationRepository = AddOrganizationRepository();
  }

  addOrganization(
      searchWord,
      name,
      email,
      phone1,
      phone2,
      whatsapp,
      address1,
      address2,
      address3,
      address4,
      latitude,
      longitude,
      customerTypeId,
      assignToNummer,
      userOrganizationNummer,
      ownerName,
      isMasonry,
      isWaterproofing,
      isFlooring,
      organizationColor) async {
    if (_addOrganizationController?.isClosed ?? true) return;
    addOrganizationSink.add(Response.loading(''));
    try {
      AddOrganization res = await _addOrganizationRepository.addOrganization(
          searchWord,
          name,
          email,
          phone1,
          phone2,
          whatsapp,
          address1,
          address2,
          address3,
          address4,
          latitude,
          longitude,
          customerTypeId,
          assignToNummer,
          userOrganizationNummer,
          ownerName,
          isMasonry,
          isWaterproofing,
          isFlooring,
          organizationColor);
      if (_addOrganizationController?.isClosed ?? true) return;
      addOrganizationSink.add(Response.completed(res));
      print("ADD ORGANIZATION SUCCESS");
    } catch (e) {
      if (_addOrganizationController?.isClosed ?? true) return;
      addOrganizationSink.add(Response.error(e.toString()));
      print("ADD ORGANIZATION ERROR");
    }
  }

  dispose() {
    _addOrganizationController?.close();
  }
}

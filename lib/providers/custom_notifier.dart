import 'package:flutter/material.dart';

class CustomNotifier with ChangeNotifier {
  Map<String, Status> _status = {"main": Status.Idle};

  setStatus(String taskName, Status status) {
    this._status[taskName] = status;
  }

  Map<String, Status> get status => this._status;
}

enum Status { Idle, Loading, Done, Error }

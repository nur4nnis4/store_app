import 'package:flutter/material.dart';
import 'package:store_app/core/error/failures.dart';

class BaseProvider with ChangeNotifier {
  Map<String, Status> _status = {"main": Status.Idle};
  Map<String, Failure> _error = {};

  setStatus(String taskName, Status status) {
    this._status[taskName] = status;
  }

  setError(String errorName, Failure error) {
    this._error[errorName] = error;
  }

  Map<String, Status> get status => this._status;
  Map<String, Failure> get error => this._error;
}

enum Status { Idle, Loading, Done, Error }

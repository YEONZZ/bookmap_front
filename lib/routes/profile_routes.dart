import 'package:flutter/cupertino.dart';
import 'package:bookmap/login.dart';
import '../pages/profile_calendar.dart';
import '/pages/profile_edit.dart';
import '/pages/profile_setting.dart';

class RoutesProfile{
  RoutesProfile._();

  static const String logout = '/logout';
  static const String edit = '/edit';
  static const String setting = '/setting';
  static const String calendar = '/calendar';

  static final routesProfile = <String, WidgetBuilder>{
    logout: (BuildContext context) => LoginPage(),
    edit: (BuildContext context) => Edit(),
    setting: (BuildContext context) => Setting(),
    calendar: (BuildContext context) => MyCalendar()
  };
}
import '../configs/session.dart';

Future verificationFirstAcess(final prefs) async {
  String? firstAcessInfo = prefs.getString('firstacessinfo');
  String? firstAcessHome = prefs.getString('firstacesshome');
  String? firstAcessFood = prefs.getString('firstacessfood');
  String? firstAcessUser = prefs.getString('firstacessuser');

  if (firstAcessInfo != null) {
    if (firstAcessInfo.toString() == 'true') {
      Session.firstAcessInfo = true;
    }
  } else {
    Session.firstAcessInfo = true;
  }
  if (firstAcessHome != null) {
    if (firstAcessHome.toString() == 'true') {
      Session.firstAcessHome = true;
    }
  } else {
    Session.firstAcessHome = true;
  }
  if (firstAcessFood != null) {
    if (firstAcessFood.toString() == 'true') {
      Session.firstAcessFood = true;
    }
  } else {
    Session.firstAcessFood = true;
  }
  if (firstAcessUser != null) {
    if (firstAcessUser.toString() == 'true') {
      Session.firstAcessUser = true;
    }
  } else {
    Session.firstAcessUser = true;
  }
}

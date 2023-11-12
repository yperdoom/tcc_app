import 'package:Yan/views/admin.dart';
import 'package:Yan/views/client_page.dart';
import 'package:Yan/views/login.dart';
import 'package:Yan/views/manager_page.dart';
import 'package:flutter/material.dart';

Widget redirectViewPages(String? page) {
  if (page == 'login') {
    return const LoginPage();
  }
  if (page == 'manager') {
    return const ManagerPage();
  }
  if (page == 'admin') {
    return const AdminPage();
  }
  if (page == 'client') {
    return const ClientPage();
  }
  if (page == 'trying') {
    print('this scope not have page to view');
  }

  return const LoginPage();
}

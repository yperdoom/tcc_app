import 'package:Yan/views/main_pages/admin_page.dart';
import 'package:Yan/views/main_pages/client_page.dart';
import 'package:Yan/views/main_pages/login_page.dart';
import 'package:Yan/views/main_pages/manager_page.dart';
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

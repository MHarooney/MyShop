import 'package:flutter/material.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/components.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyShop',
        ),
      ),
      body: TextButton(
        onPressed: () {
          CacheHelper.removeData(key: 'token').then((value) {
            if (value) {
              navigateAndFinish(context, LoginScreen(),);
            }
          });
        },
        child: Text(
          'Sign Out',
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:frontend/config/colors.dart';


class widgets {
  static AppBar homeappbarwidget = AppBar(
            backgroundColor: colors.maincolor,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'URL Shortener',
              style: TextStyle(
                fontFamily: 'Prompt',
                color: colors.white
              ),
            ),
          );
  static const customborder =  OutlineInputBorder(
    borderSide: BorderSide(
      width: 1,
      color: colors.grey
    )
  );
  static const customerr = TextStyle(fontFamily: 'Prompt', fontWeight: FontWeight.w100);
}
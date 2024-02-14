import 'package:flutter/material.dart';
import 'package:flutter_progetto/resources/lang.dart';
import 'package:get/get.dart';

void changeLanguageDialog(BuildContext context) {
  // if not mounted, don't run dialog??
  if (!context.mounted) {
    return;
  }
  //Get.dialog();
  showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('choose_language'.tr),
          titlePadding: const EdgeInsets.all(30),
          children: [
            ...Lang.availableLanguages.map((element) {
              return SimpleDialogOption(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Lang.changeLanguage(element);
                },
                child: Text(
                  element.toLowerCase().tr,
                  style: TextStyle(
                      fontWeight: element == Lang.currentLanguage
                          ? FontWeight.bold
                          : null),
                ),
              );
            })
          ],
        );
      });
}

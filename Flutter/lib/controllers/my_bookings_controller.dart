import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_progetto/models/prenotazione.dart';
import 'package:flutter_progetto/resources/booking_methods.dart';
import 'package:flutter_progetto/resources/error_handler.dart';
import 'package:flutter_progetto/utils/global_variables.dart';
import 'package:get/get.dart';

class MyBookingsController extends GetxController
    with GetTickerProviderStateMixin {
  List<Prenotazione> prenotazioni = [];
  List<Prenotazione> prenotazioniAttive = [];
  List<Prenotazione> prenotazioniScadute = [];
  late AnimationController _controller;
  late Animation<double> animation;
  final RxBool isRight = true.obs;
  final RxBool isVisible = true.obs;
  @override
  void onClose() {
    _controller.dispose();
    //print("CONTROLLER disposed");
    super.onClose();
  }

  void changePrenotazioneState(
      Prenotazione prenotazione, PrenotazioneState state) {
    prenotazioniAttive.remove(prenotazione);

    prenotazione.state = state;
    prenotazioniScadute.add(prenotazione);
    sort();
    update();
    _setPrenotazioneState(prenotazione, state);
  }

  void _setPrenotazioneState(
      Prenotazione prenotazione, PrenotazioneState state) {
    try {
      BookingMethods().updatePrenotazione(prenotazione, state);
    } on ErrorException catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(milliseconds: 500), () => getPrenotazioni());

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    //startAnimation();
  }

  void getPrenotazioni() async {
    try {
      prenotazioni = await BookingMethods().getPrenotazioni();
    } on ErrorException catch (e) {
      prenotazioni = [];
      ErrorHandler.handleError(e);
    } finally {
      prenotazioniAttive.clear();
      prenotazioniScadute.clear();
      for (var prenotazione in prenotazioni) {
        if (prenotazione.state == PrenotazioneState.active) {
          prenotazioniAttive.add(prenotazione);
        } else {
          prenotazioniScadute.add(prenotazione);
        }
      }
      sort();
      update();
    }
  }

  void startAnimation() async {
    if (prenotazioniAttive.isEmpty) {
      return;
    }
    isVisible.value = true;
    isRight.value = true;
    await _controller.forward();
    await _controller.reverse();
    isRight.value = false;
    await _controller.forward();
    await _controller.reverse();
    isVisible.value = false;
  }

  void showHelp() async {
    await Get.defaultDialog(
      title: 'help'.tr,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('• ${'booking_manage'.tr}.'),
          const SizedBox(
            height: 8,
          ),
          Text(
              '• ${'booking_handle_left'.tr}.'),
          const SizedBox(
            height: 8,
          ),
          Text('• ${'booking_handle_right'.tr}.'),
        ],
      ),
      radius: 10,
      confirm: ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('OK')),
    );
    startAnimation();
    //Get.defaultDialog();
  }

  void sort() {
    prenotazioniAttive.sort((a, b) => b.id!.compareTo(a.id!));
    prenotazioniScadute.sort((a, b) => b.id!.compareTo(a.id!));
  }

  Future<void> getDeleteDialog(void Function() onConfirm) async {
    await Get.defaultDialog(
      title: 'cancel'.tr,
      middleText: 'confirm_cancel'.tr,
      textConfirm: 'yes'.tr,
      textCancel: 'cancel'.tr,
      onConfirm: onConfirm,
    );
  }

  Future<void> getDoneDialog(void Function() onConfirm) async {
    await Get.defaultDialog(
      title: 'do_booking'.tr,
      middleText: 'confirm_done'.tr,
      textConfirm: 'yes'.tr,
      textCancel: 'cancel'.tr,
      onConfirm: onConfirm,
    );
  }
}

import 'package:flutter_progetto/models/corso.dart';
import 'package:flutter_progetto/resources/booking_methods.dart';
import 'package:flutter_progetto/resources/error_handler.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {
  List<Corso> corsi = [];
  List<Corso> searchedCorsi = [];
  Rx<bool> isLoading = false.obs;
  Future<void> getCorsi() async {
    isLoading.value = true;
    try {
      corsi = await BookingMethods().getCorsi();
      resetSearch();

      await Future.delayed(const Duration(milliseconds: 400));
      isLoading.value = false;
      update();
    } on ErrorException catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  void resetSearch() {
    searchedCorsi = List.from(corsi);
    searchedCorsi.sort((a, b) => a.nome.compareTo(b.nome));
  }

  Future<void> searchCorsi(String text) async {
    isLoading.value = true;
    if (text.isEmpty) {
      getCorsi();
    } else {
      try {
        searchedCorsi = await BookingMethods().searchCorso(text);
        await Future.delayed(const Duration(milliseconds: 400));
        isLoading.value = false;
        update();
      } on ErrorException catch (e) {
        ErrorHandler.handleError(e);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCorsi();
  }
}

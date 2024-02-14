import 'package:flutter_progetto/controllers/corso_controller.dart';
import 'package:flutter_progetto/models/orario.dart';
import 'package:flutter_progetto/resources/booking_methods.dart';
import 'package:flutter_progetto/resources/error_handler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BookingController extends GetxController {
  final CorsoController corsoController = Get.find<CorsoController>();
  late final RxString date;
  late RxList<List<Orario>> orari;
  @override
  void onInit() {
    super.onInit();
    date = DateFormat('EEEE, dd MMM', Get.locale?.languageCode)
        .format(getFirstDate())
        .obs;
    // random value so it's seen as not list<dynamic>
    orari = List.generate(
        corsoController.docenti.length, (index) => [Orario(orario: 1)]).obs;
    getOrari();
  }

  void getOrari() async {
    try {
      List<List<Orario>> orariTemp = List.generate(orari.length, (index) => []);
      for (int i = 0; i < orari.length; i++) {
        orariTemp[i] = await BookingMethods().getOrarioByDocente(
            corsoController.docenti[i], currentDate().weekday);
      }
      orari.value = orariTemp;
    } on ErrorException catch (e) {
      ErrorHandler.handleError(e);
    }
  }

  DateTime getFirstDate() {
    DateTime now = DateTime.now();
    if (now.weekday == 6 || now.weekday == 7) {
      now = now.add(Duration(days: 8 - now.weekday));
    }
    return now;
  }

  DateTime currentDate() {
    var noYearDate =
        DateFormat('EEEE, dd MMM', Get.locale?.languageCode).parse(date.value);
    return DateTime(DateTime.now().year, noYearDate.month, noYearDate.day);
  }

  void changeDate(DateTime? newDate) {
    if (newDate == null) {
      return;
    }
    date.value =
        DateFormat('EEEE, dd MMM', Get.locale?.languageCode).format(newDate);
    getOrari();
  }
}

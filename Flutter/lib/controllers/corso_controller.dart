import 'package:flutter_progetto/controllers/my_bookings_controller.dart';
import 'package:flutter_progetto/models/corso.dart';
import 'package:flutter_progetto/models/docente.dart';
import 'package:flutter_progetto/resources/booking_methods.dart';
import 'package:flutter_progetto/resources/error_handler.dart';
import 'package:get/get.dart';

class CorsoController extends GetxController{
  List<Docente> docenti = [];
  final Corso corso;
  final RxBool isAlreadyBooked = false.obs;
  CorsoController({required this.corso});
  final myBookingsController = Get.find<MyBookingsController>();

  void getDocenti() async {
    try{
      docenti = await BookingMethods().getDocentiByCorso(corso);
    }
    on ErrorException catch(e){
      ErrorHandler.handleError(e);
    }
    

    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getDocenti();
    for (var element in myBookingsController.prenotazioniAttive) {
      if(element.corso!.id==corso.id) {
        isAlreadyBooked.value = true;
      }
    }

  }

  
}
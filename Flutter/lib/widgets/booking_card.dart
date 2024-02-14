import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/corso_controller.dart';
import 'package:flutter_progetto/controllers/my_bookings_controller.dart';
import 'package:flutter_progetto/models/docente.dart';
import 'package:flutter_progetto/models/orario.dart';
import 'package:flutter_progetto/models/prenotazione.dart';
import 'package:flutter_progetto/pages/booking_info_page.dart';
import 'package:flutter_progetto/resources/booking_methods.dart';
import 'package:flutter_progetto/resources/error_handler.dart';
import 'package:flutter_progetto/utils/error_codes.dart';
import 'package:get/get.dart';

class BookingCard extends StatefulWidget {
  final Docente docente;
  final int giorno;
  final List<Orario> orario;

  const BookingCard({
    super.key,
    required this.docente,
    required this.giorno,
    required this.orario,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  int? _val;
  final corsoController = Get.find<CorsoController>();
  void _addPrenotazione() async {
    if (_val == null) {
      Get.snackbar(
        'error'.tr,
        "select_valide_hour".tr,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    try {
      Prenotazione addedPrentazione = await BookingMethods().setPrenotazione(
          corsoController.corso,
          widget.docente,
          widget.giorno,
          Orario(orario: _val!));
      if (addedPrentazione.id == null) {
        throw ErrorException(errNum: ErrorCodes.ERROR_UNKNOWN.errNum);
      }
      Get.find<MyBookingsController>().getPrenotazioni();
      Get.snackbar('success'.tr, 'booking_done'.tr);
      Get.offUntil(
          GetPageRoute(
            page: () => BookingInfoPage(
              prenotazione: addedPrentazione,
            ),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300),
          ),
          (route) => (route as GetPageRoute).isFirst);
    } on ErrorException catch (e) {
      Get.back(closeOverlays: true);
      ErrorHandler.handleError(e);
    }
  }

  bool _isFull() {
    return widget.orario.length == Orario.orariDisponibili.length;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isFull() ? 0.5 : 1,
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Get.theme.colorScheme.primaryContainer),
              //color: Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.primaryContainer,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Text(
                    '${widget.docente.nome} ${widget.docente.cognome}${_isFull() ? ' (Pieno)' : ''}',
                    style: Get.theme.textTheme.titleMedium!.copyWith(
                      color: Get.theme.colorScheme.primary,
                    ),
                  ),
                ),
                //const Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Get.theme.colorScheme.background),
                  //   borderRadius:
                  //       const BorderRadius.vertical(bottom: Radius.circular(20)),
                  // ),
                  height: 100,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${'choose_available_hours'.tr}:',
                          style: Get.theme.textTheme.bodyMedium,
                        ),
                      ),
                      DropdownMenu(
                        enabled: !_isFull(),
                        onSelected: (value) => _val = value,
                        width: 120,
                        dropdownMenuEntries: Orario.orariDisponibili.keys
                            .map(
                              (key) => DropdownMenuEntry(
                                value: key,
                                label: Orario(orario: key).toString(),
                                enabled: !widget.orario
                                    .contains(Orario(orario: key)),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  child: Text('book'.tr),
                  onPressed: () => _isFull() ? null : _addPrenotazione(),
                ),
              ],
            ),
          )),
    );
  }
}

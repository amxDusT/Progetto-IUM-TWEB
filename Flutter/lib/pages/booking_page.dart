import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/booking_controller.dart';
import 'package:flutter_progetto/controllers/corso_controller.dart';
import 'package:flutter_progetto/models/corso.dart';
import 'package:flutter_progetto/widgets/booking_card.dart';
import 'package:get/get.dart';

class BookingPage extends StatelessWidget {
  final Corso corso;
  late final BookingController _bookingController;
  BookingPage({super.key, required this.corso}) {
    getController();
  }
  void getController() {
    _bookingController = Get.put(BookingController());
  }

  bool _predicate(DateTime time) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    if (time.isBefore(date)) {
      return false;
    } else if (time.isAfter(
        _bookingController.getFirstDate().add(const Duration(days: 6)))) {
      return false;
    } else if (time.weekday == 6 || time.weekday == 7) {
      return false;
    }
    return true;
  }

  void _showDate(BuildContext context) async {
    DateTime? date = await _getDate(context);
    _bookingController.changeDate(date);
  }

  Future<DateTime?> _getDate(context) {
    return showDatePicker(
      context: context,
      initialDate: _bookingController.currentDate(),
      firstDate: _bookingController.getFirstDate(),
      lastDate: _bookingController.getFirstDate().add(const Duration(days: 8)),
      selectableDayPredicate: _predicate,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('book'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              //widthFactor: 2.0,
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                ),
                onPressed: () => _showDate(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_month),
                    const SizedBox(width: 10),
                    Obx(() => Text(_bookingController.date.value)),
                  ],
                ),
              ),
            ),
            Text('lesson_duration'.tr),
            const Divider(),
            Expanded(
              child: GetBuilder<CorsoController>(
                builder: (controller) => ListView.builder(
                  shrinkWrap: true,
                  //physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.docenti.length,
                  itemBuilder: (context, index) {
                    return Obx(
                      () => BookingCard(
                        docente: controller.docenti[index],
                        giorno: _bookingController.currentDate().weekday,
                        orario: _bookingController.orari[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

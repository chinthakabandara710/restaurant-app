import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Flutter code sample for [showDatePicker].

// class DatePickerApp extends StatelessWidget {
//   const DatePickerApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       restorationScopeId: 'app',
//       home: const DatePickerExample(restorationId: 'main'),
//     );
//   }
// }

class DatePickerExample extends StatefulWidget {
  const DatePickerExample({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

double income = 0;
String date = '';

/// RestorationProperty objects can be used because of RestorationMixin.
class _DatePickerExampleState extends State<DatePickerExample>
    with RestorationMixin {
  Future getDocs(String date) async {
    income = 0;

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("payments").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      if (a["date"] == date) {
        setState(() {
          income = a['amount'] + income;
        });
        print(a['amount']);
      }
      ;
    }
  }

  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime(2023, 9, 14));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        // income += 100;
        _selectedDate.value = newSelectedDate;
        date =
            '${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day}';
        String formattedDate =
            DateFormat('yyyy-MM-dd').format(_selectedDate.value);
        getDocs(formattedDate);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            // 'Selected: ${_selectedDate.value}',
            // 'Selected: $date',
            // 'Selected: $formattedDate',
            'Total Income is Generated !',
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Your Daily Income'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  income = 0;
                });
              },
              icon: Icon(Icons.restart_alt))
        ],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Please select your date to find the daily income',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  _restorableDatePickerRouteFuture.present();
                },
                child: const Text('Your Date'),
              ),
              SizedBox(
                height: 30,
              ),
              Visibility(
                visible: income == 0 ? false : true,
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 15.0, // soften the shadow
                        spreadRadius: 5.0, //extend the shadow
                        offset: Offset(
                          5.0, // Move to right 5  horizontally
                          5.0, // Move to bottom 5 Vertically
                        ),
                      )
                    ],
                    // color: Colors.white,
                    color: Colors.lightGreen,

                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(38.0),
                    child: Column(
                      children: [
                        Text(
                          '$date',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Total Income',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Rs. $income',
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: income == 0 ? true : false,
                child: Text(
                  'No income',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

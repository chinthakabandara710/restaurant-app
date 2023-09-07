import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Task/cart_data.dart';

class AddTaskScreen extends StatelessWidget {
  final Function? addTaskCallBack;
  AddTaskScreen({@required this.addTaskCallBack});

  @override
  Widget build(BuildContext context) {
    String? newTaskTitle;
    double newPriceVal = 100.0;
    int newQuantity = 1;

    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(30.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                autofocus: true,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "Your task"),
                onChanged: (newText) {
                  newTaskTitle = newText;
                },
              ),
              Container(
                color: Colors.lightBlueAccent,
                child: TextButton(
                  onPressed: () {
                    Provider.of<CartData>(context, listen: false)
                        .addItems(newTaskTitle, newPriceVal, newQuantity);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Task/cart_data.dart';
import 'CartTile.dart';

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final task = Provider.of<CartData>(context).carts[index];

            return CartTile(
              price: task.price,
              cartTitle: task.name,
              isChecked: task.isdone,
              quantity: task.quantity,
              removeCartItem: () {
                Provider.of<CartData>(context, listen: false).deleteTask(task);
              },
              plus: () {
                Provider.of<CartData>(context, listen: false)
                    .increaseQuantity(task);
              },
              minus: () {
                Provider.of<CartData>(context, listen: false)
                    .decreaseQuantity(task);
              },
            );
          },
          itemCount: Provider.of<CartData>(context).cartItemCount,
        );
      },
    );
  }
}

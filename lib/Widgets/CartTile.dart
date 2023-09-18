import 'package:flutter/material.dart';

class CartTile extends StatelessWidget {
  final double price;

  final bool isChecked;
  final String cartTitle;
  final int quantity;
  VoidCallback removeCartItem;
  VoidCallback plus;
  VoidCallback minus;

  CartTile({
    this.price = 0.0,
    this.cartTitle = '',
    this.isChecked = false,
    this.quantity = 1,
    required this.removeCartItem,
    required this.plus,
    required this.minus,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // onLongPress: longPressCallBack,
      // title: Text('Price \$$price'),

      title: Text(
        cartTitle,
        style: TextStyle(
            decoration: isChecked ? TextDecoration.lineThrough : null),
      ),

      subtitle: Text('Rs. $price'),
      // trailing: Row(
      //   children: [
      //     IconButton(
      //         onPressed: () {
      //           print('Plus');
      //         },
      //         icon: Icon(Icons.add)),
      //     SizedBox(
      //       width: 5.0,
      //     ),
      //     Text('\$$price'),
      //     SizedBox(
      //       width: 5.0,
      //     ),
      //     IconButton(
      //         onPressed: () {
      //           print('Minus');
      //         },
      //         icon: Icon(Icons.minimize)),
      //   ],
      // ),
      // trailing: Checkbox(
      //   activeColor: Colors.lightBlueAccent,
      //   value: isChecked,
      //   onChanged: checkBoxCallBack as void Function(bool?)?,
      // ),
      trailing: SizedBox(
        width: 120,
        child: Container(
          width: 100.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(width: 0.8, color: Colors.black54),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: plus,
                color: Colors.green,
              ),
              Text(
                '$quantity',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: minus,
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: removeCartItem,
      ),
    );
  }
}

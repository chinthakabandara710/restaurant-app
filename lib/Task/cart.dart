class Cart {
  final String name;
  bool isdone;
  double price;
  int quantity;

  Cart(
      {this.name = '',
      this.isdone = false,
      this.price = 0.0,
      this.quantity = 1});

  void toggleDone() {
    isdone = !isdone;
  }

  void increaseQ() {
    quantity++;
  }

  void decreaseQ() {
    // if (quantity == 0) {
    //   quantity = 0;
    // } else {
    //   quantity--;
    // }

    quantity == 1 ? 1 : quantity--;
  }
}

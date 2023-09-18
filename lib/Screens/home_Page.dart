import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:restuarant/Screens/addHighlights.dart';
import 'package:restuarant/Screens/cart_screen.dart';
import 'package:restuarant/Screens/settings.dart';
import 'package:restuarant/Screens/welcome.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../Components/bottom_app_bar.dart';
import '../Task/cart_data.dart';
import '../constants.dart';
import 'add_main.dart';
import 'menu.dart';
import 'order_history.dart';

class HomePage extends StatefulWidget {
  static String id = "home_screen";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
String loggedInUser = '';
String userId = "";
String fullName = "";
String profilePic = "";
String mobile = "";

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  // text fields' controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  // .collection("Menu")

  Future getDocs() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: loggedInUser)
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      setState(() {
        userId = a['uid'].toString();
        // print(a['uid']);
        // print(a['firstname']); edit plz
        fullName = '${a['firstname']} ${a['lastname']}';
        profilePic = a['imgUrl'];
        mobile = a['mobile'].toString();
        // print(fullName);
      });
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        //do domething
        loggedInUser = user.email!;
        // print(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "admin") {
          role = true;
        } else {
          role = false;
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getImageLinks();
    getCurrentUser();
    getDocs();
    super.initState();
  }

  bool? role;

  final CollectionReference menuTitle =
      FirebaseFirestore.instance.collection('Menu');

  // .orderBy("priority", "asc")

  Future<void> _deleteProduct(String productId) async {
    await menuTitle.doc(productId).delete();

    // Show a snackbar
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text('You have successfully deleted a product')));
  }

  late List<String> images = [
    'https://firebasestorage.googleapis.com/v0/b/restaurantapp-bbb0e.appspot.com/o/highlights%2F1693917123658?alt=media&token=4a7dc3d6-e5c0-4317-b410-aa94945bc26c'
  ];
  getImageLinks() async {
    images = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("highlights").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      // print(a['imgurl']);
      setState(() {
        images.add(a['imgUrl'].toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // getImageLinks();
    getDocs();
    getCurrentUser();

    var currentHour = DateTime.now().hour;
    // String? newTaskTitle;
    // double newPriceVal = 100.0;
    route();

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'Cafe Thirsty spot',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            _key.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            size: 30.0,
            color: Colors.white,
          ),
        ),
        actions: [
          Visibility(
            visible: role == true ? false : true,
            child: Badge(
              badgeContent: Text(
                '${Provider.of<CartData>(context).cartItemCount}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              position: const BadgePosition(start: 30, bottom: 30),
              child: IconButton(
                onPressed: () {
                  if (Provider.of<CartData>(context, listen: false)
                          .getTotal() !=
                      0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartsScreen(),
                      ),
                    );
                  } else {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "Empty Cart",
                      desc: "Please add items into the card",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        ),
                      ],
                    ).show();
                  }
                },
                color: Colors.white,
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: Colors.green,
                width: double.infinity,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage('$profilePic'),
                      radius: 50.0,
                      // backgroundColor: Colors.red,
                    ),
                    Text(
                      '$fullName',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$mobile',
                      style: TextStyle(
                        fontFamily: 'Source Sans Pro',
                        fontSize: 20.0,
                        color: Colors.teal.shade100,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.add_a_photo_outlined,
                ),
                title: const Text('Add Highlights'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Highlights(),
                    ),
                  );
                },
              ),
              Visibility(
                visible: role == true ? true : false,
                child: ListTile(
                  leading: Icon(
                    Icons.fastfood,
                  ),
                  title: const Text('Add Mains'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddMains()));
                  },
                ),
              ),
              Visibility(
                visible: role == true ? true : false,
                child: ListTile(
                  leading: Icon(
                    Icons.password_outlined,
                  ),
                  title: const Text('Change Admin Password'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminSettings()));
                  },
                ),
              ),
              Visibility(
                visible: role == true ? true : false,
                child: ListTile(
                  leading: Icon(
                    Icons.history_edu_sharp,
                  ),
                  title: const Text('Orders History'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrdersHistory()));
                  },
                ),
              ),
              SizedBox(
                height: 270,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Container(
                  //   width: double.infinity,
                  //   color: Colors.black,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       Navigator.of(context).push(MaterialPageRoute(
                  //           builder: (context) => AddMains()));
                  //     },
                  //     child: Text('Add Mains'),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.redAccent,
                    child: TextButton(
                      onPressed: () {
                        loggedInUser = '';
                        userId = "";
                        FirebaseAuth.instance.signOut();
                        try {
                          Navigator.pushNamed(context, Welcome.id);
                        } catch (e) {}
                      },
                      child: Text(
                        'Log out',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 15.0),
                child: Row(
                  children: [
                    Text(
                      'Good ',
                      style: GoogleFonts.courgette(
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentHour < 12 ? 'morning!' : 'afternoon!',
                      style: GoogleFonts.courgette(
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        color: currentHour < 12
                            ? Colors.green
                            : Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  children: [
                    Text(
                      'Hi, $fullName 😊',
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(width: 0.8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    width: 0.8,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                hintText: 'Search food',
                prefixIcon: Icon(
                  Icons.search,
                  size: 30.0,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Text(
                  'Highlights',
                  style: counterTextStyle,
                )
              ],
            ),
          ),
          Container(
              child: CarouselSlider.builder(
            itemCount: images.length,
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            itemBuilder: (context, index, realIdx) {
              return Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            child: Image.network(
                              images[index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ));
                  },
                  child: Center(
                      child: Image.network(images[index],
                          fit: BoxFit.cover, width: 1000)),
                ),
              );
            },
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: StreamBuilder(
              stream:
                  menuTitle.orderBy('priority', descending: false).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            // print(documentSnapshot.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MenuScreen(
                                    documentSnapshot.id,
                                    documentSnapshot['imgUrl'].toString(),
                                    role),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 3.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              border: Border.all(
                                width: 1.0,
                                color: Colors.grey,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.0),
                                    child: Image.network(
                                      '${documentSnapshot['imgUrl'].toString()}',
                                      width: 100,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  // margin: EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          documentSnapshot['title'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: role == true ? true : false,
                                  child: Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: () {
                                        print(documentSnapshot.id);
                                        Alert(
                                            context: context,
                                            desc: 'Do you want to delete ',
                                            buttons: [
                                              DialogButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                              DialogButton(
                                                color: Color.fromRGBO(
                                                    243, 73, 73, 1.0),
                                                onPressed: () {
                                                  Navigator.pop(context);

                                                  _deleteProduct(
                                                      documentSnapshot.id);
                                                  Alert(
                                                    context: context,
                                                    desc:
                                                        "Successfully deleted.",
                                                    // image: Image.asset(
                                                    //     "./assets/success.png"),
                                                  ).show();
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ]).show();
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottom_app_bar(
        loggedInuserId: userId,
        loggedInEmail: loggedInUser,
        user: role,
        // fabLocation: FloatingActionButtonLocation.centerDocked,
        // shape: true ? const CircularNotchedRectangle() : null,
      ),
    );
  }
}

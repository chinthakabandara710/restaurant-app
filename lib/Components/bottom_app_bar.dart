import 'package:flutter/material.dart';
import 'package:restuarant/Screens/orders.dart';
import '../Screens/adminChatScreen.dart';
import '../Screens/adminOrders.dart';
import '../Screens/carousel.dart';
import '../Screens/chat_screen.dart';
import '../Screens/home_Page.dart';
import '../Screens/notifications.dart';
import '../Screens/income_generate.dart';
// import '../Screens/income_generate.dart';

class bottom_app_bar extends StatelessWidget {
  // const bottom_app_bar({
  //   this.loggedInuserId = '',
  //   this.loggedInEmail = '',
  //   this.user,
  //   // this.fabLocation = FloatingActionButtonLocation.endDocked,
  //   // this.shape = const CircularNotchedRectangle(),
  // });
  bottom_app_bar({
    Key? key,
    this.loggedInuserId = '',
    this.loggedInEmail = '',
    this.user,
  }) : super(key: key) {
    // _documentReference =
    //     FirebaseFirestore.instance.collection('users').doc(userid);
    // _referenceComments = _documentReference.collection('messages');
  }

  // final FloatingActionButtonLocation fabLocation;
  // final NotchedShape? shape;
  final bool? user;
  final String loggedInuserId;
  final String loggedInEmail;

  // static final List<FloatingActionButtonLocation> centerLocations =
  //     <FloatingActionButtonLocation>[
  //   FloatingActionButtonLocation.centerDocked,
  //   FloatingActionButtonLocation.centerFloat,
  // ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      // shape: shape,
      color: Theme.of(context).primaryColorDark,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Visibility(
                visible: true,
                child: IconButton(
                  color: Colors.white,
                  tooltip: 'Home',
                  icon: const Icon(Icons.home),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(),
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: true,
                child: IconButton(
                  color: Colors.white,
                  tooltip: 'Your Orders',
                  icon: const Icon(Icons.featured_play_list_outlined),
                  onPressed: () {
                    if (user == false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Orders(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminOrders(),
                        ),
                      );
                    }
                  },
                ),
              ),
              // if (centerLocations.contains(fabLocation)) const Spacer(),
              Visibility(
                visible: true,
                child: IconButton(
                  color: Colors.white,
                  tooltip: 'Offers',
                  icon: const Icon(Icons.local_offer_sharp),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Notifications(
                          userType: user,
                          userid: loggedInuserId,
                          email: loggedInEmail,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: true,
                child: IconButton(
                  color: Colors.white,
                  tooltip: 'Agent Support',
                  icon: const Icon(Icons.support_agent_outlined),
                  onPressed: () {
                    print(user);
                    if (user == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminChatScreen(),
                          ));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              loggedInuserId,
                              loggedInEmail,
                            ),
                          ));
                    }
                    ;
                  },
                ),
              ),
              Visibility(
                visible: user == true ? true : false,
                child: IconButton(
                  color: Colors.white,
                  tooltip: 'Analysis',
                  icon: const Icon(Icons.analytics),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DatePickerExample(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

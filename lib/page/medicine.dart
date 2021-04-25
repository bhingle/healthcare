import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:my_app/page/Cart.dart';
import 'package:my_app/page/PastOrdersList.dart';

// import 'package:cached_network_image/cached_network_image.dart';

import 'MedicineDetails.dart';

String name = "";
// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(

//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

class Medicine extends StatefulWidget {
  Medicine({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MedicineState createState() => _MedicineState();
}

class _MedicineState extends State<Medicine>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Trip photo widget template
    Widget tripPhotos = new StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('medicine').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return new Text(
                'Error in receiving trip photos: ${snapshot.error}');
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('Not connected to the Stream or null');

            case ConnectionState.waiting:
              return new Text('Awaiting for interaction');

            case ConnectionState.active:
              print("Stream has started but not finished");

              var totalPhotosCount = 0;
              List<DocumentSnapshot> tripPhotos;

              if (snapshot.hasData) {
                tripPhotos = snapshot.data.docs;
                // print(tripPhotos);
                totalPhotosCount = tripPhotos.length;

                if (totalPhotosCount > 0) {
                  return new GridView.builder(
                      itemCount: totalPhotosCount,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                setState(() {
                                  name = tripPhotos[index].id;

                                  // DocumentSnapshot variable = FirebaseFirestore.instance.doc("$name").get();
                                  print("name:$name");
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicineDetails(name),
                                  ),
                                );
                              },
                              child: Container(
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                    // ClipRect(
                                    //   child: Align(
                                    //       alignment: Alignment.topCenter,
                                    //       heightFactor: 0.7,
                                    //       child: new CachedNetworkImage(
                                    //         placeholder: (context, url) =>
                                    //         new CircularProgressIndicator(),
                                    //         imageUrl:
                                    //         tripPhotos[index].data['url'],
                                    //       )),
                                    // ),

                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(children: [
                                        Image(
                                          width: 100,
                                          height: 100,
                                          image: NetworkImage(
                                              "https://images-static.nykaa.com/media/catalog/product/f/a/fa070100.jpg"),
                                        ),
                                        Text(tripPhotos[index].data()['name']),
                                        Text((tripPhotos[index].data()['price'])
                                            .toString()),
                                      ]),
                                      color: Colors.teal[100],
                                    ),
                                  ])),
                            ),
                          ),
                        );
                      });
                }
              }

              return new Center(
                  child: Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                  ),
                  new Text(
                    "No trip photos found.",
                    style: Theme.of(context).textTheme.title,
                  )
                ],
              ));

            case ConnectionState.done:
              return new Text('Streaming is done');
          }

          return Container(
            child: new Text("No trip photos found."),
          );
        });

    return Scaffold(
        // appBar: AppBar(
        //   // Here we take the value from the MyHomePage object that was created by
        //   // the App.build method, and use it to set our appbar title.
        //   // title: Text(widget.title),
        // ),
        body: GestureDetector(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                tripPhotos,
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        //Init Floating Action Bubble
        floatingActionButton: FloatingActionBubble(
          // Menu items
          items: <Bubble>[
            // Floating action menu item
            Bubble(
              title: "Your Orders",
              iconColor: Colors.white,
              bubbleColor: Colors.indigo,
              icon: Icons.people,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PastOrdersList(),
                  ),
                );
              },
            ),
            //Floating action menu item
            Bubble(
              title: "Cart",
              iconColor: Colors.white,
              bubbleColor: Colors.indigo,
              icon: Icons.home,
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              onPress: () {
                _animationController.reverse();
                 Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cart(),
                  ),
                );
              },
            ),
          ],

          // animation controller
          animation: _animation,

          // On pressed change animation state
          onPress: _animationController.isCompleted
              ? _animationController.reverse
              : _animationController.forward,

          // Floating Action button Icon color
          iconColor: Colors.blue,

          // Flaoting Action button Icon
          animatedIconData: AnimatedIcons.add_event,
        ));
  }
}

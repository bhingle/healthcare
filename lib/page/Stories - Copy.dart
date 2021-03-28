import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';

class Stories extends StatefulWidget {
  Stories({Key key}) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

// for 3- dot options in a post
enum Options { report }

// Like button code
Future<bool> onLikeButtonTapped(bool isLiked) async {
  /// send your request here
  // final bool success= await sendRequest();

  /// if failed, you can do nothing
  // return success? !isLiked:isLiked;

  return !isLiked;
}

class _StoriesState extends State<Stories> {
  TextEditingController blogText = new TextEditingController();

  // String blogTextString = '';
  // bool shouldDisplay = true;
  String _selection = "";

  String dataToShare = 'Sample text to share';

  void _shareContent(content) {
    Share.share(content);
  }

  void uploadData() {
    final user = FirebaseAuth.instance.currentUser;
    String name = user.displayName;
    String photoURL = user.photoURL;
    // print("in upload data");
    Map<String, dynamic> data = {
      "field1": blogText,
    };
    FirebaseFirestore.instance
        .collection("blogs")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({
      'mainText': blogText.text,
      'likes': 0,
      'reports': 0,
      'photoURL': photoURL,
      'username': name
    });
    // print("done");
  }

  var flag = true;
  // Stream<QuerySnapshot> snapshot =
  // FirebaseFirestore.instance.collection('blogs').snapshots();
  // print('$snapshot.docs');
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      // title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Blog Posted Successfully"),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.indigo, // background
            onPrimary: Colors.white, // foreground
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('close'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('blogs').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('We got an Error ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    // case ConnectionState.waiting:
                    //   return Center(
                    //     child: Text('Loading'),
                    //   );

                    // case ConnectionState.none:
                    //   return Text('oops no data');

                    // case ConnectionState.done:
                    //   return Text('We are Done');

                    default:
                      return Container(
                          // child: ListView.builder(
                          child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot allBlogs = snapshot.data.docs[index];
                          // String a = allBlogs.data()['mainText'];
                          // if(index == 1){
                          //       flag = false;
                          // }
                          return Column(
                              // height: 50,
                              // color: Colors.amber[colorCodes[index]],
                              // child: Center(child: Text('Entry ${entries[index]}')),
                              children: [
                                // Text('$index'),
                                // if(index == 0){
                                // allBlogs.data()['likes'] == -1
                                index == 0
                                    ?
                                    // if(index == 1){
                                    //  _StoriesState.flag = false;
                                    // },
                                    // if (flag)
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 30, left: 20.0, right: 20.0),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text("Write Your Blog")),
                                          // Text(a),
                                          new Theme(
                                              data: new ThemeData(
                                                primaryColor: Colors.indigo,
                                                primaryColorDark:
                                                    Colors.indigoAccent,
                                              ),
                                              child: new TextFormField(
                                                controller: blogText,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                minLines:
                                                    1, //Normal textInputField will be displayed
                                                maxLines:
                                                    5, // when user presses enter it will adapt to it
                                                decoration: new InputDecoration(
                                                  border:
                                                      new OutlineInputBorder(
                                                          borderSide:
                                                              new BorderSide(
                                                                  color: Colors
                                                                      .indigo)),
                                                  hintText: 'Write Here ...',
                                                  labelText: 'Blog ',
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    // blogTextString = value;
                                                  });
                                                },
                                                validator: (value) {
                                                  return (value.isEmpty
                                                      ? "Please Enter Some text "
                                                      : null);
                                                },
                                              )),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    Colors.indigo, // background
                                                onPrimary:
                                                    Colors.white, // foreground
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  // flag = false;
                                                  //  blogTextString = "";
                                                  uploadData();
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        _buildPopupDialog(
                                                            context),
                                                  );
                                                  blogText.clear();
                                                });
                                              },
                                              child: Text('Post')),
                                          // flag =false;
                                        ]))
                                    : Container(
                                        //    margin: EdgeInsets.only(top: 30, left: 20.0, right: 20.0),
                                        // padding: const EdgeInsets.all(10.0),

                                        child: Column(children: [
                                        Row(// row for photo ,username , 3-dots
                                            children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(allBlogs
                                                    .data()['photoURL']),
                                                // "https://drop.ndtv.com/homepage/images/icons/logo-on-dark-bg.png"),
                                                fit: BoxFit.fill,
                                              ),
                                              color: Colors.grey[300],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Container(
                                            // color: Colors.red,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 20, 20, 20),
                                              child: Text(
                                                  allBlogs.data()['username']),
                                              // 'User Name') // ,style: TextStyle(fontSize: 22))
                                              // '${entries[index]}' )
                                            ),
                                          ),
                                          Container(
                                              child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 0, 0, 0),
                                                  child:
                                                      PopupMenuButton<Options>(
                                                    onSelected:
                                                        (Options result) {
                                                      setState(() {
                                                        _selection = "report";
                                                      });
                                                    },
                                                    itemBuilder: (BuildContext
                                                            context) =>
                                                        <
                                                            PopupMenuEntry<
                                                                Options>>[
                                                      const PopupMenuItem<
                                                          Options>(
                                                        value: Options.report,
                                                        child: Text(
                                                            'Report this Post'),
                                                      ),
                                                    ],
                                                  ))),
                                        ]),
                                        Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 30, 10),
                                            child: Row(
                                              // row for content
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  allBlogs.data()['mainText'],
                                                  // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pellentesque dictum sollicitudin. Quisque ullamcorper at ex ornare maximus. Nam risus sapien, sollicitudin non nisl vel, ultricies finibus felis. Donec pharetra ligula nec sem molestie, vel venenatis libero volutpat. Quisque a ex ultrices, faucibus nulla id, sodales sem. Fusce molestie placerat vulputate. Duis ultrices nec purus et fermentum. Curabitur scelerisque odio sit amet augue bibendum scelerisque",
                                                  maxLines: 10,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ))
                                              ],
                                            )),
                                        Row(
                                          children: [
                                            // Like Button
                                            Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    80, 10, 30, 10),
                                                child: LikeButton(
                                                  size: 30,
                                                  circleColor: CircleColor(
                                                      start: Color(0xff00ddff),
                                                      end: Color(0xff0099cc)),
                                                  bubblesColor: BubblesColor(
                                                    dotPrimaryColor:
                                                        Color(0xff33b5e5),
                                                    dotSecondaryColor:
                                                        Color(0xff0099cc),
                                                  ),
                                                  likeBuilder: (bool isLiked) {
                                                    return Icon(
                                                      Icons.favorite,
                                                      color: isLiked
                                                          ? Colors
                                                              .deepPurpleAccent
                                                          : Colors.grey,
                                                      size: 30,
                                                    );
                                                  },
                                                  likeCount: 999,
                                                  countBuilder: (int count,
                                                      bool isLiked,
                                                      String text) {
                                                    var color = isLiked
                                                        ? Colors
                                                            .deepPurpleAccent
                                                        : Colors.grey;
                                                    Widget result;
                                                    if (count == 0) {
                                                      result = Text(
                                                        "love",
                                                        style: TextStyle(
                                                            color: color),
                                                      );
                                                    } else
                                                      result = Text(
                                                        text,
                                                        style: TextStyle(
                                                            color: color),
                                                      );
                                                    return result;
                                                  },
                                                  onTap: onLikeButtonTapped,
                                                )),

                                            // share button
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  40, 10, 30, 20),
                                              child: Center(
                                                child: Column(children: [
                                                  // Text(_content),
                                                  SizedBox(height: 15),

                                                  ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors
                                                            .indigo, // background
                                                        onPrimary: Colors
                                                            .white, // foreground
                                                      ),
                                                      // onPressed: _shareContent,
                                                      onPressed: () {
                                                        setState(() {
                                                          dataToShare = allBlogs
                                                                      .data()[
                                                                  'mainText'] +
                                                              "\n" +
                                                              "written By " +
                                                              allBlogs.data()[
                                                                  'username'];
                                                          _shareContent(
                                                              dataToShare);
                                                        });
                                                      },
                                                      icon: Icon(Icons.share),
                                                      label: Text('Share'))
                                                ]),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ])),
                              ]);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(height: 5, thickness: 2),
                      ));
                  }
                })));
  }
}

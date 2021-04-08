import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  // final uid = FirebaseAuth.instance.currentUser.uid;
  String price="hii",name="hi";
  List medicineList;
  bool existence;
  Future<void> fetchData() async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        existence = value.exists;
        if (existence) {
          // medicineList = value.data()['medicineList'];
           print("here is the list");
           print(value.data()['currentOrder']);
        }
        else{
          print("not found");
        }
      });
    } catch (e) {
      print(e);
    }
  }

@override
  void initState() {
    super.initState();
    fetchData();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Text("hi");
    return  Scaffold(
      body: GestureDetector(
       

        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: medicineList.length,
                            itemBuilder: (context, index) {
                              
                              // String a = medicineList.data()['hospital_name'];
                              // a = a.toUpperCase();
                              // print(a);
          //                    var medicineInfo = FirebaseFirestore.instance
          // .collection('medicine')
          // .doc(medicineList[index]["medicineId"]);
          //                     // String name = dbRef.
          //                     print("info herer");
          //                     // print(medicineInfo.get().then((value) => print(value)));
          //                      print(medicineInfo);
         
      //              FirebaseFirestore.instance
      //     .collection('medicine')
      //     .doc(medicineList[index]["medicineId"])
      //     .get()
      //     .then((value) {
      //     print("here is the list");
      //        price = value.data()['price'].toString();
      //        name = value.data()['name'];

      //         print(name);
      //         print(price);
              
              
              

      //     // String name = value.data()['name'];
      //     // print(name);
        
       
      // });
      
                                return GestureDetector(
                                  
                                 
                                  child: Container(
                                    height: 110,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[400],
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey[400],
                                            ),
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15)),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://mk0ehealtheletsj3t14.kinstacdn.com/wp-content/uploads/2009/07/best-hospital-in-south-india.jpg"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 20, 0, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 15, 0, 30),
                                                  child: Text(price
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                             
                            },
                          ),
                        )
              ),
            ],
          ),
        ),
      ),
    );

  }
}
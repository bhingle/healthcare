import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/page/Cart.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1538108149393-fbbd81895907?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aG9zcGl0YWx8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQViQ9yxtk_JUmyTZuQCDpqxGQT1PlEY7_2Ow&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-EBK3r8ZEa7ZT7l3cI3Ak-aDgvbBB9OU6Qg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNHbB5ZSRtpd7l6v4CkaEbdR8d0K0eC1cfmA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRgZ7v9m64HP1ZVMmO0NcWJztE471s06N8pdA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSFxjNw8rqyRPpLU3_uTeDz5_ChbHOKWyM39g&usqp=CAU'
];

class MedicineDetails extends StatefulWidget {
  String id;

  MedicineDetails(this.id, {Key key}) : super(key: key);

  @override
  _MedicineDetailsState createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  bool isMedicinePresent ;
  Future<void> check() async{
  await FirebaseFirestore.instance
          .collection('cart')
          .doc(FirebaseAuth.instance.currentUser.uid).collection("currentOrder").doc(widget.id)
          .get()
          .then((value) {
        isMedicinePresent = value.exists;
         isAddedColor = value.exists;
   isAddedText = value.exists;
           
          });
          // return isMedicinePresent;
  }
  int _current = 0;
  bool isAddedColor = false;
  bool isAddedText = false;
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(item, fit: BoxFit.cover, width: 1000.0),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  String name, description;
  int price, stock;
  Future<void> fetchData() async {
    try {
      await FirebaseFirestore.instance
          .collection('medicine')
          .doc(widget.id)
          .get()
          .then((value) {
        name = value.data()['name'];
        price = value.data()['price'];
        description = value.data()['description'];
        stock = value.data()['stock'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    check();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  void addToCart() {
    print(widget.id);
    setState(() => isAddedColor = !isAddedColor);
    setState(() => isAddedText = !isAddedText);
    if (isAddedText == true  ) {
      FirebaseFirestore.instance
          .collection("cart")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("currentOrder").doc(widget.id)
          .set({
        'name': name,
        'price':price,
        'quantity':1,
        'stock':stock,
        'medicineId':widget.id
      });


    } else {
      FirebaseFirestore.instance
          .collection("cart")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("currentOrder")
          .doc(widget.id)
          .delete();
    }

    // FirebaseFirestore.instance
    //     .collection("doctorinfo")
    //     .doc(FirebaseAuth.instance.currentUser.uid)
    //     .set({
    //   'speciality': data1.text,
    //   'hospital_name': data2.text,
    //   'contact': data3.text,
    //   'experience': data4.text,
    //   'degree_url': fileUrl,
    //   'name':name,
    //   'email':email,
    //   'degree':data5.text
    // });
  }

  void viewCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Cart(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: Column(children: [
              CarouselSlider(
                items: imageSliders,
                options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.map((url) {
                  int index = imgList.indexOf(url);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(0, 0, 0, 0.9)
                          : Color.fromRGBO(0, 0, 0, 0.4),
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: [
                  Column(children: [
                    Text("$name"),
                    Text("₹ $price"),
                  ]),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(120, 5, 5, 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary:
                                  isAddedColor? Colors.green : Colors.indigo),
                          // color: isAddedColor ? Colors.blue: Colors.red,
                          // textColor: Colors.white,
                          child: isAddedText 
                              ? Text("Remove From Cart")
                              : Text("Add to Cart"),
                          onPressed: addToCart,
                        ),
                      )
                    ],
                  )
                ],
              ),
              Text("Description"),
              Text("$description")
            ]),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 40.0,
        color: Colors.indigo,
        child: ElevatedButton(onPressed: viewCart, child: Text("View Cart")),
      ),
    );
  }
}

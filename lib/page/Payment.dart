import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:fluttertoast/fluttertoast.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController name = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController number = new TextEditingController();
  CollectionReference _collectionRef = FirebaseFirestore.instance
      .collection('cart')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("currentOrder");
  int tot = 0;
  Future<void> findTotalPrice() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print("mumbai");
    print(allData);

    allData.forEach(
        (element) => tot = tot + element['price'] * element['quantity']);
    print(tot);
    setState(() {});
  }

  Future<void> findAllMedicine() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("currentOrder")
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print("mumbai");
    print(allData);

    // final allData1 = querySnapshot.docs.map((doc) => doc.id);

    allData.forEach((element) => FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('pastOrder')
        .doc(timestamp)
        .collection('medicine')
        .doc()
        .set(element));
    // setState(() {});
  }

  Future<void> changeStock() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("currentOrder")
        .get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    print("mumbai");
    print(allData);

    // final allData1 = querySnapshot.docs.map((doc) => doc.id);
    allData.forEach((element){
    print("==============================================================");
    print(element['stock']);
          
          // 'email' : email.text,
       });
    

    allData.forEach((element) => FirebaseFirestore.instance
            .collection("medicine")
            .doc(element['medicineId'])
            .update({
          "stock": element['stock'] - element['quantity'],
          
          // 'email' : email.text,
        }));
    // setState(() {});
  }

  void deleteCurrentOrder() {
    

    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('currentOrder')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  void uploadDataInfo() {
    final user = FirebaseAuth.instance.currentUser;

    print("in upload data");
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('pastOrder')
        .doc(timestamp)
        .collection('info')
        .doc()
        .set({
      'name': name.text,
      'adddress': address.text,
      'number': number.text,
    });
  }

  Future<void> fetchDataMedicine() async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('currentOrder')
          .get()
          .then((value) {
        print(
            "##########################################################################");
        
      });
    } catch (e) {
      print(e);
    }
  }

  

  

  Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    // debugShowCheckedModeBanner: false;
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
        TextFormField(
          controller: name,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            hintText: '',
            labelText: 'Name  *',
          ),
          // onSaved: (String? value) {
          //   // This optional block of code can be used to run
          //   // code when the user saves the form.
          // },
          validator: (value) {
            return (value.isEmpty ? "Please Enter Speciality Field " : null);
          },
        ),
        TextFormField(
          minLines: 1, //Normal textInputField will be displayed
          maxLines: 5,
          controller: address,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            hintText: '',
            labelText: 'Address  *',
          ),
          // onSaved: (String? value) {
          //   // This optional block of code can be used to run
          //   // code when the user saves the form.
          // },
          validator: (value) {
            return (value.isEmpty ? "Please Enter Speciality Field " : null);
          },
        ),
        TextFormField(
          controller: number,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            hintText: '',
            labelText: 'Phone Number  *',
          ),
          // onSaved: (String? value) {
          //   // This optional block of code can be used to run
          //   // code when the user saves the form.
          // },
          validator: (value) {
            return (value.isEmpty ? "Please Enter Speciality Field " : null);
          },
        ),
        Text("₹" + tot.toString()),
        RaisedButton(onPressed: openCheckout, child: Text('Continue'))
      ])),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    findTotalPrice();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  var timestamp = DateTime.now().toString();

  void openCheckout() async {
    // changeStock();
    // fetchDataMedicine();
    // uploadDataInfo();
    // findAllMedicine();
    // deleteCurrentOrder();
    var options = {
      'key': 'rzp_test_qvDUGFHH8QzOtY',
      'amount': tot * 100,
      'name': 'HealthCare Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '9865324578', 'email': 'healthcare@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS abhishek: " + response.paymentId);
    // uploadDataInfo();
    // uploadDataMedicines();
    changeStock();
    uploadDataInfo();
    findAllMedicine();
    deleteCurrentOrder();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }
}

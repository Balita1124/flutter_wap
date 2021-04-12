import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = "Wap Scanning...";
  bool valid = false;
  bool showResult = false;

  bool _checkWapValidity(String firstName, String lastName) {
    return (firstName == 'Rico' && lastName == 'Fauchard');
  }

  Map<String, dynamic> _decodeMessage(String json) {
    try {
      Map<String, dynamic> wapMap = jsonDecode(json);

      return wapMap;
    } catch (ex) {
      return null;
    }
  }

  Future _scanQR() async {
    showResult = true;
    try {
      String qrResult = (await BarcodeScanner.scan()).rawContent;
      Map<String, dynamic> wapMap = _decodeMessage(qrResult);
      String message = "";
      bool localValid = false;
      if (wapMap == null) {
        localValid = false;
        message = "QrCode Invalid";
      } else {
        if (_checkWapValidity(wapMap['firstName'], wapMap['lastName'])) {
          message = "The WAP for " +
              wapMap['firstName'] +
              " " +
              wapMap['lastName'] +
              " is valid \n";
          localValid = true;
        } else {
          message = "The WAP for " +
              wapMap['firstName'] +
              " " +
              wapMap['lastName'] +
              " is not valid \n";
          localValid = true;
        }
      }
      setState(() {
        result = message;
        valid = localValid;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      appBar: AppBar(
        title: Text('Wap Scanner'),
      ),
      body: Center(
        child: Text(
          result,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanQR,
        label: Text('Scan'),
        icon: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );*/
    return Scaffold(
      appBar: AppBar(
        title: Text('Wap Scanner'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              result,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            showResult
                ? Icon(
                    valid ? Icons.done_sharp : Icons.cancel_sharp,
                    color: valid ? Colors.green : Colors.red,
                    size: 70,
                  )
                : Text(''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _scanQR,
        label: Text('Scan'),
        icon: Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

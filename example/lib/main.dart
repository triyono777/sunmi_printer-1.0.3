import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sunmi_printer/sunmi_printer.dart';
import 'package:sunmi_printer_example/services/fetch_label_img.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pingspace Demo Printer',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: Home()
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _printerStatus = '';
  bool _apiCall = false;

  @override
  void initState() {
    super.initState();


    _bindingPrinter().then( (binded) async => {
      if (binded!) {
        _getPrinterStatus(),
        _getPrinterMode(),

      }

    });

  }

  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  Future<void> _getPrinterStatus() async {
    final String? result = await SunmiPrinter.getPrinterStatus();
    setState(() {
      _printerStatus = result;
    });
  }

  Future<void> _getPrinterMode() async {
    final String? result = await SunmiPrinter.getPrinterMode();
    print('printer mode: $result');
  }

  Future<void> _printLabel(Uint8List img ) async {
    if (_printerStatus == 'Works normally') {
      print('printing..!');
      try {
        await SunmiPrinter.startLabelPrint();
        await SunmiPrinter.setAlignment(0);
        await SunmiPrinter.lineWrap(1);
        await SunmiPrinter.printImage(img);
        await SunmiPrinter.lineWrap(1);
        await SunmiPrinter.exitLabelPrint();
      } catch(e) {
        print('error');
      }

    }
  }

  Future<void> _submitPrint(BuildContext context, String value) async {
    final String _padCode = value.padLeft(6, "0");
    final String _uidCode = 'U$_padCode';
    print('print code: $_uidCode');
    try {

      List<Map<String, dynamic>> input = [{
          "uid": "$_uidCode",
          "date": 1615219200000,
          "uom": [
              "1 RL-30.5MT",
              "1 SET"
          ],
          "sticker": [
              1,
              2
          ],
          "title": [
              "8840S-100-174BDF-1-150W11-1=PIN ONLY",
              "",
              "SET",
              "AAA"
          ],
          "lines": [
              "ROUND-TO-FLAT CABLE, 26-WAY, 28AWG, SHIELDED/JACKETED, RIBBON CABLE MFG: 3M MFG P/N: 3659/26",
              "MOUSER ELECTRONIC ETC STUFF AND A LONG LIST",
              "GRQ210304425-G,POQ210201927-G"
          ],
          "toFrom": [
              "PG-PQ",
              ""
          ],
          "project": "PQ-STORE",
          "conditions": [
              "",
              "",
              "",
              "",
              "",
              "",
              ""
          ],
          "isRejected":false
      }];

      

      var img = await fetchUIDImg(input);

      img.data.url.forEach((url) async {
        Uint8List bytes = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
        print(bytes);
        await this._printLabel(bytes);
      });
      
      
                            
    } catch (e) {
      print('error: $e');

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 220.0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Image(
                    height: 100,
                    image: AssetImage('assets/images/bb_labelling_navy.png'),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text('$e'),
                ],
              ),
            ),
          );
        }   
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pingspace Demo Printer'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus!.unfocus();
        },
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Printer Status: $_printerStatus',
                          textAlign: TextAlign.center,
                        ),
                        
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: textController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter UID code. Exp: 40',
                    ),
                    inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                    ], 
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (value) async {
                      await _submitPrint(context, value);
                      textController.text = '';
                    },// Only numbers can be entered
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter uid code';
                      }
                      return null;
                    }
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: _apiCall ? Colors.black : Colors.amberAccent
                    ),
                    onPressed: _apiCall ? null : () async {

                      final FormState form = _formKey.currentState!;

                      if (form.validate()) {

                        _submitPrint(context, textController.text);
                                
                      }
                      textController.text = '';

                    },
                    child: Text(_apiCall ? 'Printing...' : 'Print Label' ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
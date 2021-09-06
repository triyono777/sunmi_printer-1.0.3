# sunmi_printer

Support Sunmi V2 Pro Label Version and Null Safety.

## Getting Started

```dart
import 'package:sunmi_printer/sunmi_printer.dart';

class _HomeState extends State<Home> {

  String? _printerStatus = '';

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
      // Possible printer status
      //  static Map _printerStatus = {
      //   'ERROR': 'Something went wrong.', 
      //   'NORMAL': 'Works normally', 
      //   'ABNORMAL_COMMUNICATION': 'Abnormal communication',
      //   'OUT_OF_PAPER': 'Out of paper',
      //   'PREPARING': 'Preparing printer',
      //   'OVERHEATED': 'Overheated',
      //   'OPEN_THE_LID': 'Open the lid',
      //   'PAPER_CUTTER_ABNORMAL': 'The paper cutter is abnormal',
      //   'PAPER_CUTTER_RECOVERED': 'The paper cutter has been recovered',
      //   'NO_BLACK_MARK': 'No black mark had been detected',
      //   'NO_PRINTER_DETECTED': 'No printer had been detected',
      //   'FAILED_TO_UPGRADE_FIRMWARE': 'Failed to upgrade firmware',
      //   'EXCEPTION': 'Unknown Error code',
      // };
    final String? result = await SunmiPrinter.getPrinterStatus();
    setState(() {
      _printerStatus = result;
    });
  }

  Future<void> _getPrinterMode() async {
    // printer mode = [  NORMAL_MODE , BLACK_LABEL_MODE, LABEL_MODE ]
    final String? result = await SunmiPrinter.getPrinterMode();
    print('printer mode: $result');
  }

  // Only support Sunmi V2 Pro Label Version. P/s: V2 Pro Standard not supported for label printing
  Future<void> _printLabel(Uint8List img ) async {
    if (_printerStatus == 'Works normally') {
      print('printing..!');
      try {
        // start point of label print
        await SunmiPrinter.startLabelPrint();
        // alignment , 0 = align left, 1 =  center, 2 = align right.
        await SunmiPrinter.setAlignment(0);
        await SunmiPrinter.lineWrap(1);
        await SunmiPrinter.printText('hello');
        await SunmiPrinter.printImage(img);
        await SunmiPrinter.lineWrap(1); // must have for label printing before exitLabelPrint() 
        await SunmiPrinter.exitLabelPrint();
        // end point of label print
      } catch(e) {
        print('error');
      }

    }
  }

Future<void> _printTransaction(Uint8List img ) async {
    if (_printerStatus == 'Works normally') {
      print('printing..!');
      try {
        await SunmiPrinter.startTransactionPrint();
        await SunmiPrinter.setAlignment(0);
        await SunmiPrinter.printText('hello');
        await SunmiPrinter.printImage(img);
        await SunmiPrinter.submitTransactionPrint();
        await SunmiPrinter.exitTransactionPrint();
      } catch(e) {
        print('error');
      }

    }
  }


  @override
  Widget build(BuildContext context) {
     // ....
  }
}
```


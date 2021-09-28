import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';




class SunmiPrinter {

  static Map _printerStatus = {
    'ERROR': 'Something went wrong.', 
    'NORMAL': 'Works normally', 
    'ABNORMAL_COMMUNICATION': 'Abnormal communication',
    'OUT_OF_PAPER': 'Out of paper',
    'PREPARING': 'Preparing printer',
    'OVERHEATED': 'Overheated',
    'OPEN_THE_LID': 'Open the lid',
    'PAPER_CUTTER_ABNORMAL': 'The paper cutter is abnormal',
    'PAPER_CUTTER_RECOVERED': 'The paper cutter has been recovered',
    'NO_BLACK_MARK': 'No black mark had been detected',
    'NO_PRINTER_DETECTED': 'No printer had been detected',
    'FAILED_TO_UPGRADE_FIRMWARE': 'Failed to upgrade firmware',
    'EXCEPTION': 'Unknown Error code',
  };


  static const MethodChannel _channel =
      const MethodChannel('sunmi_printer');

  // START call native code from java
  static Future<bool?> bindingPrinter() async { 
    final bool? status = await _channel.invokeMethod('BIND_PRINTER_SERVICE');
    return status;
  }

  static Future<bool?> unbindingPrinter() async { 
    final bool? status = await _channel.invokeMethod('UNBIND_PRINTER_SERVICE'); 
    return status;
  }

  /// reset all setting
  static Future<bool?> initPrinter() async { 
    final bool? status = await _channel.invokeMethod('INIT_PRINTER');
    return status;
  }

  static Future<String?> getPrinterStatus() async { 
    final String? status = await _channel.invokeMethod('GET_UPDATE_PRINTER');
    final statusMsg = _printerStatus[status];
    return statusMsg;
  }

  /// mode = [  NORMAL_MODE , BLACK_LABEL_MODE, LABEL_MODE ]
  /// if want to print label please change the printer mode to label mode.
  static Future<String> getPrinterMode() async { 
    final String mode = await _channel.invokeMethod('GET_PRINTER_MODE');
    return mode;
  }

  static Future<void> printText(String text) async {
    Map<String, dynamic> arguments = <String, dynamic>{"text": text};
    await _channel.invokeMethod("PRINT_TEXT", arguments);
  }

  static Future<void> lineWrap(int lines) async {
    Map<String, dynamic> arguments = <String, dynamic>{"lines": lines};
    await _channel.invokeMethod("LINE_WRAP", arguments);
  }

  /// 0 align left, 1 center, 2 align right.
  static Future<void> setAlignment(int alignment) async {
    Map<String, dynamic> arguments = <String, dynamic>{"alignment": alignment};
    await _channel.invokeMethod("SET_ALIGNMENT", arguments);
  }

  static Future<void> setFontSize(double fontSize) async {
    Map<String, dynamic> arguments = <String, dynamic>{"fontSize": fontSize};
    await _channel.invokeMethod("SET_FONT_SIZE", arguments);
  }

  static Future<void> setFontBold(bool fontBold) async {
    Map<String, dynamic> arguments = <String, dynamic>{"fontBold": fontBold};
    await _channel.invokeMethod("SET_FONT_BOLD", arguments);
  }

  static Future<void> printColumn(List<String> stringColumns, List<Int32List> columnWidth, List<Int32List> columnAlignment) async {
    Map<String, dynamic> arguments = <String, dynamic>{
      "stringColumns": stringColumns,
      "columnWidth": columnWidth,
      "columnAlignment": columnAlignment,
    };
    await _channel.invokeMethod("PRINT_COLUMN", arguments);
  }

  /// uint8List format image
  static Future<void> printImage(Uint8List img ) async {
    Map<String, dynamic> arguments = <String, dynamic>{};
    arguments.putIfAbsent("bitmap", () => img);
    await _channel.invokeMethod("PRINT_IMAGE", arguments);
    
  }

  /// Enter into the transaction printing mode
  static Future<void> startTransactionPrint([bool clear = false]) async {
    print('startTransactionPrint $clear');
    Map<String, dynamic> arguments = <String, dynamic>{"clearEnter": clear};
    await _channel.invokeMethod("ENTER_PRINTER_BUFFER", arguments);
  }

  /// Submit transaction printing
  static Future<void> submitTransactionPrint() async {
    await _channel.invokeMethod("COMMIT_PRINTER_BUFFER");
  }

  /// Exit the transaction printing mode
  static Future<void> exitTransactionPrint([bool clear = true]) async {
    print('exitTransactionPrint $clear');
    Map<String, dynamic> arguments = <String, dynamic>{"clearExit": clear};
    await _channel.invokeMethod("EXIT_PRINTER_BUFFER", arguments);
  }

  /// Enter into the label printing mode
  static Future<void> startLabelPrint() async {
    await _channel.invokeMethod("LABEL_LOCATE");
  }

  /// Exit into the label printing mode
  static Future<void> exitLabelPrint() async {
    await _channel.invokeMethod("LABEL_OUTPUT");
  }


}

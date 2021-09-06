class ICallback {
  void onRunResult(bool isSuccess) {
    print('onRunResult: $isSuccess');
  }

  void onReturnString(String result) {}

  void onRaiseException(int code, String msg) {}

  void onPrintResult(int code, String msg) {}

}
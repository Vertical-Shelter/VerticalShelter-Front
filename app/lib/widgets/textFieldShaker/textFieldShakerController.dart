class ShakeTextFieldController {
  void Function()? _shakeCallback;

  void bindShakeCallback(void Function() callback) {
    _shakeCallback = callback;
  }

  void shake() {
    if (_shakeCallback != null) {
      _shakeCallback!();
    }
  }
}
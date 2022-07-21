import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: SizedBox(
      height: 45,
      width: 45,
      child: CircularProgressIndicator(color: Colors.grey),
    ));
  }
}

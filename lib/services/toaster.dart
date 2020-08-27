import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class Toaster {
  static final Toaster instance = Toaster();

  void toast({
    @required final String content,
  }) {
    BotToast.showCustomText(
      toastBuilder: (final CancelFunc cancelFunc) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}

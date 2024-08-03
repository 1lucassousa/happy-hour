import 'package:flutter/material.dart';

const defaultColor = Color.fromRGBO(255, 69, 18, 1);

class BackgroundDecoration {
  static Decoration decoration() {
    return const BoxDecoration(
      color: defaultColor,
      image: DecorationImage(
        image: AssetImage('assets/logo_3.png'),
        fit: BoxFit.cover,
      ),
    );
  }
}

class ContainerDecoration {
  static Decoration decoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          defaultColor,
          defaultColor,
        ],
      ),
    );
  }

  static Decoration decorationAppBar() {
    //teste
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          defaultColor,
          defaultColor,
        ],
      ),
    );
  }
}

class Alert {
  static dialog(BuildContext context, String msg) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Alerta!"),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

class CreateMaterialColor {
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}

class LoadingIndicatorDialog {
  static final LoadingIndicatorDialog _singleton =
      LoadingIndicatorDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory LoadingIndicatorDialog() {
    return _singleton;
  }

  LoadingIndicatorDialog._internal();

  show(BuildContext context, {String? text}) {
    if (isDisplayed) {
      return;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        _context = context;
        isDisplayed = true;
        return WillPopScope(
          onWillPop: () async => true,
          child: SimpleDialog(
            backgroundColor: Colors.white,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                      child: CircularProgressIndicator(
                        color: defaultColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        text ?? "Carregando dados...",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    ).then((_) {
      isDisplayed = false; // Reset o flag ao fechar o popup
    });
  }

  dismiss() {
    if (isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}

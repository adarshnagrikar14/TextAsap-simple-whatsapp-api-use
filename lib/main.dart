// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:textasap/custom_sw.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Color _greenCustom = HexColor('128C7E');
  final Color _darkCustom = HexColor('212121');
  final Color _darkBg = HexColor('212121');
  final Color _darkAppbar = HexColor('25383c');
  final Color _darkBorder = HexColor('306754');
  final TextEditingController _addressController = TextEditingController();
  late bool _value = false;

  @override
  void initState() {
    super.initState();
    getBool();
  }

  @override
  void dispose() {
    _addressController.dispose();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _value ? _darkBg : Colors.white,
      appBar: AppBar(
        backgroundColor: !_value ? Colors.grey.shade200 : _darkAppbar,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 22.0,
                  top: 25.0,
                ),
                child: CustomSwitch(
                  value: _value,
                  textOn: '   Dark',
                  textOff: 'Light',
                  onDoubleTap: () {},
                  onTap: () async {
                    setState(() {
                      _value = !_value;
                    });
                    final prefs = await SharedPreferences.getInstance();
                    if (_value) {
                      await prefs.setBool('dark', true);
                    } else {
                      await prefs.setBool('dark', false);
                    }
                  },
                  colorOn: _darkCustom,
                  colorOff: _greenCustom,
                  iconOn: Icons.dark_mode,
                  iconOff: Icons.light_mode_outlined,
                  onChanged: (bool state) {
                    if (kDebugMode) {
                      print('turned ${(state) ? 'on' : 'off'}');
                    }
                  },
                  onSwipe: () {},
                ),
              ),
            ],
          ),
        ],
        title: Padding(
          padding: const EdgeInsets.only(top: 22.0, left: 8),
          child: Text(
            'TextAsap',
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: !_value ? Colors.black87 : Colors.white,
              ),
            ),
          ),
        ),
        toolbarHeight: 118.0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Image(
                image: AssetImage(
                  _value ? 'assets/images/light.png' : 'assets/images/dark.png',
                ),
                width: 280.0,
                height: 280.0,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 30.0),
              child: TextField(
                style: TextStyle(
                  color: _value ? Colors.white : Colors.black,
                ),
                controller: _addressController,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: "Enter your number",
                  labelStyle:
                      TextStyle(color: _value ? Colors.white : Colors.black),
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _value ? Colors.white : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      // color: Colors.green.shade900,
                      color: _darkBorder,
                      width: 1.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),

            // btn
            Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
                left: 100,
                right: 100,
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    !_value ? _greenCustom : _darkAppbar,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(
                        color: Colors.white,
                        // width: 1.0,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  launchURL(_addressController.text);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    "Message",
                    style: TextStyle(
                      fontSize: 23.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String text) async {
    if (text.length == 10) {
      if (!await launch('https://wa.me/+91$text')) throw 'Unable to Launch';
    } else {
      showToast();
    }
  }

  void showToast() {
    if (kDebugMode) {
      print('Check Number');
    }
  }

  void getBool() async {
    final prefs = await SharedPreferences.getInstance();

    final bool? repeat = prefs.getBool('dark');

    setState(() {
      if (repeat == null) {
        _value = false;
      } else {
        _value = repeat;
      }
    });
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pass_generator/generator.dart';
import 'package:pass_generator/widgets/coffebuy.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Uri _url = Uri.parse('https://www.paypal.com/paypalme/patpat9');

  @override
  void initState() {
    super.initState();
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness:
            Brightness.dark, // Dark icons for light backgrounds
        statusBarBrightness: Brightness.light, // iOS-specific
      ),
    );
  }

  Future<void> _login() async {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const GeneratorScreen(),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust padding dynamically based on screen width
    final double paddingPercentage = 0.1; // 10% of screen width for padding
    final EdgeInsets horizontalPadding = EdgeInsets.symmetric(
      horizontal: screenWidth * paddingPercentage,
    );

    final bool isSmallScreen = screenWidth < 615;

    const String assetName = 'images/pass.svg';
    final Widget svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'Password Generator App Logo',
    );

    return Container(
      color: Colors.white, // Set the background color for the app
      child: FScaffold(
        content: SingleChildScrollView(
          child: Padding(
            padding: horizontalPadding,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'SGPassword',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth > 850 ? 33 : 28,
                      letterSpacing: 4.3,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Quickly generate safe & strong passwords.',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.normal,
                      fontSize: screenWidth > 850 ? 18 : 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: isSmallScreen
                        ? screenWidth * 0.4
                        : 430, // Dynamic image size
                    width: isSmallScreen
                        ? screenWidth * 0.4
                        : 430, // Dynamic image size
                    child: svg,
                  ),
                  const SizedBox(height: 20),
                  FButton(
                    prefix: FIcon(FAssets.icons.logIn),
                    label: const Text('Access generator dum'),
                    onPress: _login,
                  ),
                  const SizedBox(height: 30),
                  ClickableLabel(
                    onTap: _launchUrl,
                    label: 'Buy me a coffee :)',
                  ),
                  const FDivider(),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

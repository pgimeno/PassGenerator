import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:toastification/toastification.dart';

enum CustomizePasswordOptions { uppercase, lowercase, numbers, symbols }

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final passwordGenerator = RandomPasswordGenerator();
  final FocusNode _focusNode = FocusNode();
  final FMultiSelectGroupController<CustomizePasswordOptions>
      _selectTileController =
      FMultiSelectGroupController<CustomizePasswordOptions>(
    values: {
      CustomizePasswordOptions.uppercase,
      CustomizePasswordOptions.lowercase,
      CustomizePasswordOptions.numbers,
      CustomizePasswordOptions.symbols,
    },
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showAlert = false;
  double passLength = 16;

  @override
  void initState() {
    super.initState();
    _selectTileController.addListener(() {
      _generatePassword();
    });
    _generatePassword();

    // Add listener to detect focus changes
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _copyToClipboard();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _selectTileController.dispose(); // Dispose of the controller
    super.dispose();
  }

  void _generatePassword() {
    final selectedOptions = _selectTileController.values;

    final letters =
        selectedOptions.contains(CustomizePasswordOptions.lowercase);
    final numbers = selectedOptions.contains(CustomizePasswordOptions.numbers);
    final uppercase =
        selectedOptions.contains(CustomizePasswordOptions.uppercase);
    final specialChar =
        selectedOptions.contains(CustomizePasswordOptions.symbols);

    String newPassword = passwordGenerator.randomPassword(
      letters: letters,
      numbers: numbers,
      uppercase: uppercase,
      specialChar: specialChar,
      passwordLength: passLength,
    );

    _passwordTextController.text = newPassword;
  }

  void _copyToClipboard() {
    final password = _passwordTextController.text;
    Clipboard.setData(ClipboardData(text: password));

    // TOAST NOTIFICATION
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: const Text("Yay!"),
      description: const Text("Password copied to clipboard."),
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      primaryColor: const Color.fromARGB(255, 0, 131, 11),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      closeButtonShowType: CloseButtonShowType.none,
      closeOnClick: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final bool isSmallScreen = screenWidth < 801;

        final String assetName = 'images/gen.svg';

        final Widget svg = SvgPicture.asset(
          assetName,
          semanticsLabel: 'Password Generator App Logo',
          width: isSmallScreen ? screenWidth * 0.3 : 215,
          height: isSmallScreen ? screenWidth * 0.3 : 215,
        );

        return FScaffold(
          content: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  if (!isSmallScreen)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FTextField(
                                    label: const Text(
                                      'Generate your password',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                    focusNode: _focusNode,
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    controller: _passwordTextController,
                                  ),
                                  const SizedBox(height: 5),
                                  if (showAlert)
                                    FAlert(
                                      icon: FIcon(FAssets.icons.smilePlus),
                                      title: const Text('Nuh uh!'),
                                      subtitle: const Text(
                                          'Minimum length for a password should be 8 characters long!'),
                                    ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      FButton.icon(
                                        onPress: () {
                                          setState(() {
                                            if (passLength == 8) {
                                              showAlert = true;
                                            } else {
                                              passLength--;
                                              showAlert = false;
                                            }
                                            _generatePassword();
                                          });
                                        },
                                        child: FIcon(FAssets.icons.minus),
                                      ),
                                      const SizedBox(width: 10),
                                      FButton.icon(
                                        onPress: () {
                                          setState(() {
                                            if (passLength < 32) {
                                              showAlert = false;
                                              passLength++;
                                            }
                                            _generatePassword();
                                          });
                                        },
                                        child: FIcon(FAssets.icons.plus),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  FSelectTileGroup<CustomizePasswordOptions>(
                                    controller: _selectTileController,
                                    label:
                                        const Text('Customize your password'),
                                    description: const Text(
                                        'Tick all options for a stronger password.'),
                                    validator: (values) => values?.isEmpty ??
                                            true
                                        ? 'Please select at least one character type.'
                                        : null,
                                    children: [
                                      FSelectTile(
                                        title: const Text('Uppercase'),
                                        value:
                                            CustomizePasswordOptions.uppercase,
                                      ),
                                      FSelectTile(
                                        title: const Text('Lowercase'),
                                        value:
                                            CustomizePasswordOptions.lowercase,
                                      ),
                                      FSelectTile(
                                        title: const Text('Numbers'),
                                        value: CustomizePasswordOptions.numbers,
                                      ),
                                      FSelectTile(
                                        title: const Text('Symbols'),
                                        value: CustomizePasswordOptions.symbols,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          svg, // Display image side-by-side for larger screens
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          svg, // Move image above the form for smaller screens
                          const SizedBox(height: 20),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FTextField(
                                  label: const Text(
                                    'Generate your password',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  focusNode: _focusNode,
                                  readOnly: true,
                                  textAlign: TextAlign.center,
                                  controller: _passwordTextController,
                                ),
                                const SizedBox(height: 5),
                                if (showAlert)
                                  FAlert(
                                    icon: FIcon(FAssets.icons.smilePlus),
                                    title: const Text('Nuh uh!'),
                                    subtitle: const Text(
                                        'Minimum length for a password should be 8 characters long!'),
                                  ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    FButton.icon(
                                      onPress: () {
                                        setState(() {
                                          if (passLength == 8) {
                                            showAlert = true;
                                          } else {
                                            passLength--;
                                            showAlert = false;
                                          }
                                          _generatePassword();
                                        });
                                      },
                                      child: FIcon(FAssets.icons.minus),
                                    ),
                                    const SizedBox(width: 10),
                                    FButton.icon(
                                      onPress: () {
                                        setState(() {
                                          if (passLength < 32) {
                                            showAlert = false;
                                            passLength++;
                                          }
                                          _generatePassword();
                                        });
                                      },
                                      child: FIcon(FAssets.icons.plus),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                FSelectTileGroup<CustomizePasswordOptions>(
                                  controller: _selectTileController,
                                  label: const Text('Customize your password'),
                                  description: const Text(
                                      'Tick all options for a stronger password.'),
                                  validator: (values) => values?.isEmpty ?? true
                                      ? 'Please select at least one character type.'
                                      : null,
                                  children: [
                                    FSelectTile(
                                      title: const Text('Uppercase'),
                                      value: CustomizePasswordOptions.uppercase,
                                    ),
                                    FSelectTile(
                                      title: const Text('Lowercase'),
                                      value: CustomizePasswordOptions.lowercase,
                                    ),
                                    FSelectTile(
                                      title: const Text('Numbers'),
                                      value: CustomizePasswordOptions.numbers,
                                    ),
                                    FSelectTile(
                                      title: const Text('Symbols'),
                                      value: CustomizePasswordOptions.symbols,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  const FDivider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

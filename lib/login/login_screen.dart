import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final data = StateProvider<dynamic>((ref) => {});
  final isLoading = StateProvider<bool>((ref) => false);
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).highlightColor,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/map.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              height: 40,
                              child: Image.asset('assets/images/logo_lg.png')),
                        ),
                      ),
                      const ListTile(
                        title: Text(
                          'Enter details to continue',
                          // style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  // keyboardType: TextInputType.phone,
                                  // inputFormatters: [
                                  //   FilteringTextInputFormatter.digitsOnly,
                                  //   LengthLimitingTextInputFormatter(10)
                                  // ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Phone or email',
                                    // prefixIcon: Icon(Icons.phone),
                                    helperText:
                                        'The phone must start with country code. Eg. +91 1234567890',
                                  ),
                                  autofocus: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter a phone or email';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) {
                                    // This function will be called when the user submits the field (presses Enter)
                                    _submitForm(ref, context);
                                  },
                                  onChanged: (value) {
                                    ref.read(data.notifier).state = {
                                      'phone': value
                                    };
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 120,
                                    height: 40,
                                    child: FilledButton.icon(
                                      onPressed: ref.watch(isLoading)
                                          ? null
                                          : () => _submitForm(ref, context),
                                      icon: ref.watch(isLoading)
                                          ? const SizedBox(
                                              height: 12,
                                              width: 12,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.0,
                                              ),
                                            )
                                          : Container(),
                                      label: const Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
              sigmaX: 10.0, sigmaY: 10.0), // Adjust blur values as needed
          child: const BottomAppBar(
            padding: EdgeInsetsDirectional.zero,
            shape: CircularNotchedRectangle(),
            elevation: 0,
            height: 40,
            surfaceTintColor: Colors.transparent,
            color: ui.Color.fromARGB(255, 0, 0, 0),
            child: Center(
              child: Text(
                'Darya Shipping © 2024. All rights reserved.',
                style: TextStyle(
                  fontSize: 15,
                  color: ui.Color.fromARGB(255, 107, 182, 226),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(WidgetRef ref, context) async {
    if (_formKey.currentState!.validate()) {
      ref.read(isLoading.notifier).state = true;
      String input = ref.read(data)['phone'];

      if (RegExp(r'^\+(?:[0-9] ?){6,14}[0-9]$').hasMatch(input)) {
        if (kIsWeb) {
          // !!! Works only on web !!!
          _auth
              .signInWithPhoneNumber('${ref.read(data)['phone']}')
              .then((ConfirmationResult result) {
            ref.read(isLoading.notifier).state = false;
            GoRouter.of(context).go(
                '/login/${ref.read(data)['phone']}/${result.verificationId}');
          }).catchError((error) {
            ref.read(isLoading.notifier).state = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('The provided phone number is not valid.'),
              ),
            );
            if (kDebugMode) {
              print('Error occurred: $error');
            }
          });
        } else {
          await _auth.verifyPhoneNumber(
            phoneNumber: '${ref.read(data)['phone']}',
            verificationCompleted: (PhoneAuthCredential credential) {
              _auth.signInWithCredential(credential);
              ref.read(isLoading.notifier).state = false;
              GoRouter.of(context).go('/');
            },
            verificationFailed: (FirebaseAuthException e) {
              ref.read(isLoading.notifier).state = false;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('The provided phone number is not valid.'),
                ),
              );
            },
            codeSent: (String verificationId, int? resendToken) {
              ref.read(isLoading.notifier).state = false;
              GoRouter.of(context)
                  .go('/login/${ref.read(data)['phone']}/$verificationId');
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              ref.read(isLoading.notifier).state = false;
              GoRouter.of(context)
                  .go('/login/${ref.read(data)['phone']}/$verificationId');
            },
          );
        }
      } else {
        GoRouter.of(context).go('/login/$input@daryashipping.in/email');
      }
    }
  }
}

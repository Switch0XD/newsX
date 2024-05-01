import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';

class VerifyScreen extends ConsumerWidget {
  VerifyScreen({super.key, required this.phone, required this.verificationId});
  final String? phone;
  final String? verificationId;
  final isLoading = StateProvider<bool>((ref) => false);

  final _formKey = GlobalKey<FormState>();
  final data = StateProvider<dynamic>((ref) => {});

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(),
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
                margin: const EdgeInsets.all(0),
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ActionChip(
                              label: Text('$phone'),
                              onPressed: () {
                                context.pop();
                              }),
                        ),
                      ),
                      ListTile(
                        title: verificationId != 'email'
                            ? const Text(
                                'Enter OTP code sent to your phone',
                              )
                            : const Text(
                                'Enter your password',
                              ),
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
                                  //   LengthLimitingTextInputFormatter(6)
                                  // ],
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText:
                                        phone == 'email' ? 'OTP' : 'Password',
                                    // prefixIcon: const Icon(Icons.password_outlined),
                                  ),
                                  autofocus: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return phone == 'email'
                                          ? 'Enter an OTP code'
                                          : 'Enter a password';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) {
                                    // This function will be called when the user submits the field (presses Enter)
                                    _submitForm(ref, context);
                                  },
                                  onChanged: (value) {
                                    ref.read(data.notifier).state = {
                                      'otp': value
                                    };
                                  },
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: ref.watch(isLoading)
                              //       ? const SizedBox(
                              //           height: 16.0,
                              //           width: 16.0,
                              //           child: CircularProgressIndicator(
                              //             strokeWidth: 2.0,
                              //           ))
                              //       : FilledButton(
                              //           onPressed: () {
                              //             _submitForm(ref, context);
                              //           },
                              //           child: const Text('Verify'),
                              //         ),
                              // ),
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
                                        'Next',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0),
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
    );
  }

  void _submitForm(WidgetRef ref, context) async {
    if (_formKey.currentState!.validate()) {
      ref.read(isLoading.notifier).state = true;

      if (verificationId != 'email') {
        try {
          _auth
              .signInWithCredential(
            PhoneAuthProvider.credential(
                verificationId: verificationId!,
                smsCode: ref.read(data)['otp']),
          )
              .then(
            (value) {
              ref.read(isLoading.notifier).state = false;
              GoRouter.of(context).go('/');
            },
          );
        } catch (e) {
          ref.read(isLoading.notifier).state = false;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Incorrect OTP code'),
            ),
          );
          return;
        }
      } else {
        // try {
        _auth
            .signInWithEmailAndPassword(
                email: phone!, password: ref.read(data)['otp'])
            .then(
          (value) {
            ref.read(isLoading.notifier).state = false;
            GoRouter.of(context).go('/');
            // ref.read(selectedCompanyProvider.notifier).state = {};
            // ref.read(selectedVesselProvider.notifier).state = '';
          },
          onError: (e) {
            ref.read(isLoading.notifier).state = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Enter a correct password $e'),
              ),
            );
          },
        );
        // } catch (e) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       behavior: SnackBarBehavior.floating,
        //       content: Text('Enter a correct password'),
        //     ),
        //   );
        //   return;
        // }
      }
    }
  }
}

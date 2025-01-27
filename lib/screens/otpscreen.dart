import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bandhanmitra/mainwrapper.dart';
import '../user_registration.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OTPScreen({
    Key? key,
    required this.verificationId,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;

  void _verifyOTP() async {
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length == 6) {
      setState(() {
        _isLoading = true;
      });
      try {
        // Create PhoneAuthCredential with the provided OTP
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: otp,
        );

        // Sign in using the credential
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Check if the user exists in Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .get();

        if (userDoc.exists) {
          // User exists, navigate to Mainwrapper
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Mainwrapper()),
          );
        } else {
          // User does not exist, navigate to UserRegistrationScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserRegistrationScreen(
                phoneNumber: widget.phoneNumber,
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/images/logo2.png',
                      width: 250,
                      height: 160,
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/images/login.png',
                      width: 350,
                      height: 280,
                    ),
                  ],
                ),
                Card(
                  elevation: 16,
                  shadowColor: Colors.black,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'OTP Verification',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Enter the OTP sent to ${widget.phoneNumber}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(6, (index) {
                            return SizedBox(
                              width: 50,
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    if (index < 5) {
                                      FocusScope.of(context)
                                          .requestFocus(_focusNodes[index + 1]);
                                    } else {
                                      FocusScope.of(context).unfocus();
                                    }
                                  } else if (value.isEmpty && index > 0) {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNodes[index - 1]);
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't receive the OTP? ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Add resend functionality here if needed
                              },
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _verifyOTP,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(320, 54),
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: const Color(0xffFC4E37),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                            color: Colors.black,
                          )
                              : const Text(
                            'Verify OTP',
                            style: TextStyle(
                                color: Colors.black, fontSize: 16),
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
    );
  }
}

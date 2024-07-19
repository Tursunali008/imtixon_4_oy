
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imtixon_4_oy/services/users_services.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final userFirebaseServices = UserFirebaseServices();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final passwordTextController2 = TextEditingController();
  final nameTextController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void submit() {
    if (formKey.currentState!.validate()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      )
          .then(
        (_) async {
          await userFirebaseServices.addUser(nameTextController.text).then(
            (value) {
              Navigator.pop(context);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff8582e5),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: "worksans"),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "name@gmail.com",
                        labelStyle: const TextStyle(color: Colors.white),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input Email";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: "worksans"),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: nameTextController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Ism",
                        labelStyle: const TextStyle(color: Colors.white),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input Name";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: "worksans"),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordTextController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "12345678",
                        labelStyle: const TextStyle(color: Colors.white),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input Password";
                        }
                        if (value.length < 6) {
                          return "Password min 6";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Repeat password",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontFamily: "worksans"),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: passwordTextController2,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "12345678",
                        labelStyle: const TextStyle(color: Colors.white),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 1.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Input Password";
                        }
                        if (value.length < 6) {
                          return "Password min 6";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ZoomTapAnimation(
                  onTap: () {
                    submit();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(99, 5, 8, 69),
                    ),
                    child: const Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
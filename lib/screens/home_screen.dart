import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool isLoginFormVisible = true;
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  late List<String> textList;
  late List<bool> isSelected;
  GlobalKey<FormState>? formGlobalKey;

  @override
  void initState() {
    textList = ["Login", "SignUp"];
    isSelected = [true, false];
    formGlobalKey = GlobalKey<FormState>();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02a69b),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height:
                    MediaQuery.of(context).padding.top + kToolbarHeight * 1.3,
              ),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Login or Create a new \naccount to continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: kToolbarHeight,
              ),
              GestureDetector(
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(animation.value / 180 * math.pi),
                  alignment: Alignment.center,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..rotateY(animation.value == 0 ? 0 : 3 * math.pi),
                    alignment: Alignment.center,
                    child: isLoginFormVisible
                        ? loginForm(context)
                        : signupForm(context),
                  ),
                ),
              ),
              const SizedBox(
                height: kToolbarHeight,
              ),
              toggleButton(context),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox toggleButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.77,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Stack(
              children: [
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.467,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border:
                          Border.all(color: const Color(0xFF55C0F2), width: 1)),
                ),
                Positioned(
                  left: 0.1,
                  child: Row(
                    children: List<Widget>.generate(
                      textList.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            controller.reset();
                            final double start = isLoginFormVisible ? 0 : 180;
                            final double end = isLoginFormVisible ? 180 : 0;
                            log("start :: $start");
                            log("end :: $end");

                            animation = Tween<double>(begin: start, end: end)
                                .animate(controller)
                              ..addListener(() {
                                setState(() {});
                              });

                            controller.forward();
                            setState(() {
                              if (index == 0) {
                                isSelected[0] = true;
                                isSelected[1] = false;
                                isLoginFormVisible = true;
                              } else {
                                isSelected[0] = false;
                                isSelected[1] = true;
                                isLoginFormVisible = false;
                              }
                            });
                          },
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.467 / 2,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              color: isSelected[index]
                                  ? const Color(0xFF46a198).withOpacity(0.3)
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                textList[index],
                                style: isSelected[index]
                                    ? const TextStyle(
                                        color: Color(0xFF46a198),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)
                                    : const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Form signupForm(BuildContext context) {
    return Form(
      key: formGlobalKey,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Don't have account?",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF46a198),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Create a new account",
              style: TextStyle(
                fontSize: 18,
                color: const Color(0xFF46a198).withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF46a198).withOpacity(0.4),
                  child: const Icon(
                    Icons.ac_unit_rounded,
                    color: Color(0xFF46a198),
                    size: 36,
                  ),
                ),
              ),
            ),
            CommonTextField(
              controller: signupEmailController,
              hintText: "Email...",
            ),
            const SizedBox(height: 20),
            CommonTextField(
              controller: signupPasswordController,
              hintText: "Password...",
            ),
            const SizedBox(height: 30),
            _button(context, "Create a new account", () {
              if (formGlobalKey!.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Account Created"),
                    duration: Duration(milliseconds: 900),
                  ),
                );
                setState(() {
                  isLoginFormVisible = true;
                  signupEmailController.clear();
                  signupPasswordController.clear();
                });
              }
            }),
          ],
        ),
      ),
    );
  }

  Form loginForm(BuildContext context) {
    return Form(
      key: formGlobalKey,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Magic Cloud",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF46a198),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Welcome Back,",
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color(0xFF46a198).withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF46a198).withOpacity(0.4),
                  child: const Icon(
                    Icons.account_tree_outlined,
                    color: Color(0xFF46a198),
                    size: 36,
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            CommonTextField(
              controller: loginEmailController,
              hintText: "Email...",
            ),
            const SizedBox(height: 20),
            CommonTextField(
              controller: loginPasswordController,
              hintText: "Password...",
            ),
            const SizedBox(height: 30),
            _button(context, "Login", () {
              if (formGlobalKey!.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logged In...."),
                    duration: Duration(milliseconds: 900),
                  ),
                );
                setState(() {
                  loginEmailController.clear();
                  loginPasswordController.clear();
                  isLoginFormVisible = false;
                });
              }
            }),
            const SizedBox(height: 20),
            const SizedBox(
              width: double.infinity,
              child: Text(
                "ForgetPassword?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF46a198)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _button(BuildContext context, String label, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFF02a69b)),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),
    );
  }
}

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const CommonTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          hintText: hintText,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade500,
              fontSize: 16),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700))),
      validator: (value) {
        if (value!.isEmpty) {
          return "*Required";
        } else {
          return null;
        }
      },
    );
  }
}

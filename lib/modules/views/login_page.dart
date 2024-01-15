import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/login_model.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});
  static const String routeName = '/login';
  final _formKey = GlobalKey<FormBuilderState>();

  // inputan
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  State<LoginPage> createState() => _LoginView();
}

class _LoginView extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffEEF1F3),
        body: Column(
          children: [
            SizedBox(
                width: double.infinity,
                height: size.height * 0.3,
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Logo_SMK.png',
                                width: 75,
                                height: 75,
                              ),
                              Image.asset(
                                'assets/images/RPL.png',
                                width: 75,
                                height: 75,
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Text(
                              "Presensi PKL SMKN 1 Mejayan",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ))),
            Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 5),
                    child: FormBuilder(
                      key: widget._formKey,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 25),
                            child: const Text(
                              "Login Guru",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NotoSerif',
                              ),
                            ),
                          ),
                          FormBuilderTextField(
                            name: "username",
                            decoration: const InputDecoration(labelText: "Nama/Email"),
                            controller: widget.usernameController,
                            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                          ),
                          FormBuilderTextField(
                            name: 'password',
                            decoration: const InputDecoration(labelText: "Password"),
                            controller: widget.passwordController,
                            obscureText: true,
                            validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              color: const Color(0xff233743),
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(vertical: 16), // Sesuaikan dengan kebutuhan
                                ),
                              ),
                              onPressed: () async {
                                if (widget._formKey.currentState?.saveAndValidate() ?? false) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: const Text('Processing Data'),
                                    backgroundColor: Colors.green.shade300,
                                  ));
                                  var response = await LoginModel.sendPost(
                                      widget.usernameController.text, widget.passwordController.text);
                                  if (response['success']) {
                                    if (context.mounted) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomePage()),
                                        (route) => false,
                                      );
                                    }
                                  } else {
                                    if (context.mounted) {
                                      ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                          type: ArtSweetAlertType.danger,
                                          title: "Gagal!",
                                          text: response['message'],
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: size.width * 0.50,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () => {
                                launchUrl(Uri.parse("${dotenv.get('APP_URL')}/guru/password/reset"))
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Lupa password?',
                                  style: TextStyle(
                                    color: Color(0xff939393),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

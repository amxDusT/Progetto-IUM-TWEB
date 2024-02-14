import 'package:flutter/material.dart';
import 'package:flutter_progetto/controllers/login_controller.dart';
import 'package:flutter_progetto/resources/lang.dart';
import 'package:flutter_progetto/utils/utils.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginController _loginController = Get.put(LoginController());
  final _key = GlobalKey<FormState>();

  void validateAndSave() {
    final state = _key.currentState;
    if (state != null && state.validate()) {
      state.save();
      _loginController.loginUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
          width: double.infinity,
          child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: _key,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => changeLanguageDialog(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            Lang.currentLanguage.toLowerCase().tr,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.arrow_drop_down,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "TeachMeNow",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.inversePrimary),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    autofillHints: const [
                      AutofillHints.username,
                      AutofillHints.email
                    ],
                    controller: _loginController.userController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: Divider.createBorderSide(context)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      filled: true,
                      labelText: 'Email',
                      //hintText: 'username o email',
                    ),
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Obx(
                    () => TextFormField(
                      autofillHints: const [AutofillHints.password],
                      controller: _loginController.pwController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: Divider.createBorderSide(context)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        filled: true,
                        labelText: 'Password',
                        suffixIcon: IconButton(
                            onPressed: () =>
                                _loginController.switchPasswordVisible(),
                            icon: Icon(_loginController.isPasswordVisible.isTrue
                                ? Icons.visibility_off
                                : Icons.visibility)),
                      ),
                      obscureText: _loginController.isPasswordVisible.isFalse,
                      keyboardType: TextInputType.text,
                      validator: (input) {
                        if (input != null && input.length < 3) {
                          return 'password_length_error'.tr;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: Obx(
                            () => Checkbox(
                              value: _loginController.isRemember.value,
                              activeColor: Colors.blue,
                              onChanged: (val) =>
                                  _loginController.changeRemember(val ?? false),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(child: Text('remember_me'.tr)),
                      Text(
                        'forgot_password'.tr,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Obx(
                    () => InkWell(
                      onTap: validateAndSave,
                      splashColor: Colors.white30,
                      child: Ink(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical:
                                _loginController.isLoading.value ? 10 : 12),
                        decoration: const ShapeDecoration(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            )),
                        child: Align(
                          alignment: Alignment.center,
                          child: _loginController.isLoading.value
                              ? SizedBox(
                                  height: 19,
                                  width: 19,
                                  child: CircularProgressIndicator(
                                    color: Get.theme.colorScheme.inversePrimary,
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text('Login',
                                  style: TextStyle(
                                      //fontSize: 18,
                                      fontWeight: FontWeight.w400)),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('not_have_account'.tr),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            'register'.tr,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

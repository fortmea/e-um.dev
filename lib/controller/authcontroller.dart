import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:eum.dev/constant/regex.dart';
import 'package:eum.dev/model/uimessage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  var isLoading = false.obs;
  var isLoginFormValid = false.obs;
  var isRegisterFormValid = false.obs;
  var user = Rxn<User>();
  var message = Rxn<UiMessage>();
  final enableSendResetButton = false.obs;
  bool isLoggedIn() => user.value?.id != null;
  @override
  void onInit() {
    super.onInit();
    user.value = supabase.auth.currentUser;
    supabase.auth.onAuthStateChange.listen((event) {
      user.value = event.session?.user;
    });
    autoCleanMessage();
  }

  void autoCleanMessage() {
    message.listen(
      (p0) {
        Future.delayed(const Duration(seconds: 2)).then(
          (value) {
            isLoginFormValid.value = false;
            isRegisterFormValid.value = false;
            message.value = null;
          },
        );
      },
    );
  }

  String? validateEmail(String? email, {bool changeState = false}) {
    final regex = RegExp(emailRegex);
    final matches = regex.allMatches(email ?? "");
    if (!matches.isNotEmpty) {
      if (changeState) {
        enableSendResetButton.value = false;
      }
      return 'enter-valid-email'.i18n();
    }
    if (changeState) {
      enableSendResetButton.value = true;
    }

    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 8) return "password-short".i18n();

    return null;
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        message.value = UiMessage(
            title: "error".i18n(),
            message: "unk-error-register".i18n(),
            error: true);
      }

      message.value = UiMessage(
        title: "success".i18n(),
        message: "verify-email".i18n(),
      );
    } catch (e) {
      message.value = UiMessage(
          title: "error".i18n(),
          message: "unk-error-register".i18n(),
          error: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        message.value = UiMessage(
            title: "error".i18n(),
            message: "unk-error-login".i18n(),
            error: true);
      }

      message.value = UiMessage(
        title: "success".i18n(),
        message: "success-login-message".i18n(),
      );
    } catch (e) {
      message.value = UiMessage(
          title: "error".i18n(),
          message: "unk-error-login".i18n(),
          error: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await supabase.auth.signOut();
      message.value = UiMessage(
        title: "success".i18n(),
        message: "success-logout-message".i18n(),
      );
    } catch (e) {
      message.value = UiMessage(
          title: "error".i18n(),
          message: "unk-error-logout".i18n(),
          error: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await supabase.auth.resetPasswordForEmail(email);

      message.value = UiMessage(
        title: "success".i18n(),
        message: "verify-email".i18n(),
      );
    } catch (e) {
      message.value = UiMessage(
          title: "error".i18n(),
          message: "unk-error-forgot-password".i18n(),
          error: true);
    } finally {
      isLoading.value = false;
    }
  }

  authEventSubscriber(
      Function(AuthChangeEvent event, Session? session) eventHandler) {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      eventHandler(event, session);
    });
  }
}

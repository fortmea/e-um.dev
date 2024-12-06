import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:mercury/model/uimessage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  
  final SupabaseClient _supabase = Supabase.instance.client;

  var isLoading = false.obs;
  var user = Rxn<User>();
  var message = Rxn<UiMessage>();
  @override
  void onInit() {
    super.onInit();
    user.value = _supabase.auth.currentUser;
    _supabase.auth.onAuthStateChange.listen((event) {
      user.value = event.session?.user;
    });
  }

  Future<void> signUp(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Erro ao registrar o usuário.');
      }

      message.value = UiMessage(
        title: "Sucesso!",
        message: "Verifique seu email para concluir.",
      );
    } catch (e) {
      message.value =
          UiMessage(title: "Erro!", message: e.toString(), error: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session == null) {
        throw Exception('Erro ao fazer login.');
      }

      message.value = UiMessage(
        title: "Sucesso!",
        message: "Login realizado.",
      );
    } catch (e) {
      message.value =
          UiMessage(title: "Erro!", message: e.toString(), error: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _supabase.auth.signOut();
      message.value = UiMessage(
        title: "Sucesso!",
        message: "Você será desconectado",
      );
    } catch (e) {
      message.value =
          UiMessage(title: "Erro!", message: e.toString(), error: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Método para verificar o estado da sessão
  bool isLoggedIn() => user.value != null;

  // Método para resetar senha
  Future<void> resetPassword(String email) async {
    try {
      isLoading.value = true;
      await _supabase.auth.resetPasswordForEmail(email);

      message.value = UiMessage(
        title: "Sucesso!",
        message: "Verifique seu email para continuar.",
      );
    } catch (e) {
      message.value =
          UiMessage(title: "Erro!", message: e.toString(), error: true);
    } finally {
      isLoading.value = false;
    }
  }
}

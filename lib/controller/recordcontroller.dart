import 'package:eum.dev/constant/nametypes.dart';
import 'package:eum.dev/constant/regex.dart';
import 'package:eum.dev/controller/countercontroller.dart';
import 'package:eum.dev/controller/overlaycontroller.dart';
import 'package:eum.dev/model/record.dart';
import 'package:eum.dev/model/uimessage.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecordController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;
  final OverlayController overlayController = Get.find();
  late CounterController counterController;
  var isLoading = false.obs;
  var isFormValid = false.obs;
  var domainCount = 0.obs;
  var domainLimit = 0.obs;
  var requestStatus = 0.obs;
  var servedDomains = 0.obs;
  RxList<DNSRecord> domainsList = List<DNSRecord>.empty().obs;

  var message = Rxn<UiMessage>();
  final subdomainController = TextEditingController(),
      targetController = TextEditingController(),
      selectorController = FRadioSelectGroupController(value: Nametypes.CNAME);

  @override
  void onInit() {
    super.onInit();
    autoCleanMessage();
    if (supabase.auth.currentUser != null) {
      getDomainCount();
      getDomainLimit();
      getDomains();
      subscribe();
      getDomainCount();
    }
    getServedDomainsCount();
  }

  void autoCleanMessage() {
    message.listen(
      (p0) {
        Future.delayed(const Duration(seconds: 10)).then(
          (value) {
            isFormValid.value = false;
            message.value = null;
          },
        );
      },
    );
  }

  void getDomainLimit() {
    supabase
        .from('secrets')
        .select("value")
        .eq("name", "limit")
        .limit(1)
        .then((value) {
      domainLimit.value = int.parse(value.single["value"]);
    });
  }

  void subscribe() {
    supabase
        .channel('schema-db-changes')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            callback: (payload) {
              overlayController.toggleOverlay();
              getDomains();
              getDomainCount();
              overlayController.toggleOverlay();
            },
            table: 'records',
            schema: 'public')
        .subscribe();
  }

  void getDomains() {
    List<DNSRecord> list = [];
    supabase
        .from('records')
        .select("*")
        .eq("owner", supabase.auth.currentUser?.id ?? "")
        .then((value) {
      for (var value in value) {
        final record = DNSRecord.fromJson(value);
        list.add(record);
      }
      domainsList.value = list;
    });
  }

  void getDomainCount() {
    supabase
        .from('records')
        .select("owner")
        .eq("owner", supabase.auth.currentUser?.id ?? "")
        .count(CountOption.exact)
        .then((value) {
      domainCount.value = value.count;
    });
  }

  void registerDomain() {
    supabase.functions
        .invoke('create-sub-domain',
            body: {
              'sub': subdomainController.text.trim(),
              'pointsTo': targetController.text.trim(),
              'token': supabase.auth.currentSession?.refreshToken,
              'type': selectorController.values.first == Nametypes.CNAME ? 1 : 2
            },
            headers: {
              'Authorization':
                  'Bearer ${supabase.auth.currentSession?.accessToken}'
            },
            method: HttpMethod.post)
        .then((_) {
      subdomainController.clear();
      targetController.clear();
    }).onError((error, stackTrace) {
      message.value = UiMessage(
          title: "error".i18n(),
          message: "error-registering".i18n(),
          error: true);
    });
  }

  void deleteDomain(DNSRecord domain) {
    supabase.functions
        .invoke('create-sub-domain',
            body: {
              'token': supabase.auth.currentSession?.refreshToken,
              'cloudflareId': domain.cloudflareId
            },
            headers: {
              'Authorization':
                  'Bearer ${supabase.auth.currentSession?.accessToken}'
            },
            method: HttpMethod.delete)
        .then((val) {
      requestStatus.value = val.status;
    }).onError((error, stackTrace) {
      message.value = UiMessage(
          title: "error".i18n(), message: "error-deleting".i18n(), error: true);
    });
  }

  String? validateSubdomain(String subdomain) {
    if (subdomain != "") {
      return subdomainRegExp.stringMatch(subdomain) == subdomain
          ? null
          : "invalid-subdomain".i18n([subdomain]);
    }
    return null;
  }

  String? validateTarget(String target) {
    if (target != "") {
      if (selectorController.values.first == Nametypes.CNAME) {
        if (pointsToRegExp.stringMatch(target) == target) {
          return null;
        } else {
          return "cname-invalid".i18n();
        }
      } else if (selectorController.values.first == Nametypes.A) {
        if (ipAddressRegExp.stringMatch(target) == target) {
          return null;
        } else {
          return "ip-invalid".i18n();
        }
      }
    }
    return null;
  }

  void getServedDomainsCount() {
    supabase.from("stats").select("value").eq("name", "count").then((value) {
      servedDomains.value = value.single["value"];
    });
  }

  void initializeCounter(TickerProvider vsync, int targetNumber) {
    counterController = CounterController(
      vsync: vsync,
      targetNumber: targetNumber,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutExpo,
    );
  }

  @override
  void onClose() {
    counterController.dispose();
    super.onClose();
  }
}

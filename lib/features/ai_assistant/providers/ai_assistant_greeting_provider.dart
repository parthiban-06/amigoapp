import 'package:provider/provider.dart';
import 'package:visaamigo/features/ai_assistant/repo/ai_assistant_repo.dart';
import 'package:visaamigo/features/home/providers/navigation_provider.dart';
import 'package:visaamigo/features/profile/provider/user_generic_detail_provider.dart';
import 'package:visaamigo/features/signup/model/user_model.dart';
import 'package:visaamigo/router/app_routes_const.dart';
import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/shared_preferences.dart';
import 'package:visaamigo/utils/utils.dart';

class AiAssistantGreetingProvider extends BaseProvider {
  UserModel? userModel;
  AiAssistantRepo? aiAssistantRepo;
  String? evaIntroNode;
  bool? isLoadingData = true;

  Future<void> init(NavigationProvider navigationProvider) async {
    userModel = await Preferences.getModelData(
        Preferences.KeyUserModel, UserModel.fromJson);
    // await getGreetingScreenData();

    // Capture context before async operations
    final context = mContext;
    if (!context.mounted) return;

    evaIntroNode =
        Provider.of<UserGenericProvider>(context, listen: false).evaIntroNode;
    Utils.logPrint("evaIntroNode:********** $evaIntroNode");
    isLoading = false;
    if (evaIntroNode == "true") {
      Future.delayed(const Duration(seconds: 3)).then((_) async {
        if (!context.mounted) return;
        onNavigateEva(navigationProvider);
      });
    }
  }

  onNavigateEva(navigationProvider) {
    Preferences.setBool(Preferences.isWelcomeScreenSet, true);
    navPop();
    navigationProvider.goBranch(AppRoutes.evaScreenIndex,
        loadInitial: true, showGreetingScreen: false);
  }

  Future<void> getGreetingScreenData() async {
    aiAssistantRepo = AiAssistantRepo(apiClient);

    final response =
        await aiAssistantRepo?.getGreetingScreenData((json) => json);

    // Capture context before async operations
    final context = mContext;
    if (!context.mounted) return;

    if (response != null && response.isSuccess) {
      if (response.data != null &&
          response.data!['data']['personalization'] != null &&
          response.data!['data']['personalization'].isNotEmpty) {
        evaIntroNode =
            response.data!['data']['personalization']['eva_intro_node'][0];
      } else {
        evaIntroNode = "";
      }
      Provider.of<UserGenericProvider>(context, listen: false).setEvaIntroNode =
          evaIntroNode;
    }
    isLoadingData = false;
    //isLoading = false;
    setState();
  }

  Future<void> changeGreetingScreenData() async {
    aiAssistantRepo = AiAssistantRepo(apiClient);
    final requestBody = {
      "preferences": {
        "eva_intro_node": ["true"]
      }
    };

    // Capture context before async operations
    final context = mContext;

    try {
      final response = await aiAssistantRepo?.patchGreetingScreenData(
          requestBody, (json) => (json));
      Utils.logPrint("Response: $response");
      if (response != null && response.isSuccess && context.mounted) {
        Provider.of<UserGenericProvider>(context, listen: false)
            .updateEvaIntroNode("true");
      }
    } catch (e) {
      Utils.logPrint("response patchGreetingScreenData error $e");
    }
  }
}

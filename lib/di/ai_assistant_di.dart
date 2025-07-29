import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_common_steps_provider.dart'
    show AiAssistantCommonStepsProvider;
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_greeting_provider.dart'
    show AiAssistantGreetingProvider;
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_threads_screen_provider.dart'
    show AiAssistantThreadsScreenProvider;
import 'package:visaamigo/features/ai_assistant/providers/ai_assistant_welcome_screen_provider.dart'
    show AiAssistantWelcomeScreenProvider;
import 'package:visaamigo/features/ai_assistant/providers/ai_chat_provider.dart'
    show ChatProvider;
import 'package:visaamigo/features/ai_assistant/providers/ai_hisotry/ai_chat_hisotry_provider.dart'
    show AiChatHistoryProvider;
import 'package:visaamigo/features/ai_assistant/providers/ai_prompt_personal_preferences_provider.dart';
import 'package:visaamigo/features/home/providers/tutorial_provider.dart'
    show TutorialProvider;

import '../features/ai_assistant/providers/ai_assistant_prompts_screen_provider.dart';

void setupAiAssistantDependencies(GetIt getIt) {
  getIt.registerFactory(() => AiPromptPersonalPreferencesProvider());
}

// void setupAiAssistantMainProvider(GetIt getIt) {
//   getIt.registerFactory(() => AiAssistantMainProvider());
// }

void setupAiChatHistoryProvider(GetIt getIt) {
  getIt.registerFactory(() => AiChatHistoryProvider());
}

void setupChatProvider(GetIt getIt) {
  getIt.registerFactory(() => ChatProvider());
}

void setupAiAssistantWelcomeProvider(GetIt getIt) {
  getIt.registerFactory(() => AiAssistantWelcomeScreenProvider());
}

void setupAiAssistantThreadsScreenProvider(GetIt getIt) {
  getIt.registerFactory(() => AiAssistantThreadsScreenProvider());
}

void setupAiAssistantPromptsScreenProvider(GetIt getIt) {
  getIt.registerFactory(() => AiAssistantPromptsScreenProvider());
}

void setupTutorialProvider(GetIt getIt) {
  getIt.registerFactory(() => TutorialProvider());
}

void setupAiAssistantCommonStepsProvider(GetIt getIt) {
  getIt.registerFactory(() => AiAssistantCommonStepsProvider());
}

void setupAiAssistantGreetingProvider(GetIt getIt) {
  getIt.registerFactory(() => AiAssistantGreetingProvider());
}

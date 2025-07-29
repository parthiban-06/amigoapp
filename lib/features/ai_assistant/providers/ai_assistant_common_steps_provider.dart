import 'package:visaamigo/ui/base/base_provider.dart';
import 'package:visaamigo/utils/utils.dart';

class AiAssistantCommonStepsProvider extends BaseProvider {
  int currentStep = 1;
  bool isContinueClick = false;

  // Function to set Slider Value
  void setCurrentStep(int step) {
    Utils.logPrint("step step $step");
    currentStep = step;
    notifyListeners(); // Trigger UI update
  }

  // Function
  void setContinueClick(bool isClick) {
    isContinueClick = isClick;
    setState(); // Trigger UI update
  }
}

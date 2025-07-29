import '../../ui/base/base_provider.dart';

class LoadingProvider extends BaseProvider {
  bool _loading = false;

  bool get loading => _loading;

  setLoad(bool status) {
    _loading = status;
    notifyListeners();
  }
}

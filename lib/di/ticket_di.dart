import 'package:get_it/get_it.dart';
import 'package:visaamigo/features/tickets/provider/ticket_provider.dart'
    show TicketProvider;

void setupTicketsModuleDI(GetIt getIt) {
  // Register SelectLanguageProvider
  getIt.registerFactory(() => TicketProvider());
}

import 'general_event.dart';

class GeneralEventOccurrence {
  const GeneralEventOccurrence({
    required this.event,
    required this.start,
    required this.end,
  });

  final GeneralEvent event;
  final DateTime start;
  final DateTime end;
}

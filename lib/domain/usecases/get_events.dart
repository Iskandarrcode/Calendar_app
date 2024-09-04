import 'package:tudo_app/domain/entities/event.dart';
import 'package:tudo_app/domain/repositories/eventRepository.dart';

class GetEvents {
  final EventRepository repository;

  GetEvents(this.repository);

  Future<List<Event>> call() async {
    final events = await repository.getAllEvents();
    return events;
  }
}

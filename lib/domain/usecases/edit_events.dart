import 'package:tudo_app/data/models/event_model.dart';
import 'package:tudo_app/domain/repositories/eventRepository.dart';

class EditEvents {
  final EventRepository repository;

  EditEvents(this.repository);

  Future<void> call(EventModel event) async {
    return await repository.editEvent(event);
  }
}

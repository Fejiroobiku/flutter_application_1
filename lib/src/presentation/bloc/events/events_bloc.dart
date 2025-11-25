import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_event_usecase.dart';
import '../../../domain/usecases/get_events_usecase.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final CreateEventUseCase createEventUseCase;
  final GetEventsUseCase getEventsUseCase;

  EventsBloc({
    required this.createEventUseCase,
    required this.getEventsUseCase,
  }) : super(EventsInitial()) {
    on<GetEventsEvent>(_onGetEvents);
    on<CreateEventEvent>(_onCreateEvent);
  }

  Future<void> _onGetEvents(GetEventsEvent event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    try {
      final events = await getEventsUseCase();
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventsFailure(e.toString()));
    }
  }

  Future<void> _onCreateEvent(CreateEventEvent event, Emitter<EventsState> emit) async {
    emit(EventsLoading());
    try {
      await createEventUseCase(event.event);
      final events = await getEventsUseCase();
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventsFailure(e.toString()));
    }
  }
}

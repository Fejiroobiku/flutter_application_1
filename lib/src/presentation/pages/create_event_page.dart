import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event/event_bloc.dart';
import '../bloc/event/event_event.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import 'package:here_bro/constants/app_colors.dart';
import '../../domain/entities/event_entity.dart';

class CreateEventPage extends StatefulWidget {
  final String? eventId;

  const CreateEventPage({
    Key? key,
    this.eventId,
  }) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _selectedStartDate;
  late DateTime _selectedEndDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
    _selectedStartDate = DateTime.now().add(const Duration(days: 1));
    _selectedEndDate = DateTime.now().add(const Duration(days: 1, hours: 2));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.eventId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Event' : 'Create Event'),
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is EventOperationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    enabled: state is! EventLoading,
                    decoration: InputDecoration(
                      labelText: 'Event Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    enabled: state is! EventLoading,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _locationController,
                    enabled: state is! EventLoading,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Create/Update Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state is EventLoading ? null : _createEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: state is EventLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              isEditMode ? 'Update Event' : 'Create Event',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _createEvent() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated) return;

    final event = EventEntity(
      id: widget.eventId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: _selectedStartDate,
      endTime: _selectedEndDate,
      location: _locationController.text.trim(),
      organizerId: authState.user.id,
      organizerName: authState.user.name,
      attendeeIds: [authState.user.id],
      createdAt: DateTime.now(),
    );

    if (widget.eventId != null) {
      context.read<EventBloc>().add(UpdateEventRequested(event: event));
    } else {
      context.read<EventBloc>().add(CreateEventRequested(event: event));
    }
  }
}
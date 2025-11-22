import 'package:flutter/material.dart';
import '../widgets/custom_footer.dart';
import '../services/event_service.dart';
import '../constants/app_colors.dart';

class EventDetailsPage extends StatelessWidget {
  final String eventId;
  const EventDetailsPage({required this.eventId});

  @override
  Widget build(BuildContext context) {
    final eventService = EventService();
    
    return FutureBuilder(
      future: eventService.getEventById(eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Icon(Icons.event, color: AppColors.emerald600),
                  SizedBox(width: 8),
                  Text('Event Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray800)),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.gray800),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: CircularProgressIndicator(color: AppColors.emerald600),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Icon(Icons.event, color: AppColors.emerald600),
                  SizedBox(width: 8),
                  Text('Event Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray800)),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.gray800),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.gray400),
                  SizedBox(height: 16),
                  Text(
                    'Event not found',
                    style: TextStyle(fontSize: 18, color: AppColors.gray600),
                  ),
                ],
              ),
            ),
          );
        }

        final event = snapshot.data!;
        
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Icon(Icons.event, color: AppColors.emerald600),
                SizedBox(width: 8),
                Text('Event Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray800)),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.gray800),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        child: Column(
                          children: [
                            Image.network(
                              event.image, 
                              height: 200, 
                              width: double.infinity, 
                              fit: BoxFit.cover
                            ),
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          event.title, 
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray800)
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.emerald100, 
                                          borderRadius: BorderRadius.circular(16)
                                        ),
                                        child: Text(
                                          '${event.attendees} attending', 
                                          style: TextStyle(color: AppColors.emerald600, fontWeight: FontWeight.w500)
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 16, color: AppColors.gray600), 
                                      SizedBox(width: 8), 
                                      Text(
                                        '${EventService.formatDate(event.date)} • ${EventService.formatTime(event.date)}', 
                                        style: TextStyle(color: AppColors.gray600)
                                      )
                                    ]
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 16, color: AppColors.gray600), 
                                      SizedBox(width: 8), 
                                      Expanded(
                                        child: Text(
                                          event.location, 
                                          style: TextStyle(color: AppColors.gray600)
                                        )
                                      )
                                    ]
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'About This Event', 
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.gray800)
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    event.description, 
                                    style: TextStyle(color: AppColors.gray600, height: 1.6)
                                  ),
                                  SizedBox(height: 24),
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            // Add RSVP functionality
                                            eventService.addAttendee(event.id!, 'current_user_id');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('RSVP confirmed!'))
                                            );
                                          },
                                          icon: Icon(Icons.check_circle, size: 20),
                                          label: Text('RSVP Now'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.emerald600, 
                                            foregroundColor: Colors.white, 
                                            padding: EdgeInsets.symmetric(vertical: 16)
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            // Share functionality
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Share feature coming soon!'))
                                            );
                                          },
                                          icon: Icon(Icons.share, size: 20),
                                          label: Text('Share Event'),
                                          style: OutlinedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 16)
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CustomFooter(),
              ],
            ),
          ),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../pages/event_details_page.dart';
import '../constants/app_colors.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            child: Image.network(
              event.image, 
              height: 120, 
              width: double.infinity, 
              fit: BoxFit.cover
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title, 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: AppColors.gray600), 
                    SizedBox(width: 4), 
                    Expanded(
                      child: Text(
                        '${EventService.formatDate(event.date)} • ${event.time}', 
                        style: TextStyle(color: AppColors.gray600, fontSize: 12)
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: AppColors.gray600), 
                    SizedBox(width: 4), 
                    Expanded(
                      child: Text(
                        event.location, 
                        style: TextStyle(color: AppColors.gray600, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.emerald100, 
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Text(
                        '${event.attendees} attending', 
                        style: TextStyle(fontSize: 10, color: AppColors.emerald600, fontWeight: FontWeight.w500)
                      ),
                    ),
                    GestureDetector(
                      onTap: () => event.id != null ? Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => EventDetailsPage(eventId: event.id!))
                      ) : null,
                      child: Row(
                        children: [
                          Text('Details', style: TextStyle(color: AppColors.emerald600, fontWeight: FontWeight.w500, fontSize: 12)),
                          SizedBox(width: 2),
                          Icon(Icons.chevron_right, size: 14, color: AppColors.emerald600),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
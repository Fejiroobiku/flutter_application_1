import 'package:flutter/material.dart';
import '../widgets/custom_footer.dart';
import '../widgets/event_card.dart';
import '../services/event_service.dart';
import '../constants/app_colors.dart';
import 'events_page.dart';
import 'create_event_page.dart';

class HomePage extends StatelessWidget {
  final Function(int)? onNavTap;
  final _eventService = EventService();

  HomePage({this.onNavTap});

  Future<List<dynamic>> _loadAllEvents() async {
    print('🔄 HomePage: Loading all events...');
    await _eventService.initializeMockData();
    final events = await _eventService.getEvents();
    print('✅ HomePage: Loaded ${events.length} events');
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(colors: [AppColors.emerald600, AppColors.blue600]),
              ),
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), 
                  color: Colors.black.withOpacity(0.1)
                ),
                child: Column(
                  children: [
                    Text(
                      'Create & Discover Amazing Events', 
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), 
                      textAlign: TextAlign.center
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Simple event management for universities, NGOs, and community groups.', 
                      style: TextStyle(fontSize: 16, color: Colors.white), 
                      textAlign: TextAlign.center
                    ),
                    SizedBox(height: 24),
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateEventPage())), 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, 
                              foregroundColor: AppColors.emerald600, 
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                            ), 
                            child: Text('Create Event', style: TextStyle(fontWeight: FontWeight.w600))
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventsPage())), 
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white, 
                              side: BorderSide(color: Colors.white), 
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                            ), 
                            child: Text('Browse Events', style: TextStyle(fontWeight: FontWeight.w600))
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            // All Events Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder<List<dynamic>>(
                future: _loadAllEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(color: AppColors.emerald600),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700, size: 40),
                          SizedBox(height: 12),
                          Text(
                            'Failed to load events',
                            style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }

                  final events = snapshot.data ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'All Events', 
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray800)
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventsPage())),
                            child: Row(
                              children: [
                                Text('Browse All', style: TextStyle(color: AppColors.emerald600)), 
                                SizedBox(width: 4), 
                                Icon(Icons.chevron_right, size: 16, color: AppColors.emerald600)
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      events.isEmpty
                          ? Container(
                              padding: EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(Icons.event_available, size: 64, color: AppColors.gray400),
                                  SizedBox(height: 16),
                                  Text(
                                    'No events yet',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.gray600),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Create one to get started!',
                                    style: TextStyle(fontSize: 14, color: AppColors.gray500),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: events.length,
                              itemBuilder: (context, index) => EventCard(event: events[index]),
                            ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 32),
            CustomFooter(),
          ],
        ),
      ),
    );
  }
}
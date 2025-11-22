import 'package:flutter/material.dart';
import '../widgets/custom_footer.dart';
import '../widgets/stats_card.dart';
import '../constants/app_colors.dart';
import '../services/auth_service.dart';
import '../services/event_service.dart';
import '../services/local_storage_service.dart';
import 'create_event_page.dart';

class DashboardPage extends StatefulWidget {
  final Function(int)? onNavTap;

  const DashboardPage({this.onNavTap});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _authService = AuthService();
  final _eventService = EventService();
  final _storageService = LocalStorageService();

  List<dynamic> _userEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = await _authService.currentUser;
    if (currentUser != null) {
      final events = await _eventService.getEventsByOrganizer(currentUser.id);
      setState(() {
        _userEvents = events;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    await _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _authService.currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final currentUser = snapshot.data;
          
          return currentUser == null
              ? Center(
                  child: Text('Please login to view dashboard'),
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Dashboard', 
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.gray800)
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => CreateEventPage())
                                    ),
                                    icon: Icon(Icons.add, size: 20),
                                    label: Text('Create Event'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.emerald600, 
                                      foregroundColor: Colors.white, 
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),

                              // User Stats
                              _isLoading
                                  ? Container(
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(color: AppColors.emerald600),
                                      ),
                                    )
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 1.2,
                                      ),
                                      itemCount: 4,
                                      itemBuilder: (context, index) => _buildStatsCard(index),
                                    ),
                              SizedBox(height: 24),

                              // Your Events Section
                              Card(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                                        children: [
                                          Text(
                                            'Your Events', 
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.gray800)
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.refresh),
                                            onPressed: _refreshData,
                                          ),
                                        ]
                                      ),
                                      SizedBox(height: 16),
                                      _isLoading
                                          ? Center(child: CircularProgressIndicator(color: AppColors.emerald600))
                                          : _userEvents.isEmpty
                                              ? Container(
                                                  padding: EdgeInsets.all(32),
                                                  child: Column(
                                                    children: [
                                                      Icon(Icons.event_note, size: 48, color: AppColors.gray400),
                                                      SizedBox(height: 12),
                                                      Text(
                                                        'No events created yet',
                                                        style: TextStyle(color: AppColors.gray600),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Column(
                                                  children: _userEvents.map((event) => _buildEventItem(event)).toList(),
                                                ),
                                    ],
                                  ),
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
      ),
    );
  }

  Widget _buildStatsCard(int index) {
    final createdCount = _userEvents.length;
    final attendingCount = 0; // You can implement this if needed

    final stats = [
      {
        'title': 'Events Created',
        'value': createdCount.toString(),
        'subtitle': 'Total events created',
        'icon': Icons.calendar_today,
        'color': AppColors.blue600,
      },
      {
        'title': 'Attending',
        'value': attendingCount.toString(),
        'subtitle': 'Events you joined',
        'icon': Icons.check_circle,
        'color': AppColors.emerald600,
      },
      {
        'title': 'Total Attendees',
        'value': _userEvents.fold(0, (sum, event) => sum + (event.attendees as int)).toString(),
        'subtitle': 'Across all events',
        'icon': Icons.people,
        'color': AppColors.purple600,
      },
      {
        'title': 'This Month',
        'value': _userEvents.where((event) => 
          event.createdAt.month == DateTime.now().month && 
          event.createdAt.year == DateTime.now().year
        ).length.toString(),
        'subtitle': 'Events created',
        'icon': Icons.trending_up,
        'color': AppColors.yellow600,
      },
    ];
    
    if (index >= stats.length) return SizedBox();
    
    final stat = stats[index];
    return StatsCard(
      title: stat['title'] as String,
      value: stat['value'] as String,
      subtitle: stat['subtitle'] as String,
      icon: stat['icon'] as IconData,
      color: stat['color'] as Color,
    );
  }

  Widget _buildEventItem(dynamic event) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.emerald100,
                child: Icon(Icons.event, size: 16, color: AppColors.emerald600),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      event.category ?? 'Event',
                      style: TextStyle(color: AppColors.gray600, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${event.date.toString().split(' ')[0]}',
                style: TextStyle(fontSize: 12, color: AppColors.gray600),
              ),
              Text(
                '${event.attendees} attendees',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
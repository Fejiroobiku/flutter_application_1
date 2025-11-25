import 'package:flutter/material.dart';
import 'package:here_bro/constants/app_colors.dart';
import 'package:here_bro/src/domain/entities/event_entity.dart';

/// Responsive event card that adapts to screen size.
/// 
/// Sizing breakpoints:
/// - Small screens (≤ 5.5"): Compact padding, smaller font
/// - Large screens (≥ 6.7"): Spacious padding, larger font
class ResponsiveEventCard extends StatelessWidget {
  final EventEntity event;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ResponsiveEventCard({
    Key? key,
    required this.event,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth <= 400;
        final cardPadding = isSmallScreen ? 12.0 : 16.0;
        final titleFontSize = isSmallScreen ? 14.0 : 18.0;
        final bodyFontSize = isSmallScreen ? 12.0 : 14.0;
        final iconSize = isSmallScreen ? 16.0 : 20.0;

        return Card(
          margin: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 8 : 12,
            vertical: isSmallScreen ? 6 : 8,
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Actions Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          event.title,
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onEdit != null || onDelete != null)
                        SizedBox(
                          width: isSmallScreen ? 60 : 80,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onEdit != null)
                                Flexible(
                                  child: _buildActionButton(
                                    icon: Icons.edit_outlined,
                                    onPressed: onEdit!,
                                    size: iconSize,
                                  ),
                                ),
                              if (onDelete != null)
                                Flexible(
                                  child: _buildActionButton(
                                    icon: Icons.delete_outlined,
                                    onPressed: onDelete!,
                                    size: iconSize,
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  // Description
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      color: AppColors.gray600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  // Info Row
                  _buildInfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: _formatDate(event.startTime),
                    fontSize: bodyFontSize,
                    iconSize: iconSize,
                  ),
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  // Location Row
                  _buildInfoRow(
                    icon: Icons.location_on_outlined,
                    text: event.location,
                    fontSize: bodyFontSize,
                    iconSize: iconSize,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  // Attendees Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 12,
                      vertical: isSmallScreen ? 4 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.emerald50,
                      borderRadius: BorderRadius.circular(isSmallScreen ? 4 : 6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: iconSize - 2,
                          color: AppColors.emerald600,
                        ),
                        SizedBox(width: isSmallScreen ? 4 : 6),
                        Text(
                          '${event.attendeeIds.length} attendees',
                          style: TextStyle(
                            fontSize: bodyFontSize - 2,
                            color: AppColors.emerald600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build info row with icon and text.
  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required double fontSize,
    required double iconSize,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: iconSize,
          color: AppColors.gray600,
        ),
        SizedBox(width: fontSize / 3),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.gray600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Build compact action button.
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double size,
  }) {
    return SizedBox(
      width: size + 8,
      height: size + 8,
      child: IconButton(
        icon: Icon(icon),
        iconSize: size,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  /// Format date and time.
  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

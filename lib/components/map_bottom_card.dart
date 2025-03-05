import 'dart:ui';

import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';
import 'package:mesh_frontend/components/map_pull_down_button.dart';
import 'package:mesh_frontend/components/map_route_button.dart';
import 'package:mesh_frontend/grpc/gen/server.pb.dart';
import 'package:mesh_frontend/utils/format_date.dart';
import 'package:mesh_frontend/utils/googlemaps_direction.dart';

class MapBottomCard extends StatelessWidget {
  const MapBottomCard({
    super.key, 
    required this.group,
    required this.remainingTimeText,
    this.travelTime,
    this.currentLocation,
    required this.onTapExit,
    required this.onTapFocusMe,
    required this.onTapFocusRoute,
    required this.onSubmitMessage,
  });

  final ShareGroup? group;
  final String remainingTimeText;
  final TravelTime? travelTime;
  final LocationDto? currentLocation;
  final VoidCallback onTapExit;
  final VoidCallback onTapFocusMe;
  final VoidCallback onTapFocusRoute;
  final ValueChanged<String> onSubmitMessage;

  String _calculateDepartureTime(int? durationMinutes) {
    if (group == null ||
        group!.meetingTime.isEmpty ||
        durationMinutes == null) {
      return '--:--';
    }

    final meetingTime = DateTime.parse(group!.meetingTime);
    final departureTime = meetingTime.subtract(
      Duration(minutes: durationMinutes),
    );
    return '${departureTime.hour}:${departureTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    onTapFocusMe();
                  },
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: const Icon(Icons.near_me, color: Colors.orange, size: 30),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () {
                    onTapFocusRoute();
                  },
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: const Icon(Icons.route, color: Colors.orange, size: 30),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3), // 薄いグレーの枠線
                      width: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${formatDateTime(group!.meetingTime)} 集合', // ここは動的に変更可能
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            MapPullDownButton(group: group, onTapExit: onTapExit),
                          ],
                        ),
                        // 残り時間の表示
                        Row(
                          children: [
                            Text(
                              remainingTimeText,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),
                        const Text(
                          "出発目安",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            MapRouteButton(
                              by: '徒歩',
                              duration:
                                  travelTime?.walking != null
                                      ? '${travelTime?.walking}分'
                                      : '--分',
                              departureTime: _calculateDepartureTime(
                                travelTime?.walking,
                              ),
                              icon: Icons.directions_walk,
                              onTap: () {},
                              isCalculated: travelTime != null,
                            ),
                            const SizedBox(width: 8),
                            MapRouteButton(
                              by: '自転車',
                              duration:
                                  travelTime?.bicycling != null
                                      ? '${travelTime?.bicycling}分'
                                      : '--分',
                              departureTime: _calculateDepartureTime(
                                travelTime?.bicycling,
                              ),
                              icon: Icons.directions_bike,
                              onTap: () {},
                              isCalculated: travelTime != null,
                            ),
                            const SizedBox(width: 8),
                            MapRouteButton(
                              by: '車',
                              duration:
                                  travelTime?.driving != null
                                      ? '${travelTime?.driving}分'
                                      : '--分',
                              departureTime: _calculateDepartureTime(
                                travelTime?.driving,
                              ),
                              icon: Icons.directions_car,
                              onTap: () {},
                              isCalculated: travelTime != null,
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        const Text(
                          "メンバーへひとこと",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.orangeAccent,
                              ),
                            ),
                            hintText: 'ちょっと遅れる！',
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: const TextStyle(fontSize: 14),
                          maxLines: 1,
                          onSubmitted: onSubmitMessage,
                        ),

                        // 🔹 メンバー一覧
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.all(0),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 24,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${group!.users.length}人中 ${group!.users.where((p) => p.isArrived).length}人が到着済み",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            children:
                                group!.users.map((user) {
                                  bool isArrived = user.isArrived;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          user.name,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const Spacer(),
                                        Row(
                                          children: [
                                            Icon(
                                              isArrived
                                                  ? Icons.check_circle
                                                  : Icons.access_time,
                                              color:
                                                  isArrived
                                                      ? Colors.green
                                                      : Colors.grey,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isArrived ? "到着済み" : "未到着",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    isArrived
                                                        ? Colors.green
                                                        : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

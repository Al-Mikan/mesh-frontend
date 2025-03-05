import 'package:flutter/material.dart';

class MapRouteButton extends StatelessWidget {
  const MapRouteButton({
    super.key,
    required this.by,
    required this.duration,
    required this.departureTime,
    required this.icon,
    this.onTap,
    this.isCalculated = false,
  });

  final String by;
  final String duration;
  final String departureTime;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isCalculated;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isCalculated ? Colors.black12 : Colors.grey[300],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 24,
                      color: isCalculated ? Colors.deepOrange : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      departureTime,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCalculated ? Colors.black : Colors.grey,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$byで$duration',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isCalculated ? Colors.grey[700] : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FlightCardShimmer extends StatelessWidget {
  const FlightCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          children: [
            Row(
              children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 100, height: 16, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(width: 60, height: 12, color: Colors.white),
                  ],
                ),
                const Spacer(),
                Container(width: 60, height: 24, color: Colors.white),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 50, height: 20, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(width: 40, height: 14, color: Colors.white),
                  ],
                ),
                Container(width: 100, height: 20, color: Colors.white),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(width: 50, height: 20, color: Colors.white),
                    const SizedBox(height: 4),
                    Container(width: 40, height: 14, color: Colors.white),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

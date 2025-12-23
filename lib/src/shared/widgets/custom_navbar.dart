import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80, // Taller to accommodate the floating button if needed, or standard ~60 + padding
      decoration: const BoxDecoration(
        color: Colors.transparent, // Background handled by the bar container below
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // 1. White Background Bar
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
              boxShadow: [
                 BoxShadow(
                   color: Colors.black.withOpacity(0.05),
                   blurRadius: 10,
                   offset: const Offset(0, -5),
                 ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, Icons.home_outlined),
                _buildNavItem(1, Icons.explore_outlined),
                const SizedBox(width: 48), // Spacer for center button
                _buildNavItem(3, Icons.chat_bubble_outline),
                _buildNavItem(4, Icons.person_outline),
              ],
            ),
          ),

          // 2. Floating Center Button
          Positioned(
            top: 0, // Float slightly above the white bar (bar height 60, total 80, top 0 means 20px overlap up)
            // Actually, let's just center it relative to the top edge of the white bar
            // If total height is 80, and bar is bottom 60. Top of bar is at 20.
            // We want button center to be aligned with top of bar or slightly above.
            // Let's place it at top 10 (10px overlap above bar).
            bottom: 25, // Adjust vertical position
            child: GestureDetector(
              onTap: () => onItemTapped(2),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isSelected = selectedIndex == index;
    // Remap index for callback: 0,1 are direct. 3,4 map to 3,4. 
    // The spacer is index 2 logic-wise.
    
    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.grey[600],
              size: 28,
            ),
            const SizedBox(height: 4),
            // Active Indicator
            Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

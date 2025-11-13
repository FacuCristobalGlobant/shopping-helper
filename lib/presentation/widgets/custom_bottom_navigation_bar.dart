import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_poc/core/colors.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.color,
    required this.onAddCallback,
  });

  final Color color;
  final Function onAddCallback;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int currentlySelectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final markerSize = 70.0;
    return SizedBox(
      height: 60.0,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: size.width,
              height: 60.0,
              color: ColorHelper.primary,
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
            bottom: 0.0,
            left: (size.width / 4) * (currentlySelectedTab + 1) - ((size.width / 4) / 2) - (markerSize / 2),
            child: Container(
              height: markerSize,
              width: markerSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ColorHelper.background,
                border: BoxBorder.all(color: ColorHelper.primary, width: 3.0)
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: SizedBox(
              width: size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomNavigationItem(
                    onPressed: () {
                      currentlySelectedTab = 0;
                      setState(() {});
                      context.go('/');
                    },
                    icon: Icons.home_outlined,
                    isSelected: currentlySelectedTab == 0,
                  ),
                  CustomNavigationItem(
                    onPressed: () {
                      currentlySelectedTab = 1;
                      setState(() {});
                      context.go('/lists');
                    },
                    icon: Icons.list_alt_outlined,
                    isSelected: currentlySelectedTab == 1,
                  ),
                  CustomNavigationItem(
                    onPressed: () {
                      currentlySelectedTab = 2;
                      setState(() {});
                      context.go('/products');
                    },
                    icon: Icons.shopping_cart_outlined,
                    isSelected: currentlySelectedTab == 2,
                  ),
                  CustomNavigationItem(
                    onPressed: () {
                      currentlySelectedTab = 3;
                      setState(() {});
                      context.go('/settings');
                    },
                    icon: Icons.settings,
                    isSelected: currentlySelectedTab == 3,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomNavigationItem extends StatelessWidget {
  const CustomNavigationItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onPressed,
  });

  final IconData icon;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      duration: Duration(milliseconds: 200),
      height: 60.0,
      width: 60.0,
      margin: EdgeInsetsGeometry.only(bottom: isSelected ? 5.0 : 0.0),
      child: Center(
        child: IconButton(
          color: isSelected ? ColorHelper.primary : ColorHelper.background,
          onPressed: onPressed,
          icon: Icon(icon, size: isSelected ? 28.0 : null,),
        ),
      ),
    );
  }
}

//
// class BottomNavigationCustomPainter extends CustomPainter {
//   BottomNavigationCustomPainter({super.repaint, required this.color});
//
//   final Color color;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//     Path path = Path()..moveTo(0, 20);
//     path.lineTo(size.width * 0.40, 20);
//     path.arcToPoint(
//       Offset(size.width * 0.60, 20),
//       radius: Radius.circular(size.width * 0.10),
//       clockwise: false,
//     );
//     path.lineTo(size.width, 20);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

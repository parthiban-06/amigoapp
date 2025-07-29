import 'package:flutter/material.dart';

class AnimatedBottomBar extends StatefulWidget {
  const AnimatedBottomBar({
    super.key,
    this.height = 70,
    this.width = 100,
    this.selectedIndex = 0,
    this.iconSize,
    this.cornerRadius = 15,
    this.depth = 8,
    this.shrink = 30,
    this.color = Colors.blue,
    this.animationDuration = const Duration(milliseconds: 300),
    this.curves = Curves.easeInOut,
    required this.items,
    required this.onItemSelected,
  });

  final double height;
  final double width;
  final double cornerRadius;
  final double? iconSize;
  final double depth;
  final double shrink;
  final int selectedIndex;
  final Duration animationDuration;
  final Curve curves;
  final Color color;
  final List<AnimatedBarItem>? items;
  final ValueChanged<int>? onItemSelected;

  @override
  State<AnimatedBottomBar> createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar> {
  bool onPress = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildBackgroundContainer(),
        _buildAnimatedContainer(),
      ],
    );
  }

  Widget _buildBackgroundContainer() {
    return Container(
      height: widget.height + widget.depth,
    );
  }

  Widget _buildAnimatedContainer() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: widget.curves,
      bottom: _getBottomPosition(),
      child: Container(
        alignment: Alignment.center,
        width: widget.width,
        height: widget.height,
        child: _buildMainAnimatedContainer(),
      ),
    );
  }

  double _getBottomPosition() {
    return onPress == false ? widget.depth : 0;
  }

  Widget _buildMainAnimatedContainer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: widget.curves,
      width: _getContainerWidth(),
      height: widget.height,
      decoration: _buildContainerDecoration(),
      child: _buildItemsRow(),
    );
  }

  double _getContainerWidth() {
    return onPress == false ? widget.width : widget.width - widget.shrink;
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: widget.color,
      borderRadius: BorderRadius.circular(widget.cornerRadius),
      boxShadow: _buildBoxShadows(),
    );
  }

  List<BoxShadow> _buildBoxShadows() {
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        offset: const Offset(2, 4.0),
        blurRadius: 3.0,
        spreadRadius: 2.0,
      ),
      BoxShadow(
        color: widget.color,
        offset: const Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.0,
      ),
    ];
  }

  Widget _buildItemsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _buildItemWidgets(),
    );
  }

  List<Widget> _buildItemWidgets() {
    return widget.items!.map((item) {
      final index = widget.items!.indexOf(item);
      return _buildItemGestureDetector(item, index);
    }).toList();
  }

  Widget _buildItemGestureDetector(AnimatedBarItem item, int index) {
    return GestureDetector(
      onTap: () => _handleItemTap(index),
      child: _ItemWidget(
        item: item,
        iconSize: widget.iconSize ?? 20,
        width: _calculateItemWidth(),
        isSelected: index == widget.selectedIndex,
      ),
    );
  }

  double _calculateItemWidth() {
    return widget.width * (1 / (widget.items!.length + 1));
  }

  void _handleItemTap(int index) {
    setState(() {
      onPress = true;
    });

    Future.delayed(widget.animationDuration, () {
      if (mounted) {
        setState(() {
          widget.onItemSelected!(index);
          onPress = false;
        });
      }
    });
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final AnimatedBarItem item;
  final double width;

  const _ItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.width,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: width,
      color: Colors.transparent,
      child: item.title != null ? _buildItemWithTitle() : _buildItemIconOnly(),
    );
  }

  Widget _buildItemWithTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildIconTheme(),
        const SizedBox(height: 2),
        _buildTitleText(),
      ],
    );
  }

  Widget _buildItemIconOnly() {
    return _buildIconTheme();
  }

  Widget _buildIconTheme() {
    return IconTheme(
      data: IconThemeData(
        size: iconSize,
        color: _getItemColor(),
      ),
      child: item.icon,
    );
  }

  Widget _buildTitleText() {
    return DefaultTextStyle.merge(
      style: TextStyle(
        color: _getItemColor(),
        fontWeight: FontWeight.bold,
      ),
      child: item.title ?? const Text(""),
    );
  }

  Color _getItemColor() {
    if (isSelected) {
      return item.activeColor;
    }
    return item.inactiveColor ?? item.activeColor;
  }
}

class AnimatedBarItem {
  AnimatedBarItem({
    required this.icon,
    this.screen,
    this.activeColor = Colors.white,
    this.title,
    this.inactiveColor = Colors.black,
  });

  final Widget icon;

  final Widget? screen;

  final Widget? title;

  final Color activeColor;

  final Color? inactiveColor;
}

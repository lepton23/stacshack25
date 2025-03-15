import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  final Size preferredSize = const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 8.0),
          child: SvgPicture.asset(
            'assets/images/logo.svg',
            height: 70,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.surface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      title: Center(
        child: Text(
          'HiveMind',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      toolbarHeight: 90,
    );
  }
}

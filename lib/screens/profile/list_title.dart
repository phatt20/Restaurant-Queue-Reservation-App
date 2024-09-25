import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  final IconData leadingIcon;
  final Color leadingIconColor;

  final IconData trailingIcon;
  final Color trailingIconColor;
  final VoidCallback ontap;
  final String title;
  final TextStyle? titleStyle;
  final Color backgroundColor;
  final bool endIcon;
  final Color? titlecolor;
  const ListTitle(
      {super.key,
      required this.leadingIcon,
      required this.leadingIconColor,
      required this.trailingIcon,
      required this.trailingIconColor,
      required this.title,
      this.titleStyle,
      required this.backgroundColor,
      required this.ontap,
      required this.endIcon,
      this.titlecolor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: ontap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: backgroundColor.withOpacity(0.1),
        ),
        child: Icon(leadingIcon, color: leadingIconColor),
      ),
      title: Text(
        title,
        style: titleStyle ?? Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blueAccent.withOpacity(0.1),
              ),
              child: Icon(
                trailingIcon,
                color: trailingIconColor,
              ),
            )
          : null,
    );
  }
}

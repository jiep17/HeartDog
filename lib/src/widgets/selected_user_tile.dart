import 'package:flutter/material.dart';
import 'package:heartdog/src/widgets/user_avatar_button.dart';

class SelectedUserTile extends StatefulWidget {
  final void Function() onTap;

  const SelectedUserTile({super.key, required this.onTap});

  @override
  State<SelectedUserTile> createState() => _SelectedUserTileState();
}

class _SelectedUserTileState extends State<SelectedUserTile> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: const SizedBox(
        height: 60,
        width: 65,
        child: UserAvatar( // Puedes pasar el valor isSelected a tu UserAvatar.
          avatarSize: 55,
          image: "https://cdn-icons-png.flaticon.com/512/4644/4644948.png",
        ),
      ),
    );
  }
}
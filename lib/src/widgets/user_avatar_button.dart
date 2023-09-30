import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? image;
  final double avatarSize;

  const UserAvatar({ Key? key, this.image, required this.avatarSize}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Container(
        height: avatarSize,
        width: avatarSize,
        decoration: BoxDecoration(
            shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
        child: image != null
          ? Container(
              margin: const EdgeInsets.all(2),
              height:30,
              width: 30,
              //  size.height * 0.35,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(image!), fit: BoxFit.cover)),
            )
          : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(2),
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(Icons.image)),
         
    );
  }
}
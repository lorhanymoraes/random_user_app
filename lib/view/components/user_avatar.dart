import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;

  const UserAvatar({super.key, required this.imageUrl, this.radius = 40});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (context, url) => SizedBox(
            width: radius * 2,
            height: radius * 2,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          //fallback para ícone padrão caso a imagem não carregue;
          errorWidget: (context, url, error) =>
              Icon(Icons.person, size: radius, color: Colors.grey),
        ),
      ),
    );
  }
}

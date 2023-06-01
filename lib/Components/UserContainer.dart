import 'package:Bookstore/APIs/UserService.dart';
import 'package:Bookstore/Model/User.dart';
import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  final User user;
  final onTap;
  const UserContainer({Key? key, required this.user, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(
                      Radius.elliptical(
                          250, 250
                      )
                  ),
                  child: Image.network(
                    UserService.linkToImage(user.id)!,
                    width: 40,
                  )
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                user.username!,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

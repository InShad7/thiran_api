import 'package:flutter/material.dart';
import 'package:thiran2/view/utils/utils.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({super.key, this.repo});
  final repo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 8),
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height / 8,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: white,
            radius: 28,
            backgroundImage: repo.owner.avatarUrl == ''
                ? const AssetImage('assets/dp.jpg')
                : NetworkImage(repo.owner.avatarUrl) as ImageProvider,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Text(
                  repo.name.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.4,
                child: Text(
                  repo.description.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: grey),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: yellow),
                  Text(
                    repo.stargazersCount.toString(),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

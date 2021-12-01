import 'package:flutter/material.dart';
import 'package:fic_flutter/data_search.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String page;
  const TopBar({
    Key? key,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 60,
      backgroundColor: Colors.green,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              iconSize: 35,
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                IconButton(
                  icon: Image.asset('assets/images/FIC logo.png'),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  iconSize: 50,
                ),
                Positioned(
                  top: 12.0,
                  right: 10.0,
                  width: 10.0,
                  height: 10.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              ],
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                child: Text(page)),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () =>
              {showSearch(context: context, delegate: DataSearch())},
          icon: const Icon(Icons.search),
          iconSize: 30,
        ),
        IconButton(
          onPressed: () => {const Drawer()},
          icon: const Icon(Icons.settings),
          iconSize: 30,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

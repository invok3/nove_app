import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:novel_app/providers/saved_data.dart';
import 'package:novel_app/providers/reading.dart';
import 'package:novel_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> e;
  final GlobalKey<State<BottomNavigationBar>> bnbk;
  const CategoryCard({
    Key? key,
    required this.e,
    required this.bnbk,
    // required this.widget,
  }) : super(key: key);

  //final CategoriesPage widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      shadowColor: Provider.of<ThemeProvider>(context).selectedColor,
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: InkWell(
        onTap: () {
          Provider.of<Reading>(context, listen: false).setCatID(e.id);
          var bnv = bnbk.currentWidget as BottomNavigationBar;
          bnv.onTap!(1);
        },
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(e["image"]),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Text(
                    e["title"],
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            Provider.of<ThemeProvider>(context).selectedColor),
                  ),
                  Text(
                    e["description"],
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
            Column(
              children: [
                Icon(Provider.of<SavedData>(context).bookmarked["catID"] == e.id
                    ? Icons.bookmark
                    : Icons.bookmark_outline),
                IconButton(
                  icon: Icon(Provider.of<SavedData>(context)
                          .favoriteCategories
                          .contains(e.id)
                      ? Icons.favorite
                      : Icons.favorite_outline),
                  onPressed: () {
                    Provider.of<SavedData>(context, listen: false)
                            .favoriteCategories
                            .contains(e.id)
                        ? Provider.of<SavedData>(context, listen: false)
                            .removeData(list: "favoriteCategories", data: e.id)
                        : Provider.of<SavedData>(context, listen: false)
                            .saveData(data: e.id, list: "favoriteCategories");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

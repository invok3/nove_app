import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:novel_app/pages/story_page.dart';
import 'package:novel_app/providers/content_provider.dart';
import 'package:novel_app/providers/reading.dart';
import 'package:novel_app/providers/saved_data.dart';
import 'package:novel_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class StoryCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> e;
  const StoryCard({Key? key, required this.e}) : super(key: key);

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
          Provider.of<Reading>(context, listen: false).setStoryID(e.id);
          Provider.of<Reading>(context, listen: false).setCatID(e["catID"]);
          Navigator.pushNamed(context, StoryPage.routeName);
        },
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    Provider.of<ContentProvider>(context)
                        .categories!
                        .firstWhere(
                            (element) => element.id == e["catID"])["image"],
                  ),
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
                Icon(Provider.of<SavedData>(context).bookmarked["storyID"] ==
                        e.id
                    ? Icons.bookmark
                    : Icons.bookmark_outline),
                IconButton(
                  icon: Icon(Provider.of<SavedData>(context)
                          .favoriteStories
                          .contains(e.id)
                      ? Icons.favorite
                      : Icons.favorite_outline),
                  onPressed: () {
                    Provider.of<SavedData>(context, listen: false)
                            .favoriteStories
                            .contains(e.id)
                        ? Provider.of<SavedData>(context, listen: false)
                            .removeData(list: "favoriteStories", data: e.id)
                        : Provider.of<SavedData>(context, listen: false)
                            .saveData(data: e.id, list: "favoriteStories");
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

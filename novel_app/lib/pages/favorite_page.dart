import 'package:flutter/material.dart';
import 'package:novel_app/pages/components/category_card.dart';
import 'package:novel_app/pages/components/story_card.dart';
import 'package:novel_app/providers/content_provider.dart';
import 'package:novel_app/providers/saved_data.dart';
import 'package:novel_app/translate/translator.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  final GlobalKey<State<BottomNavigationBar>> bnbk;
  const FavoritePage({Key? key, required this.bnbk}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Provider.of<ContentProvider>(context).content == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Provider.of<ContentProvider>(context)
                          .categories!
                          .isEmpty ||
                      (Provider.of<SavedData>(context)
                              .favoriteCategories
                              .isEmpty &&
                          Provider.of<SavedData>(context)
                              .favoriteStories
                              .isEmpty)
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * .7,
                      child: Center(
                        child: Text(Translator.of(context, "noContentCap")),
                      ),
                    )
                  : Column(
                      children: [
                        ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: Provider.of<ContentProvider>(context)
                              .categories!
                              .where((element) =>
                                  Provider.of<SavedData>(context)
                                      .favoriteCategories
                                      .contains(element.id))
                              .map(
                                (e) => CategoryCard(bnbk: widget.bnbk, e: e),
                              )
                              .toList(),
                        ),
                        ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: Provider.of<ContentProvider>(context)
                              .stories!
                              .where((element) =>
                                  Provider.of<SavedData>(context)
                                      .favoriteStories
                                      .contains(element.id))
                              .map(
                                (e) => StoryCard(e: e),
                              )
                              .toList(),
                        ),
                      ],
                    ),
            ),
      onRefresh: () async {
        Provider.of<ContentProvider>(context, listen: false).refreshContent();
      },
    );
  }
}

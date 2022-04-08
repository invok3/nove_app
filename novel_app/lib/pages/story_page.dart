import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:novel_app/pages/components/font_size_dialog.dart';
import 'package:novel_app/providers/content_provider.dart';
import 'package:novel_app/providers/reading.dart';
import 'package:novel_app/providers/saved_data.dart';
import 'package:novel_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class StoryPage extends StatefulWidget {
  static String routeName = "/StoryPage";
  const StoryPage({Key? key}) : super(key: key);

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  double tsf = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Provider.of<ThemeProvider>(context).selectedColor,
                blurRadius: 6,
                spreadRadius: -2,
                offset: Offset(0, 0))
          ],
          color: Theme.of(context).canvasColor,
        ),
        margin: EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        child: Material(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: Provider.of<ContentProvider>(context,
                                    listen: false)
                                .stories!
                                .first
                                .id ==
                            Provider.of<Reading>(context).storyID
                        ? null
                        : () {
                            int indexOfPrevStory = Provider.of<ContentProvider>(
                                    context,
                                    listen: false)
                                .stories!
                                .indexWhere((element) =>
                                    element.id ==
                                    Provider.of<Reading>(context, listen: false)
                                        .storyID);
                            String prevStoryID = Provider.of<ContentProvider>(
                                    context,
                                    listen: false)
                                .stories![indexOfPrevStory - 1]
                                .id;
                            String prevCatID = Provider.of<ContentProvider>(
                                    context,
                                    listen: false)
                                .stories![indexOfPrevStory - 1]["catID"];
                            Provider.of<Reading>(context, listen: false)
                                .setCatID(prevCatID);
                            Provider.of<Reading>(context, listen: false)
                                .setStoryID(prevStoryID);
                            //debugPrint(nextCatID + ":" + nextStoryID);
                          },
                    icon: Icon(Icons.arrow_back_ios)),
                IconButton(
                    onPressed: () => _bookmark(),
                    icon: Icon(
                        Provider.of<SavedData>(context).bookmarked["storyID"] ==
                                    Provider.of<Reading>(context).storyID &&
                                Provider.of<Reading>(context).storyID != null
                            ? Icons.bookmark
                            : Icons.bookmark_outline)),
                IconButton(
                    onPressed: () => toggleFavorite(),
                    icon: Icon(Provider.of<SavedData>(context).isFavoriteStory(
                            Provider.of<Reading>(context).storyID)
                        ? Icons.favorite
                        : Icons.favorite_outline)),
                IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                IconButton(
                    onPressed: () {
                      _textScale();
                    },
                    icon: Icon(Icons.text_fields)),
                IconButton(
                    onPressed: Provider.of<ContentProvider>(context,
                                    listen: false)
                                .stories!
                                .last
                                .id ==
                            Provider.of<Reading>(context).storyID
                        ? null
                        : () {
                            int indexOfNextStory = Provider.of<ContentProvider>(
                                    context,
                                    listen: false)
                                .stories!
                                .indexWhere((element) =>
                                    element.id ==
                                    Provider.of<Reading>(context, listen: false)
                                        .storyID);
                            String nextStoryID = Provider.of<ContentProvider>(
                                    context,
                                    listen: false)
                                .stories![indexOfNextStory + 1]
                                .id;
                            String nextCatID = Provider.of<ContentProvider>(
                                    context,
                                    listen: false)
                                .stories![indexOfNextStory + 1]["catID"];
                            Provider.of<Reading>(context, listen: false)
                                .setCatID(nextCatID);
                            Provider.of<Reading>(context, listen: false)
                                .setStoryID(nextStoryID);
                            //debugPrint(nextCatID + ":" + nextStoryID);
                          },
                    icon: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              elevation: 0,
              pinned: true,
              stretch: true,
              expandedHeight: MediaQuery.of(context).size.width * .66,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: [
                  StretchMode.blurBackground,
                  StretchMode.zoomBackground
                ],
                title: Text(
                  Provider.of<ContentProvider>(context, listen: false)
                      .stories!
                      .firstWhere((element) =>
                          Provider.of<Reading>(context, listen: false)
                              .storyID ==
                          element.id)["title"],
                ),
                centerTitle: true,
                background: Image.network(
                  Provider.of<ContentProvider>(context, listen: false)
                      .categories!
                      .firstWhere((element) =>
                          element.id ==
                          Provider.of<Reading>(context).catID)["image"],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: tsf,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  child: Center(
                    child: quill.QuillEditor(
                      controller: quill.QuillController(
                        selection:
                            TextSelection(baseOffset: 0, extentOffset: 0),
                        document: _getDocument(context),
                      ),
                      readOnly: true,
                      padding: EdgeInsets.zero,
                      focusNode: FocusNode(),
                      scrollable: false,
                      scrollController: ScrollController(),
                      autoFocus: true,
                      showCursor: false,
                      expands: false,
                      enableInteractiveSelection: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  toggleFavorite() {
    Provider.of<SavedData>(context, listen: false).isFavoriteStory(
            Provider.of<Reading>(context, listen: false).storyID)
        ? Provider.of<SavedData>(context, listen: false).removeData(
            data: Provider.of<Reading>(context, listen: false).storyID!,
            list: "favoriteStories")
        : Provider.of<SavedData>(context, listen: false).saveData(
            data: Provider.of<Reading>(context, listen: false).storyID!,
            list: "favoriteStories");
  }

  _bookmark() {
    Provider.of<SavedData>(context, listen: false).bookmark(
      catID: Provider.of<Reading>(context, listen: false).catID,
      storyID: Provider.of<Reading>(context, listen: false).storyID,
    );
  }

  _getDocument(BuildContext context) {
    try {
      return quill.Document.fromJson(jsonDecode(
          Provider.of<ContentProvider>(context, listen: false)
              .stories
              ?.firstWhere((element) =>
                  element.id ==
                  Provider.of<Reading>(context).storyID)["document"]));
    } catch (e) {
      return quill.Document();
    }
  }

  _textScale() async {
    double? x = await showDialog(
        context: context,
        builder: (context) => FontSizeAlertDialog(
              value: tsf,
            ));
    if (x == null) {
      return;
    } else {
      setState(() {
        tsf = x;
      });
    }
  }
}

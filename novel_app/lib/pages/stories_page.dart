import 'package:flutter/material.dart';
import 'package:novel_app/pages/components/story_card.dart';
import 'package:novel_app/providers/content_provider.dart';
import 'package:novel_app/providers/reading.dart';
import 'package:novel_app/translate/translator.dart';
import 'package:provider/provider.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({Key? key}) : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Provider.of<ContentProvider>(context).content == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Provider.of<ContentProvider>(context).stories!.isEmpty
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(Translator.of(context, "noContentCap")),
                      ),
                    )
                  : ListView(
                      primary: false,
                      shrinkWrap: true,
                      children: (Provider.of<Reading>(context).catID == null
                              ? Provider.of<ContentProvider>(context).stories!
                              : Provider.of<ContentProvider>(context)
                                  .stories!
                                  .where((element) =>
                                      element["catID"] ==
                                      Provider.of<Reading>(context).catID))
                          .map(
                            (e) => StoryCard(e: e),
                          )
                          .toList(),
                    ),
            ),
      onRefresh: () async {
        Provider.of<ContentProvider>(context, listen: false).refreshContent();
      },
    );
  }
}

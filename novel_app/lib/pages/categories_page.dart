import 'package:flutter/material.dart';
import 'package:novel_app/pages/components/category_card.dart';
import 'package:novel_app/providers/content_provider.dart';
import 'package:novel_app/translate/translator.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  final GlobalKey<State<BottomNavigationBar>> bnbk;
  const CategoriesPage({Key? key, required this.bnbk}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: Provider.of<ContentProvider>(context).content == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Provider.of<ContentProvider>(context).categories!.isEmpty
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
                      children: Provider.of<ContentProvider>(context)
                          .categories!
                          .map(
                            (e) => CategoryCard(bnbk: widget.bnbk, e: e),
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

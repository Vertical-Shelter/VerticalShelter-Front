import 'package:app/data/models/Contest/contestResp.dart';
import 'package:app/data/models/news/userNews/userNewsResp.dart';
import 'package:app/widgets/BackButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app/data/models/news/newsSalle/newsResp.dart';
import 'package:photo_view/photo_view.dart';
import '../core/app_export.dart';

class UnreadNewsPopup extends StatefulWidget {
  final UserNewsResp? userNewsResp;
  UnreadNewsPopup({this.userNewsResp});
  @override
  _UnreadNewsPopupState createState() => _UnreadNewsPopupState();
}

class _UnreadNewsPopupState extends State<UnreadNewsPopup> {
  NewsResp? newsResp;
  ContestResp? contestResp;
  void initState() {
    super.initState();
    newsResp = widget.userNewsResp?.news_id;
    contestResp = widget.userNewsResp?.contest_id;
  }

  Widget build(BuildContext context) {
    return Center(
        child: Container(
            height: MediaQuery.of(context).size.height - 200,
            width: MediaQuery.of(context).size.width - 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8)),
            child: Scaffold(
                body: Stack(children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(children: [
                      Container(
                          height: context.height * 0.35,
                          width: width,
                          child: CachedNetworkImage(
                            imageUrl: newsResp != null
                                ? newsResp!.imageUrl!
                                : contestResp!.imageUrl!,
                            fit: BoxFit.cover,
                          )),
                    ]),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        newsResp != null
                            ? newsResp!.title!
                            : contestResp!.title!,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 30),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(newsResp != null
                          ? newsResp!.description!
                          : contestResp!.description!),
                    ),
                  ]),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(Icons.close),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ]))));
  }
}

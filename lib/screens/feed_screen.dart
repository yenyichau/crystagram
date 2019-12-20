import 'package:crystagram_yen/utilities/keep_alive_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:crystagram_yen/models/post_model.dart';
import 'package:crystagram_yen/models/user_model.dart';
import 'package:crystagram_yen/services/database_service.dart';
import 'package:crystagram_yen/widgets/post_view.dart';

class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  final String currentUserId;
  bool isFromNavigationTab;

  FeedScreen({this.currentUserId, this.isFromNavigationTab});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    List<Post> posts = await DatabaseService.getFeedPosts(widget.currentUserId);

    setState(() {
      isLoading = false;
      widget.isFromNavigationTab = false;
      _posts = posts;
    });
  }

  _bodyFeed() {
    return RefreshIndicator(
      onRefresh: () => _setupFeed(),
      child: isLoading && widget.isFromNavigationTab
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _listViewFeed(),
    );
  }

  _listViewFeed() {
    return _posts.length <= 0
        ? RefreshIndicator(
            onRefresh: () => _setupFeed(),
            child: PageView(
              scrollDirection: Axis.vertical,
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Center(
                  child: Text('No any posts available'),
                )
              ],
            ),
          )
        : ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (BuildContext context, int index) {
              Post post = _posts[index];
              return KeepAliveFutureBuilder(
                future: DatabaseService.getUserWithId(post.authorId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }
                  User author = snapshot.data;
                  return PostView(
                    currentUserId: widget.currentUserId,
                    post: post,
                    author: author,
                  );
                },
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'crystagram',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Billabong',
            fontSize: 35.0,
          ),
        ),
      ),
      body: _bodyFeed(),
    );
  }
}

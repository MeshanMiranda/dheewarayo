import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import 'add_post_screen.dart';
import 'base_screen.dart';

// CommunityScreen displays a social feed where users can see posts from other fishermen
class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BaseScreen(
      title: l10n.communityFeed,
      actions: [
        IconButton(
          icon: const Icon(Icons.add_comment_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPostScreen()),
            );
          },
        ),
      ],
      // StreamBuilder listens to the 'posts' collection in Firebase in real-time
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true) // Sort newest posts first
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(l10n.somethingWentWrong));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(l10n.noPostsYet),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final postId = doc.id;
              final userId = data['userId'] as String?;
              final user = data['username'] as String? ?? l10n.unknownUser;
              final text = data['caption'] as String? ?? '';
              final imageUrl = data['imageUrl'] as String?;
              final userProfilePic = data['userProfilePic'] as String?;

              final currentUserId = FirebaseAuth.instance.currentUser?.uid;

              final likesData = data['likes'];
              List<dynamic> likes = [];
              if (likesData is List) {
                likes = likesData;
              }
              final isLiked =
                  currentUserId != null && likes.contains(currentUserId);
              final likeCount = likesData is int ? likesData : likes.length;

              final commentsData = data['comments'];
              List<dynamic> comments = [];
              if (commentsData is List) {
                comments = commentsData;
              }
              final commentCount = commentsData is int
                  ? commentsData
                  : comments.length;

              String timeStr = '';
              if (data['timestamp'] != null) {
                DateTime? dateTime;
                if (data['timestamp'] is Timestamp) {
                  dateTime = (data['timestamp'] as Timestamp).toDate();
                } else if (data['timestamp'] is String) {
                  dateTime = DateTime.tryParse(data['timestamp'] as String);
                }

                if (dateTime != null) {
                  final diff = DateTime.now().difference(dateTime);
                  if (diff.inDays > 0) {
                    timeStr = l10n.daysAgo(diff.inDays.toString());
                  } else if (diff.inHours > 0) {
                    timeStr = l10n.hoursAgo(diff.inHours.toString());
                  } else if (diff.inMinutes > 0) {
                    timeStr = l10n.minutesAgo(diff.inMinutes.toString());
                  } else {
                    timeStr = l10n.justNow;
                  }
                }
              }

              return _buildPostCard(
                context,
                postId,
                userId,
                user,
                text,
                timeStr,
                imageUrl,
                userProfilePic,
                l10n,
                isLiked,
                likeCount,
                commentCount,
              );
            },
          );
        },
      ),
    );
  }

  // Builds a single post card in the feed
  Widget _buildPostCard(
    BuildContext context,
    String postId,
    String? userId,
    String user,
    String text,
    String time,
    String? imageUrl,
    String? userProfilePic,
    AppLocalizations l10n,
    bool isLiked,
    int likeCount,
    int commentCount,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  backgroundImage:
                      userProfilePic != null && userProfilePic.isNotEmpty
                      ? NetworkImage(userProfilePic)
                      : null,
                  child: userProfilePic == null || userProfilePic.isEmpty
                      ? Text(
                          user.isNotEmpty ? user[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(time, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                if (FirebaseAuth.instance.currentUser?.uid == userId &&
                    userId != null)
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPostScreen(
                              editPostId: postId,
                              editCaption: text,
                              editImageUrl: imageUrl,
                            ),
                          ),
                        );
                      } else if (value == 'delete') {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: Text(l10n.deletePostTitle),
                            content: Text(
                              l10n.deletePostPrompt,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(l10n.cancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(dialogContext);
                                  try {
                                    await FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(postId)
                                        .delete();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.postDeletedSuccessfully,
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.failedToDeletePost(e.toString()),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                child: Text(l10n.delete),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Post Content
            Text(text),
            if (imageUrl != null) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
            ],
            const SizedBox(height: 10),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton.icon(
                  onPressed: () => _toggleLike(postId, isLiked),
                  icon: Icon(
                    isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    size: 18,
                    color: isLiked ? Theme.of(context).primaryColor : null,
                  ),
                  label: Text('$likeCount ${l10n.like}'),
                ),
                TextButton.icon(
                  onPressed: () => _showCommentsBottomSheet(context, postId),
                  icon: const Icon(Icons.comment_outlined, size: 18),
                  label: Text('$commentCount ${l10n.comment}'),
                ),
                TextButton.icon(
                  onPressed: () {
                    final String shareText =
                        "$user posted:\n$text${imageUrl != null ? '\n$imageUrl' : ''}";
                    Share.share(shareText);
                  },
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: Text(l10n.share),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Handles when a user taps the "Like" button on a post
  Future<void> _toggleLike(String postId, bool isLiked) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // Must be logged in to like
    final uid = currentUser.uid;

    final docRef = FirebaseFirestore.instance.collection('posts').doc(postId);

    try {
      if (isLiked) {
        await docRef.update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await docRef.update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      if (!isLiked) {
        await docRef.update({
          'likes': [uid],
        });
      }
    }
  }

  // Shows a bottom sheet overlay with all comments for a specific post
  void _showCommentsBottomSheet(BuildContext context, String postId) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.commentsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Center(child: Text(l10n.postNotFound));
                    }

                    final data = snapshot.data!.data() as Map<String, dynamic>?;
                    final commentsData = data?['comments'];
                    List<dynamic> comments = [];
                    if (commentsData is List) {
                      comments = commentsData;
                    }

                    if (comments.isEmpty) {
                      return Center(child: Text(l10n.noCommentsYet));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index] as Map<String, dynamic>;
                        final username =
                            comment['username'] as String? ?? l10n.userLabel;
                        final text = comment['text'] as String? ?? '';
                        final timestamp = comment['timestamp'];

                        String timeStr = '';
                        if (timestamp != null) {
                          DateTime? dt;
                          if (timestamp is Timestamp) {
                            dt = timestamp.toDate();
                          } else if (timestamp is String) {
                            dt = DateTime.tryParse(timestamp);
                          }

                          if (dt != null) {
                            final diff = DateTime.now().difference(dt);
                            if (diff.inDays > 0) {
                              timeStr = l10n.daysAgo(diff.inDays.toString());
                            } else if (diff.inHours > 0) {
                              timeStr = l10n.hoursAgo(diff.inHours.toString());
                            } else if (diff.inMinutes > 0) {
                              timeStr = l10n.minutesAgo(diff.inMinutes.toString());
                            } else {
                              timeStr = l10n.justNow;
                            }
                          }
                        }

                        return ListTile(
                          title: Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(text),
                          trailing: Text(
                            timeStr,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: l10n.addCommentHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      final text = commentController.text.trim();
                      if (text.isEmpty) return;

                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) return;

                      String username = user.displayName ?? '';
                      if (username.isEmpty && user.email != null) {
                        username = user.email!.split('@')[0];
                      }
                      if (username.isEmpty) {
                        username = l10n.unknownUser;
                      }

                      final newComment = {
                        'userId': user.uid,
                        'username': username,
                        'text': text,
                        'timestamp': Timestamp.now(),
                      };

                      try {
                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .update({
                              'comments': FieldValue.arrayUnion([newComment]),
                            });
                      } catch (e) {
                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(postId)
                            .update({
                              'comments': [newComment],
                            });
                      }

                      commentController.clear();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

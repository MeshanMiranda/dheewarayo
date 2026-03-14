import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'add_post_screen.dart';
import 'base_screen.dart';

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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No posts yet. Be the first to post!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final user = data['username'] as String? ?? 'Unknown User';
              final text = data['caption'] as String? ?? '';
              final imageUrl = data['imageUrl'] as String?;
              final userProfilePic = data['userProfilePic'] as String?;

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
                    timeStr = '${diff.inMinutes} minutes ago';
                  } else {
                    timeStr = 'Just now';
                  }
                }
              }

              return _buildPostCard(
                context,
                user,
                text,
                timeStr,
                imageUrl,
                userProfilePic,
                l10n,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    String user,
    String text,
    String time,
    String? imageUrl,
    String? userProfilePic,
    AppLocalizations l10n,
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
                  backgroundImage: userProfilePic != null && userProfilePic.isNotEmpty
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(time, style: Theme.of(context).textTheme.bodySmall),
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
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                  label: Text(l10n.like),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_outlined, size: 18),
                  label: Text(l10n.comment),
                ),
                TextButton.icon(
                  onPressed: () {},
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
}

import 'package:flutter/material.dart';
import 'base_screen.dart';
import '../theme.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Community Feed',
      actions: [
        IconButton(
          icon: const Icon(Icons.add_comment_outlined),
          onPressed: () {
            // TODO: Implement New Post form
          },
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          _buildPostCard(
            context,
            'Lasantha Fernando',
            'Ada kattiyata maalu ahuunada? Me photo eka balanna.',
            '2 hours ago',
            'assets/img/fishmarket.jpg',
          ),
          _buildPostCard(
            context,
            'Sandun Perera',
            'Ada raata muduhu yanna epa kauruwath. News balanna.',
            '5 hours ago',
            null,
          ),
          _buildPostCard(
            context,
            'Kamal Silva',
            'Poruthota Asala bottuwak peralila. kattiya parissamin yanna',
            '1 day ago',
            null,
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(
    BuildContext context,
    String user,
    String text,
    String time,
    String? imageUrl,
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
                  backgroundColor: secondaryLight,
                  child: Text(
                    user[0],
                    style: const TextStyle(color: primaryDark),
                  ),
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
              // Placeholder for image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
                  label: const Text('Like'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_outlined, size: 18),
                  label: const Text('Comment'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

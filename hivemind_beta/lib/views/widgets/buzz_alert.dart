import 'package:flutter/material.dart';
/// Widget that displays the buzz alert 
/// 
/// Shows a note/message along with social interaction features like likes, dislikes,
/// and comments. Users can interact with the post through:
/// * Liking/disliking the post
/// * Adding comments
/// * Viewing the fixed phrase address
///
/// Parameters:
/// - [note] - The main text content of the alert
/// - [likes] - Initial number of likes
/// - [dislikes] - Initial number of dislikes  
/// - [comments] - List of existing comments
/// - [fixedPhraseAddress] - Unique identifier made up of fixed phrases

class BuzzAlert extends StatefulWidget {
  /// The main message content of the alert
  final String note;
  /// The current number of likes on the post
  final int likes;
  /// The current number of dislikes on the post
  final int dislikes;
  /// List of user comments on the post
  final List<String> comments;
  /// The unique what3words-style address identifier
  final String fixedPhraseAddress;

  const BuzzAlert({
    super.key,
    required this.note,
    required this.likes,
    required this.comments,
    required this.dislikes,
    required this.fixedPhraseAddress,
  });

  @override
  State<BuzzAlert> createState() => _BuzzAlertState();
}

class _BuzzAlertState extends State<BuzzAlert> {
  bool isLiked = false;
  late int likeCount;
  bool isDisliked = false;
  late int dislikeCount;
  late List<String> commentsList;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
    dislikeCount = widget.dislikes;
    commentsList = List.from(widget.comments);
  }

  void _addComment() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        commentsList.add(_textController.text);
        _textController.clear();
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      constraints: const BoxConstraints(),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Buzz Alert!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Bzzz... Somebody left a note here!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Fixed Phrase Address: ${widget.fixedPhraseAddress}',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
        
            const SizedBox(height: 20),
            Text(
              'The Note Says:',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                widget.note,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //TODO: INCREMENT ON THE DATABASE
                        setState(() {
                          isLiked = !isLiked;
                          likeCount = isLiked ? likeCount + 1 : likeCount - 1;
                        });
                      },
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text('$likeCount'),
                  ],
                ),
                const SizedBox(width: 50),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //TODO: INCREMENT ON THE DATABASE
                        setState(() {
                          isDisliked = !isDisliked;
                          dislikeCount = isDisliked ? dislikeCount + 1 : dislikeCount - 1;
                        });
                      },
                      child: Icon(
                        isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                        color: isDisliked ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text('$dislikeCount'),
                  ],
                ),
                
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Comments:',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            for (String comment in commentsList)
              Text(
                comment,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addComment,
                  ),
                ),
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
          Center(
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                //TODO: Implement closing the Buzz Alert
              },
              iconSize: 50,
            ),
          ),
          ],
        ),
      ),
    );
  }
}

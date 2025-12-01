import '../../../../../utils/exported_path.dart';

class CommentsBottomSheet extends StatefulWidget {
  final String postId;

  const CommentsBottomSheet({super.key, required this.postId});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final commentController = getIt<FeedsController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentController.getSinglePost(widget.postId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.85,
      minChildSize: 0.50,
      builder: (context, scroll) {
        return Container(
          // height: Get.height * 0.85.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, size: 24),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.blueGrey),

              // Comments List
              Expanded(
                child: Obx(() {
                  if (commentController.isCommentLoading.value) {
                    return LoadingWidget(color: primaryColor);
                  }

                  if (commentController.comments.isEmpty) {
                    return _buildEmptyComment();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: commentController.comments.length,
                    itemBuilder: (context, index) {
                      final comment = commentController.comments[index];
                      return _buildCommentItem(comment);
                    },
                  );
                }),
              ),

              // Add Comment Section
              _buildAddCommentSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyComment() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.comment_outlined, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No comments yet',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          Text(
            'Be the first to comment',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        spacing: 12.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            child: ClipOval(
              child:
                  comment['user_profile_image']?.toString().isNotEmpty == true
                  ? Image.network(
                      comment['user_profile_image'].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            comment['user_name']
                                    ?.toString()
                                    .substring(0, 1)
                                    .toUpperCase() ??
                                '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        comment['user_name']
                                ?.toString()
                                .substring(0, 1)
                                .toUpperCase() ??
                            '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
            ),
          ),

          // Comment Content
          Expanded(
            child: Column(
              spacing: 4.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        title: comment['user_name']?.toString() ?? '',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(height: 4),
                      CustomText(
                        title: comment['comment']?.toString() ?? '',
                        fontSize: 14.sp,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    comment['created_at']?.toString() ?? '',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCommentSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // // Profile Icon (Current User)
          // Container(
          //   width: 40,
          //   height: 40,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //     color: Colors.blue[100],
          //   ),
          //   child: Icon(Icons.person, color: Colors.blue),
          // ),

          // SizedBox(width: 12),

          // Text Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController.commentTextController,
                      onChanged: (value) =>
                          commentController.newComment.value = value,
                      decoration: InputDecoration(
                        hintText: 'Write a comment...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) async {
                        if (value.trim().isNotEmpty) {
                          await commentController.addPostComment();
                        }
                      },
                    ),
                  ),

                  // Send Button
                  Obx(
                    () => commentController.isAddCommentLoading.isTrue
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LoadingWidget(
                              color: primaryColor,
                              size: 16.w,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              onPressed:
                                  commentController.newComment.value
                                      .trim()
                                      .isNotEmpty
                                  ? () async =>
                                        await commentController.addPostComment()
                                  : null,
                              icon: Icon(Icons.send),
                              color:
                                  commentController.newComment.value
                                      .trim()
                                      .isNotEmpty
                                  ? primaryColor
                                  : Colors.grey,
                              iconSize: 24,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

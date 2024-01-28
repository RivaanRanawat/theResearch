// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:research/common/loader.dart';
import 'package:research/features/home/home_controller.dart';
import 'package:research/models/research_model.dart';
import 'package:research/providers.dart';

class DiscussReplyPage extends ConsumerStatefulWidget {
  final ResearchModel researchModel;
  final String originalDiscussionId;
  final String originalDiscussionText;
  const DiscussReplyPage({
    super.key,
    required this.researchModel,
    required this.originalDiscussionId,
    required this.originalDiscussionText,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DiscussReplyPageState();
}

class _DiscussReplyPageState extends ConsumerState<DiscussReplyPage> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Replies'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ref
                .watch(getDiscussionsByReplyProvider((
                  widget.researchModel.id,
                  widget.originalDiscussionId,
                )))
                .when(
                  data: (researches) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: researches.length,
                        itemBuilder: (context, index) {
                          final research = researches[index];

                          return ListTile(
                            title: Text(research.text),
                            trailing:
                                widget.researchModel.uid == currentUser?.uid
                                    ? const Badge(
                                        backgroundColor: Colors.blue,
                                        label: Text('OP'),
                                      )
                                    : null,
                          );
                        },
                      ),
                    );
                  },
                  error: (error, st) {
                    return Center(
                      child: Text(
                        error.toString(),
                      ),
                    );
                  },
                  loading: () => const Loader(),
                ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    margin: const EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        hintText: 'Reply',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(homeControllerProvider.notifier).comment(
                          commentController.text.trim(),
                          widget.researchModel.id,
                          true,
                          widget.originalDiscussionId,
                          context,
                        );
                    setState(() {
                      commentController.text = '';
                    });
                  },
                  icon: const Icon(
                    Icons.send_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research/common/loader.dart';
import 'package:research/features/home/discuss_reply_page.dart';
import 'package:research/features/home/home_controller.dart';
import 'package:research/models/research_model.dart';
import 'package:research/providers.dart';

class DiscussPage extends ConsumerStatefulWidget {
  final ResearchModel researchModel;
  const DiscussPage({
    super.key,
    required this.researchModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscussPageState();
}

class _DiscussPageState extends ConsumerState<DiscussPage> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ref.watch(getDiscussionsProvider(widget.researchModel.id)).when(
                  data: (discussions) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: discussions.length,
                        itemBuilder: (context, index) {
                          final discuss = discussions[index];

                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DiscussReplyPage(
                                    researchModel: widget.researchModel,
                                    originalDiscussionId: discuss.discussionId,
                                    originalDiscussionText: discuss.text,
                                  ),
                                ),
                              );
                            },
                            title: Text(discuss.text),
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
                        hintText: 'Discuss',
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
                          false,
                          '',
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

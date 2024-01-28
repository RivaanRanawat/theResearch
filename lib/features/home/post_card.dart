import "package:flutter/material.dart";
import "package:research/models/research_model.dart";
import "package:syncfusion_flutter_pdfviewer/pdfviewer.dart";

class PostCard extends StatefulWidget {
  final ResearchModel researchModel;
  const PostCard({
    super.key,
    required this.researchModel,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.45,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        child: Stack(
          children: [
            SfPdfViewer.network(
              widget.researchModel.pdfUrl,
            ),
            Positioned(
              left: 5,
              top: 5,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  widget.researchModel.title,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (widget.researchModel.summary.isNotEmpty)
              Positioned(
                right: 5,
                top: 5,
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      useRootNavigator: true,
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(
                            30.0,
                          ),
                        ),
                      ),
                      builder: (newContext) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 10,
                              bottom: 10,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const Text(
                                    'Summary',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.researchModel.summary.trim(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(Icons.info_rounded),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

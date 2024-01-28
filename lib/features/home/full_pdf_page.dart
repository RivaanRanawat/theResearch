import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:research/features/home/discuss_page.dart';
import 'package:research/models/research_model.dart';
import 'package:research/theme/pallete.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FullPDFPage extends StatelessWidget {
  final ResearchModel researchModel;
  const FullPDFPage({
    super.key,
    required this.researchModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SfPdfViewer.network(
              researchModel.pdfUrl,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: MaterialButton(
                        elevation: 0,
                        height: 50,
                        onPressed: () {
                          // loginUser(type: LoginType.google, context: context);
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.dollarSign),
                            SizedBox(width: 10),
                            Text(
                              'Fund Research',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Stack(
                    //   children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: MaterialButton(
                        elevation: 0,
                        height: 50,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DiscussPage(
                                postId: researchModel.id,
                              ),
                            ),
                          );
                        },
                        color: Pallete.logoGreen,
                        textColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.comment),
                            SizedBox(width: 10),
                            Text(
                              'Discuss',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Badge(
                    //   backgroundColor: Colors.red,
                    //   label: Text(
                    //     researchModel.commentCount.toString(),
                    //   ),
                    // ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

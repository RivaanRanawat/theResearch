import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:research/features/auth/auth_controller.dart';
import 'package:research/features/home/discuss_page.dart';
import 'package:research/models/research_model.dart';
import 'package:research/providers.dart';
import 'package:research/theme/pallete.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FullPDFPage extends ConsumerWidget {
  final ResearchModel researchModel;
  const FullPDFPage({
    super.key,
    required this.researchModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: researchModel.fundingRaised != 0
          ? AppBar(title: Text('\$${researchModel.fundingRaised} raised!'))
          : null,
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
                    if (researchModel.uid !=
                        ref.watch(currentUserModelProvider)!.uid)
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: MaterialButton(
                          elevation: 0,
                          height: 50,
                          onPressed: () {
                            final user = ref.read(currentUserModelProvider)!;
                            showDialog(
                              context: context,
                              builder: (context) {
                                var fundingValue = 0.0;
                                return StatefulBuilder(
                                  builder: (context, setS) => Dialog(
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "How much would you like to fund this research?",
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                          Slider(
                                            value: fundingValue,
                                            min: 0,
                                            max: user.funding.toDouble() > 0
                                                ? user.funding.toDouble()
                                                : 0.1,
                                            thumbColor: Colors.blue,
                                            activeColor:
                                                Colors.blue.withOpacity(0.7),
                                            divisions: user.funding > 0
                                                ? user.funding
                                                : 1,
                                            label: '\$$fundingValue',
                                            onChanged: (val) {
                                              setS(() {
                                                fundingValue = val;
                                              });
                                            },
                                          ),
                                          MaterialButton(
                                            elevation: 0,
                                            minWidth: double.maxFinite,
                                            height: 50,
                                            onPressed: () {
                                              ref
                                                  .read(authControllerProvider
                                                      .notifier)
                                                  .updateFundingUsers(
                                                    researchModel.uid,
                                                    fundingValue.toInt(),
                                                    researchModel.id,
                                                    context,
                                                  );
                                            },
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5),
                                              ),
                                            ),
                                            child: Text(
                                              'Fund \$$fundingValue',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
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

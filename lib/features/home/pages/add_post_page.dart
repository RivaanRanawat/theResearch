import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:research/common/loader.dart';
import 'package:research/features/home/home_controller.dart';
import 'package:research/utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AddPostPage extends ConsumerStatefulWidget {
  const AddPostPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPostPageState();
}

class _AddPostPageState extends ConsumerState<AddPostPage> {
  final titleController = TextEditingController();
  File? selectedFile;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(homeControllerProvider);

    return isLoading
        ? const Loader()
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pdf = await pickPDF();
                        if (pdf != null) {
                          final pdfFile = File(pdf.path!);
                          setState(() {
                            selectedFile = pdfFile;
                          });
                        }
                      },
                      child: selectedFile != null
                          ? Stack(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    child: SfPdfViewer.file(selectedFile!),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedFile = null;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color: Colors.blue,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  // color: buttonColor.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      'Select your research',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.only(top: 25),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextFormField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Research Title',
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(
                            FontAwesomeIcons.pencil,
                            size: 18,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: () {
                        if (selectedFile != null) {
                          ref.read(homeControllerProvider.notifier).sharePDF(
                                titleController.text.trim(),
                                selectedFile!,
                                context,
                              );
                        }
                        // ref.read(authControllerProvider.notifier).loginUser(
                        //       email: emailController.text,
                        //       password: passwordController.text,
                        //       context: context,
                        //     );
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Upload!',
                        style: TextStyle(
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
  }
}

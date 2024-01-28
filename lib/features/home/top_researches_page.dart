import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:research/common/loader.dart';
import 'package:research/features/home/home_controller.dart';
import 'package:research/features/home/post_card.dart';
import 'package:research/theme/pallete.dart';

class TopResearchesPage extends ConsumerStatefulWidget {
  const TopResearchesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TopResearchesPageState();
}

class _TopResearchesPageState extends ConsumerState<TopResearchesPage> {
  var selectedValue = 'commentCount';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Top Researches'),
        actions: [
          DropdownButton<String>(
            value: selectedValue,
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
            dropdownColor: Pallete.secondaryColor,
            items: const [
              DropdownMenuItem(
                value: 'commentCount',
                child: Text('Discussion'),
              ),
              DropdownMenuItem(
                value: 'fundingRaised',
                child: Text('Funding'),
              ),
            ].map<DropdownMenuItem<String>>((item) {
              return item;
            }).toList(),
          ),
        ],
      ),
      body: ref
          .watch(
        getTopPDFsProvider(selectedValue),
      )
          .when(
        data: (posts) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView.separated(
              itemCount: posts.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                final post = posts[index];

                return PostCard(researchModel: post);
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
        loading: () {
          return const Loader();
        },
      ),
    );
  }
}

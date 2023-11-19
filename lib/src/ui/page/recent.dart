import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_project/src/common/logger.dart';
import 'package:flutter_cubit_project/src/res/colors.dart';
import 'package:flutter_cubit_project/src/res/text_themes.dart';
import 'package:flutter_cubit_project/src/vm/models/search.dart';
import 'package:flutter_cubit_project/src/vm/recent.dart';
import 'package:flutter_cubit_project/src/vm/states/recent.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentViewModel, RecentState>(
      builder: (context, state) {
        return _drawContents(state.recentModels ?? []);
      },
    );
  }

  Widget _drawContents(List<RecentModel> recentModels) {
    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: recentModels.length,
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          final recentModel = recentModels[index];
          return GestureDetector(
              onTap: () {},
              child: recentModel.type == RecentViewType.Image
                  ? _makeImageItem(recentModel: recentModel)
                  : _makeTextItem(recentModel: recentModel));
        },
      ),
    );
  }

  Widget _makeImageItem({required RecentModel recentModel}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;
        return Container(
          width: width,
          height: width * 0.75,
          margin: const EdgeInsets.all(10),
          color: colorScheme.primaryBlack,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Center(
                child: Image(
                  image: NetworkImage(recentModel.imageUrl!),
                  fit: BoxFit.fitHeight,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }
                    return frame != null ? child : Text("loading..");
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return Text("error");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  recentModel.title,
                  style: textTheme.titleH3Bold.copyWith(color: colorScheme.primaryMain),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _makeTextItem({required RecentModel recentModel}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final title = recentModel.title.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
    final content = recentModel.contents!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;
        return Container(
          width: width,
          height: width * 0.75,
          margin: const EdgeInsets.all(10),
          color: colorScheme.primaryBlack,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleH3Bold.copyWith(color: colorScheme.primaryMain)),
                const SizedBox(height: 8),
                Text(content, style: textTheme.bodyB2Medium.copyWith(color: colorScheme.primaryWhite)),
              ],
            ),
          ),
        );
      },
    );
  }
}

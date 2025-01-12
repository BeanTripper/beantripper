import 'package:bean_tripper/constant/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/presentation/pages/feeds/trending_cafe_view_model.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const StrokeText({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 테두리
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = Colors.black,
          ),
        ),
        // 실제 텍스트
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class CafeOfTheDay extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trendingCafeViewModelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!));
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: state.cafes.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cafe = state.cafes[index];
          return Container(
            width: 140,
            decoration: BoxDecoration(
              color: CustomColors.darkGray,
              borderRadius: BorderRadius.circular(8),
              image: cafe.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(cafe.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StrokeText(
                    text: cafe.name,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (cafe.imageUrl == null)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 4,
                    children: cafe.category
                        .split(',')
                        .map((category) => StrokeText(
                              text: '#$category',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

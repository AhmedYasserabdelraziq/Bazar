import 'package:book_shop/core/widget/build_book.dart';
import 'package:book_shop/screens/categories/logic/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart'; // Ensure this package is included in your pubspec.yaml

class HorrorBooksScreen extends StatefulWidget {
  const HorrorBooksScreen({super.key});

  @override
  State<HorrorBooksScreen> createState() => _HorrorBooksScreenState();
}

class _HorrorBooksScreenState extends State<HorrorBooksScreen> {
  @override
  void initState() {
    super.initState();
    if (context.read<CategoriesCubit>().horrorList.isEmpty) {
      context.read<CategoriesCubit>().getCategory('horror');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CategoriesCubit, CategoriesState, Tuple2<bool, List>>(
      selector: (state) {
        final isLoading = state is LoadingList;
        final horrorList = context.read<CategoriesCubit>().horrorList;
        return Tuple2(isLoading, horrorList);
      },
      builder: (context, tuple) {
        final isLoading = tuple.item1;
        final horrorList = tuple.item2;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        double screenWidth = MediaQuery.of(context).size.width;
        int crossAxisCount = screenWidth < 600 ? 2 : screenWidth < 900 ? 3 : 4;
        double aspectRatio = screenWidth < 400 ? 0.65 : 0.75;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            mainAxisSpacing: 0.5,
            crossAxisSpacing: 0.5,
          ),
          itemBuilder: (ctx, index) {
            return Center(child: BuildBook(categoryList: horrorList[index]));
          },
          itemCount: horrorList.length,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/assets.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

class CategorySelectorWidget extends StatefulWidget {
  final double size;
  const CategorySelectorWidget({
    super.key,
    required this.size
  });

  @override
  State<CategorySelectorWidget> createState() => _CategorySelectorWidgetState();
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context, pos, child) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: ListView.builder(
              itemCount: pos.productServiceSelected==0?pos.productCategories!.length:pos.serviceCategories!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      pos.selectedCategoryIndex = index;
                    });
                    pos.switchCategories(pos.productServiceSelected==0?pos.productCategories![index].id!:pos.serviceCategories![index].id!);
                  },
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 100),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: pos.selectedCategoryIndex == index
                          ? AppColors.posScreenSelectedTextColor
                          : Colors.white,
                    ),
                    child: Center(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        pos.selectedCategoryIndex == index
                            ? Container()
                            : Image.asset(Assets.categoriesIcon),
                        horizontalSpaceTiny,
                        Text(
                          pos.productServiceSelected==0?pos.productCategories![index].name!:pos.serviceCategories![index].name!,
                          style: mainSubHeadingStyle().copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: widget.size,
                              color: pos.selectedCategoryIndex == index
                                  ? Colors.white
                                  : AppColors.posScreenSelectedTextColor),
                        ),
                      ],
                    )),
                  ),
                );
              }),
        );
      },
    );
  }
}

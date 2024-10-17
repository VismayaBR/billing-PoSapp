import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

class SwitchTypeProductsServiceMachine extends StatefulWidget {
  const SwitchTypeProductsServiceMachine({
    super.key,
  });

  @override
  State<SwitchTypeProductsServiceMachine> createState() => _SwitchTypeProductsServiceMachineState();
}

class _SwitchTypeProductsServiceMachineState extends State<SwitchTypeProductsServiceMachine> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 1,
              color: AppColors.posScreenSeparator,
            ),
          ),
          const Row(
            children: [
              ReportCategorySelector(title: 'Products',),
              ReportCategorySelector(title: 'Services',),

            ],
          )
        ],
      ),
    );
  }
}

class ReportCategorySelector extends StatelessWidget {
  final String title;
  const ReportCategorySelector({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child){
        return Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                pos.switchProductServiceReports(title);
                },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(title,
                        style: mainSubHeadingStyle().copyWith(
                            fontWeight: FontWeight.w600,
                            color: pos.selectedProductService == title
                                ? AppColors.posScreenSelectedTextColor
                                : AppColors.textFieldTextColor,
                            fontSize:
                            getWidth(context: context) / 75)),
                  ),
                  verticalSpaceSmall,
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: pos.selectedProductService == title
                          ? AppColors.posScreenSelectedTextColor
                          : Colors.transparent,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },

    );
  }
}

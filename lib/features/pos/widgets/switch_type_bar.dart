import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

class SwitchTypeBar extends StatefulWidget {
  final double size;
  const SwitchTypeBar({
    super.key,
    required this.size
  });

  @override
  State<SwitchTypeBar> createState() => _SwitchTypeBarState();
}

class _SwitchTypeBarState extends State<SwitchTypeBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PosScreenViewModel>(
      builder: (context, pos, child) {
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
              Row(
                children: [
                  Visibility(
                    visible: pos.serviceCategories!.length>1,
                    child: IntrinsicWidth(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            pos.switchProductAndService(1);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Text('Services',
                                    style: mainSubHeadingStyle().copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: pos.productServiceSelected == 1
                                            ? AppColors.posScreenSelectedTextColor
                                            : AppColors.textFieldTextColor,
                                        fontSize:widget.size)),
                              ),
                              verticalSpaceSmall,
                              Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: pos.productServiceSelected == 1
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
                    ),
                  ),
                  horizontalSpaceMedium,
                  Visibility(
                    visible: pos.productCategories!.length>1,
                    child: IntrinsicWidth(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            pos.switchProductAndService(0);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Text('Products',
                                    style: mainSubHeadingStyle().copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: pos.productServiceSelected == 0
                                            ? AppColors.posScreenSelectedTextColor
                                            : AppColors.textFieldTextColor,
                                        fontSize:widget.size)),
                              ),
                              verticalSpaceSmall,
                              Container(
                                height: 3,
                                decoration: BoxDecoration(
                                  color: pos.productServiceSelected == 0
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
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

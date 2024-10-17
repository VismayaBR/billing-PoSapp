import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/features/pos/view_model/pos_screen_view_model.dart';
import 'package:saloon_pos/helper/app_colors.dart';
import 'package:saloon_pos/helper/text_style.dart';
import 'package:saloon_pos/helper/ui_helper.dart';

class SwitchTypeBarReportMachine extends StatefulWidget {
  const SwitchTypeBarReportMachine({
    super.key,
  });

  @override
  State<SwitchTypeBarReportMachine> createState() => _SwitchTypeBarReportMachineState();
}

class _SwitchTypeBarReportMachineState extends State<SwitchTypeBarReportMachine> {
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
              ReportCategorySelector(title: 'Employee-Summary',),
              ReportCategorySelector(title: 'Summary-Billwise',),
              ReportCategorySelector(title: 'Detailed',),
              ReportCategorySelector(title: 'Commission-Daywise',),
              ReportCategorySelector(title: 'Commission-Summary',),
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
                pos.switchReport(title);

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
                            color: pos.selectedReportType == title
                                ? AppColors.posScreenSelectedTextColor
                                : AppColors.textFieldTextColor,
                            fontSize:
                            getWidth(context: context) / 75)),
                  ),
                  verticalSpaceSmall,
                  Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: pos.selectedReportType == title
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

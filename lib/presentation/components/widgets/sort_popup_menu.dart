import 'package:flutter/material.dart';
import 'package:pay_drink/theme/app_colors.dart';
import 'package:pay_drink/theme/text_styles.dart';

enum SortAction { ascending, descending }

class SortPopupMenu extends StatefulWidget {
  final Function(SortAction) onSelected;
  const SortPopupMenu({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<SortPopupMenu> createState() => _SortPopupMenuState();
}

class _SortPopupMenuState extends State<SortPopupMenu> {
  SortAction sortValue = SortAction.descending;
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          shadowColor: Colors.black.withOpacity(0.25),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: PopupMenuButton<SortAction>(
          initialValue: sortValue,
          onSelected: (value) {
            sortValue = value;
            widget.onSelected(sortValue);
          },
          offset: Offset(0, sortValue == SortAction.descending ? 86 : 43),
          elevation: 15,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            side: BorderSide(
              color: AppColors.uiLightGrey,
              width: 1,
            ),
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: SortAction.ascending,
                height: 36,
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    sortValue == SortAction.ascending
                        ? const Icon(Icons.check_rounded)
                        : const SizedBox(
                            width: 12,
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Sort ascending',
                      style: TextStyles.bodyTextTextStyle
                          .copyWith(color: AppColors.uiDarkGrey),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 0,
                  bottom: 10,
                ),
                height: 36,
                value: SortAction.descending,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Divider(
                      color: AppColors.uiLightGrey,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 16,
                        ),
                        sortValue == SortAction.descending
                            ? const Icon(Icons.check_rounded)
                            : const SizedBox(
                                width: 12,
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Sort_descending',
                          style: TextStyles.bodyTextTextStyle
                              .copyWith(color: AppColors.uiDarkGrey),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ];
          },
          child: const Icon(Icons.more_horiz_rounded),
        ));
  }
}

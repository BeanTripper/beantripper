import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/presentation/pages/login/widget/agreement_modal.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';

class PolicyPrivacy extends StatelessWidget {
  const PolicyPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return AgreementModal();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        );
      },
      child: Container(
        height: 50,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 21,
              width: 21,
              decoration: BoxDecoration(
                  color: CustomColors.white,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(Icons.check, size: 19, color: CustomColors.brown),
            ),
            SizedBox(width: 8),
            // flutter package easy_rich_text 사용!
            EasyRichText(
              '로그인을 클릭하면 이용약관 및 개인정보에 동의하는 것으로 간주됩\n니다.',
              defaultStyle: TextStyle(
                fontSize: 11,
                color: CustomColors.lightGray,
              ),
              patternList: [
                EasyRichTextPattern(
                  targetString: '이용약관 및 개인정보',
                  style: TextStyle(color: CustomColors.brown),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

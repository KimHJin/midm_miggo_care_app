import 'package:flutter/material.dart';
import 'package:miggo_care/main.dart';
import 'components/rounded_button.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({Key? key,}) : super(key: key);

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {

  bool isAllChecked = false;
  bool isFirstChecked = false;
  bool isSecondChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromRGBO(59, 130, 197, 1.0)),
        title: const Text("약관 동의", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10.0,),
                Checkbox(
                  value: isAllChecked,
                  onChanged: (value) {
                    setState(() {
                      isAllChecked = value!;
                      isFirstChecked = value!;
                      isSecondChecked = value!;
                    });
                  },
                ),
                const Text('약관에 전체동의', style: TextStyle(fontSize: 20.0),),
              ],
            ),
            const Divider(thickness: 2, indent: 20, endIndent: 20,),
            ListTile(
              leading: Checkbox(
                  value: isFirstChecked,
                  onChanged: (value) {
                    setState(() {
                      isFirstChecked = value!;
                      if(isFirstChecked && isSecondChecked) {
                        isAllChecked = true;
                      } else {
                        isAllChecked = false;
                      }
                    });
                  }
              ),
              title: const Text('(필수)이용약관에 동의', style: TextStyle(fontSize: 13.0),),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FistTermsPage()),
                  );
                },
              ),
            ),
            ListTile(
              leading: Checkbox(
                  value: isSecondChecked,
                  onChanged: (value) {
                    setState(() {
                      isSecondChecked = value!;
                      if(isFirstChecked && isSecondChecked) {
                        isAllChecked = true;
                      } else {
                        isAllChecked = false;
                      }
                    });
                  }
              ),
              title: const Text('(필수)개인정보수집 및 이용에 동의', style: TextStyle(fontSize: 13.0),),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SecondTermsPage()),
                  );
                },
              ),
            ),
            const Spacer(),
            RoundedButton(
            text: '동의하고 진행',
            color: const Color.fromRGBO(59, 130, 197, 1.0),
            textColor: Colors.white,
            press: !isAllChecked ? null : () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Main(pageIndex: 0,)),
                (route) => false);
            },
          ),
          const SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }
}

class FistTermsPage extends StatelessWidget {
  const FistTermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromRGBO(59, 130, 197, 1.0)),
        title: const Text("이용약관", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
      ),
      body: const SingleChildScrollView(
        child: Text(
          '\n'
          '제1장 총칙\n'
          '제2장 이용계약의 성립\n'
          '제3장 서비스의 이용\n'
          '제4장 계약당사자의 의무\n'
          '제5장 계약 해지 및 이용 제한 등\n'
          '제6장 손해배상 등\n'
          '\n'
          '제1장 총칙\n'
          '제1조 [목적]\n'
          '\n'
          '본 약관은 주식회사 미듬(이하 “회사”라고 함)이 제공하는 모든 서비스의 이용조건 및 절차에 관한 사항과 기타 필요한 사항을 전기통신사업법 및 동법 시행령이 정하는 대로 준수하고 규정함을 목적으로 합니다.\n'
          '\n'
          '제2조 [약관의 효력 및 개정]\n'
          '\n'
          '① 이 약관은 이용자에게 공시함으로써 효력이 발생합니다. 이 약관에 동의하고 회원 가입을 한 회원은 약관에 동의한 시점부터 동의한 약관의 적용을 받고, 약관의 변경이 있을 경우에는 변경의 효력이 발생한 시점부터 변경된 약관의 적용을 받습니다.\n'
          '② 회사는 사정 변경의 경우와 영업상 중요 사유가 있을 때 약관을 변경할 수 있으며, 변경된 약관은 전항과 같은 방법으로 효력을 발생합니다.\n'
          '\n'
          '제3조[개인정보보호를 위한 이용자 동의사항]'
          '\n'
          '① 개인정보보호를 위한 이용자 동의사항은 각 항에 규정된 바와 같습니다. 자세한 내용은 개인정보 처리방침을 확인하시기 바랍니다.\n'
          '가. 개인정보 수집, 이용 목적\n'
          '1. 서비스 이용에 따른 본인식별, 실명확인, 가입의사 확인, 연령제한 서비스 이용\n'
          '2. 신규 서비스 등 최신정보 안내 및 개인 맞춤 서비스 제공을 위한 자료\n'
          '3. 고지사항 전달, 의사소통 경로 확보\n'
          '4. 부정이용 방지 및 비인가 사용 방지\n'
          '5. 기타 양질의 서비스 제공 등\n'
          '나. 수집하는 개인 정보의 항목\n'
          '아이디, 비밀번호, 성명, 생년월일, 이메일 주소, 전화번호\n'
          '다. 개인정보의 보유 및 이용기간\n'
          '원칙적으로 개인정보의 수집 또는 제공받은 목적 달성 시 지체 없이 파기 합니다.\n'
          '② 회사는 이용자의 귀책 사유로 인해 노출된 이용자의 계정 정보를 비롯한 모든 정보에 대해서 일체의 책임을 지지 않습니다.\n'
          '③ 회사는 Android 6.0버전 이상을 사용하는 모바일 기기와 Miggo care 어플리케이션과 연동되는 회사 제품 사이에 블루투스 통신 페어링을 돕기 위한 목적으로만 위치정보를 사용할 수 있으며, 회원에 대한 위치정보를 수집, 보관 또는 제3자에게 제공하지 않습니다.\n'
          '\n'
          '제4조 [약관 해석]\n'
          '이 약관에 명시되지 않은 사항이 관계 법령에 규정되어 있을 경우에는 그 규정에 따릅니다. 관계 법령에 규정되어 있지 아니할 경우 회사가 정한 개별 서비스 이용약관이나 운영정책에 따릅니다.\n'
          '\n'
          '제2장 이용계약의 성립\n'
          '제5조 [서비스 이용 신청 및 이용계약의 성립]\n'
          '① 이용 계약은 이용자가 본 약관의 내용에 대하여 동의한 후 이용 신청을 하고, 그 신청한 내용에 대하여 회사가 승낙함으로써 체결됩니다.\n'
          '② 회사의 서비스를 이용하고자 하는 희망자는 회사에서 요청하는 개인 신상정보를 제공해야 합니다.\n'
          '③ 이용자의 이용신청에 대하여 회사가 이를 승인한 경우, 회사는 회원 ID와 기타 회사가 필요하다고 인정하는 내용을 이용자에게 통지합니다.\n'
          '제3장 서비스의 이용\n'
          '제6조 [서비스 이용 및 제한]\n'
          '① 회사는 이용자의 회원 가입을 승낙한 때부터 서비스를 개시합니다.\n'
          '② 서비스 이용은 시스템 정기점검 등 회사가 필요한 경우, 회원에게 사전 통지한 후, 제한할 수 있습니다. 단, 회사가 사전에 통지할 수 없는 치명적인 버그 발생, 서버기기결함, 긴급 보안문제 해결 등의 부득이한 사정이 있는 경우에는 사후에 통지할 수 있습니다.\n'
          '\n'
          '제4장 계약 당사자의 의무\n'
          '제7조 [“회사”의 의무]\n'
          '① 회사는 특별한 사정이 없는 한 회원이 신청한 서비스 제공 개시일에 서비스를 이용할 수 있도록 합니다.\n'
          '② 회사는 이 약관에서 정한 바에 따라 계속적, 안정적으로 서비스를 제공할 의무가 있습니다.\n'
          '③ 회사는 회원으로부터 소정의 절차에 의해 제기되는 의견에 대해서는 적절한 절차를 거쳐 처리하며, 처리 시 일정 기간이 소요될 경우 회원에게 그 사유와 처리 일정을 알려주어야 합니다.\n'
          '④ 회사는 회원의 정보를 철저히 보안 유지하며, 양질의 서비스를 운영하거나 개선하는 데에만 사용하고, 이외의 다른 목적으로 타 기관 및 개인에게 양도하지 않습니다.\n'
          '\n'
          '제8조[“회원”의 의무]\n'
          '① ID와 비밀번호에 관한 모든 관리의 책임은 회원에게 있습니다. 회원의 과실로 인해 ID와 비밀번호가 노출되어 발생하는 피해 및 결과에 대한 책임은 회원에게 있습니다.\n'
          '② 자신의 ID가 부정하게 사용된 경우, 회원은 반드시 회사에 그 사실을 통보해야 합니다.\n'
          '③ 회원은 이 약관 및 관계 법령에서 규정한 사항을 준수하여야 합니다.\n'
          '④ 회원은 본 서비스의 이용을 위해 자신의 개인정보를 성실히 관리해야 하며 입력한 개인 정보에 변동이 있을 경우 이를 변경해야 합니다. 회원의 개인정보변경이 지연되거나 누락되어 발생하는 손해는 회원의 책임으로 합니다.\n'
          '\n'
          '제5장 계약 해지 및 이용 제한 등\n'
          '제9조[계약 해지 및 이용 제한]\n'
          '① 회원은 언제든지 고객센터 또는 회원탈퇴 메뉴 등을 통하여 이용계약을 해지할 수 있습니다.\n'
          '② 회원이 해지 신청을 요청하면 회사는 관련법 등이 정하는 바에 따라 이를 즉시 처리하여야 합니다.\n'
          '③ 가입 해지 여부는 기존의 ID, 비밀번호로 로그인이 되지 않으면 해지된 것이며, 한번 해지된 ID는 기존 사용자라도 사용할 수 없음을 알려드립니다.\n'
          '④ 회사는 회원이 약관의 의무를 위반하거나 서비스의 정상적인 운영을 방해하는 행위를 하였을 경우, 사전 통지 없이 이용 계약을 해지하거나 또는 기간을 정하여 서비스 이용을 중지할 수 있습니다.\n'
          '제10조[이용 제한 및 이용 제한의 해제 절차]\n'
          '① 회사는 이용 제한을 하고자 하는 경우에는 그 사유, 일시 및 기간을 정하여 서면 또는 전화 등의 방법을 통하여 회원 또는 대리인에게 통지합니다.\n'
          '② 다만, 회사가 긴급하게 이용을 중지해야 할 필요가 있다고 인정하는 경우에는 전항의 과정 없이 서비스 이용을 제한할 수 있습니다.\n'
          '③ 제 1항의 규정에 의하여 서비스 이용중지를 통지 받은 회원 또는 그 대리인은 이용 중지에 대하여 이의가 있을 경우 이의 신청을 할 수 있습니다.\n'
          '④ 회사는 이용중지 기간 중에 그 이용중지 사유가 해소된 것이 확인된 경우에 한하여 이용중지 조치를 해제합니다.\n'
          '\n'
          '제6장 손해배상 등\n'
          '제11조[손해배상]\n'
          '① 회원이 본 약관의 규정을 위반함으로 인하여 회사에 손해가 발생하게 되는 경우, 이 약관을 위반한 회원은 회사에 발생하는 모든 손해를 배상하여야 합니다.\n'
          '② 회원이 서비스를 이용함에 있어 행한 불법 행위나 본 약관 위반 행위로 인하여 회사가 당해 회원 이외의 제3자로부터 손해배상 청구 또는 소송을 비롯한 각종 이의 제기를 받는 경우 당해 회원은 자신의 책임과 비용으로 회사를 면책시켜야 하며, 회사가 면책되지 못한 경우 당해 회원은 그로 인하여 회사에 발생한 모든 손해를 배상하여야 합니다.\n'
          '\n'
          '제12조[면책사항]\n'
          '① 회사는 천재지변 또는 이에 준하는 불가항력으로 인하여 서비스를 제공할 수 없는 경우, 기간통신 사업자가 전기통신서비스를 중지하거나 정상적으로 제공하지 아니하여 손해가 발생한 경우, 사전에 공지된 서비스용 설비의 보수, 교체, 정기점검, 공사 등 부득이한 사유로 서비스가 중지되거나 장애가 발생한 경우에 대해서는 서비스 제공에 관한 책임이 면제됩니다.\n'
          '② 회사는 이용자의 귀책사유로 인한 서비스의 중지, 이용장애 또는 계약해지에 대하여 책임을 지지 않습니다.\n'
          '③ 회사는 회원이 서비스를 이용하여 기대하는 수익을 얻지 못한 것에 대하여 책임을 지지 않으며 서비스에 대한 취사 선택 또는 이용으로 발생하는 손해 등에 대해서는 책임이 면제됩니다.\n'
          '④ 회사는 회원의 컴퓨터 환경으로 인하여 발생하는 제반 문제 또는 회사의 귀책사유가 없는 네트워크 환경으로 인하여 발생하는 문제에 대해서는 책임이 면제됩니다.\n'
          '⑤ 회사는 이용자 상호간 또는 이용자와 제3자간에 서비스를 매개로 발생한 분쟁에 대해 개입할 의무가 없으며 이로 인한 손해를 배상할 책임을 지지 않습니다.\n'
          '\n'
          '제13조[준거법 및 관할법원]\n'
          '① 회사와 이용자간에 제기된 소송에는 대한민국 법을 적용합니다.\n'
          '② 서비스 이용과 관련하여 회사와 회원 간에 이견 또는 분쟁이 있는 경우, 양 당사자간의 합의에 의해 원만히 해결하여야 합니다.\n'
          '③ 만약 제1항의 분쟁이 원만히 해결되지 못하여 소송이 제기된 경우, 소송은 서울중앙지방법원을 관할 법원으로 합니다.\n'
          '\n'
          '제14조 [고지]\n'
          '약관은 2023년 00월 00일부터 적용됩니다.\n'
        ),
      ),
    );
  }
}

class SecondTermsPage extends StatelessWidget {
  const SecondTermsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color.fromRGBO(59, 130, 197, 1.0)),
        title: const Text("개인정보수집 및 이용", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
      ),
      body: const SingleChildScrollView(
        child: Text(
          '개인정보수집 및 이용에 대한 동의서\n'
          '\n'
          '주식회사 미듬은 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 개인정보보호법, 통신비밀보호법에 준수하여야 할 관련 법령상의 개인정보보호 규정을 준수하며, 관련 법령에 의거하여 개인정보 취급 방침을 정하여 사용자의 권익 보호에 최선을 다합니다.\n'
          '본 기관(업체)의 서비스 제공에 필요한 검사를 수행하기 위하여 아래와 같이 개인정보를 수집 및 이용합니다.\n'
          '1. 수집항목 :\n'
          '- (필수사항) 회원 계정(아이디,비밀번호)\n'
          '- (선택사항) 사용 제품(연동), 이름, 나이, 키, 몸무게, 성별\n'
          '2. 수집목적 : 혈압 측정 결과 및 관련 서비스 제공\n'
          '3. 보유기간 : 삭제 요청 시 까지\n'
          '\n'
          '※ 위와 같이 개인정보를 수집 및 이용하는데 동의를 거부할 권리가 있습니다. 동의를 거부할 경우 일부 서비스 제공이 제한될 수 있습니다.\n'
          '\n'
          '※ 또한, 수집 및 이용하고자 하는 개인정보의 정보주체가 만14세 미만의 아동이라면 반드시 법정대리인의 동의를 받아야 합니다. 이 경우 법정대리인의 성명, 연락처 등 동의를 받기 위해 필요한 최소한의 개인정보는 법정대리인의 동의 없이 해당 아동으로부터 수집 가능합니다.\n'
          '\n'
          '※ 개인정보처리방침은 당사 홈페이지(midm.co.kr)을 참조바랍니다.\n'
          '\n'
          '※ 고객 문의사항은 당사 홈페이지(www.midm.co.kr) 및 고객센터(T.02-2088-7974)로 연락바랍니다.\n'
        ),
      ),
    );
  }
}

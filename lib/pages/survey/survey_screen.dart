import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pudez_street_playground/common/components/my_text_button.dart';
import 'package:pudez_street_playground/common/data/booth_list.dart';
import 'package:pudez_street_playground/common/style/color.dart';
import 'package:pudez_street_playground/pages/survey/survey_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  final PageController pageController = PageController();
  List<String?> answerList = List.generate(7, (_) => null);
  int selectIndex = 0;

  late List<SurveyModel> surveyList = [
    SurveyModel(
      question: '이 곳이 원래 주차 공간이었다는 걸\n알고 있었나요? ',
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: SurveyButton(
                  onPressed: () {
                    setState(() {
                      answerList[0] = '네';
                      selectIndex = 1;
                      toNextPage();
                    });
                  },
                  text: '네',
                  selected: selectIndex == 1,
                ),
              ),
              Gap(8),
              SizedBox(
                height: 100,
                child: SurveyButton(
                  onPressed: () {
                    setState(() {
                      answerList[0] = '아니요';
                      selectIndex = 2;
                      toNextPage();
                    });
                  },
                  text: '아니요',
                  selected: selectIndex == 2,
                ),
              ),
            ],
          );
        },
      ),
    ),
    SurveyModel(
      question: '주차장 대신 골목 놀이터가 있으니\n어떤가요?',
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                child: SurveyButton(
                  onPressed: () {
                    setState(() {
                      answerList[1] = '좋아요';
                      selectIndex = 1;
                      toNextPage();
                    });
                  },
                  text: '좋아요',
                  selected: selectIndex == 1,
                ),
              ),
              Gap(8),
              SizedBox(
                height: 80,
                child: SurveyButton(
                  onPressed: () {
                    setState(() {
                      answerList[1] = '안좋아요';
                      selectIndex = 2;
                      toNextPage();
                    });
                  },
                  text: '안좋아요',
                  selected: selectIndex == 2,
                ),
              ),
              Gap(8),
              SizedBox(
                height: 80,
                child: SurveyButton(
                  onPressed: () {
                    setState(() {
                      answerList[2] = '잘 모르겠어요';
                      selectIndex = 3;
                      toNextPage();
                    });
                  },
                  text: '잘 모르겠어요',
                  selected: selectIndex == 3,
                ),
              ),
            ],
          );
        },
      ),
    ),
    SurveyModel(
      question: '골목놀이터에 재미있게 참여했나요?',
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: SurveyButton(
                  onPressed: () {
                    setState(() {
                      answerList[2] = '재밌었어요';
                      selectIndex = 1;
                      toNextPage();
                    });
                  },
                  text: '재밌었어요',
                  selected: selectIndex == 1,
                ),
              ),
              Gap(8),
              SizedBox(
                height: 100,
                child: SurveyButton(
                  onPressed: () {
                    setState(() {
                      answerList[2] = '별로였어요';
                      selectIndex = 2;
                      toNextPage();
                    });
                  },
                  text: '별로였어요',
                  selected: selectIndex == 2,
                ),
              ),
            ],
          );
        },
      ),
    ),
    SurveyModel(
      question: '가장 기억에 남는 체험은 무엇인가요?',
      child: StatefulBuilder(
        builder: (context, setState) {
          return ListView.separated(
            padding: EdgeInsets.only(bottom: 34),
            itemCount: boothList.length,
            separatorBuilder: (context, index) => Gap(4),
            itemBuilder: (context, index) {
              return SurveyButton(
                onPressed: () {
                  setState(() {
                    answerList[3] = boothList[index].name;
                    selectIndex = 1;
                    toNextPage();
                  });
                },
                text: boothList[index].name,
                selected: answerList[3] == boothList[index].name,
              );
            },
          );
        },
      ),
    ),
    SurveyModel(
      question: '골목놀이터에서 하고 싶은 활동이\n있다면 무엇인가요?',
      child: StatefulBuilder(
        builder: (context, setState) {
          final textController = TextEditingController();
          return Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: TextField(
                    controller: textController,
                    maxLines: null, // 텍스트 필드가 여러 줄을 지원하도록 설정
                    expands: true, // TextField가 부모의 높이를 채우도록 설정
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: 16,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: '자유롭게 이야기 해주세요.',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: textGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: border),
                      ),
                    ),
                  ),
                ),
              ),
              Gap(20),
              MyTextButton(
                onPressed: () {
                  answerList[4] = textController.text;
                  toNextPage();
                },
                text: "다음",
              ),
              Gap(16),
            ],
          );
        },
      ),
    ),
    SurveyModel(
      question: '다음에 또 참여하고 싶은가요?',
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                child: SurveyButton(
                  onPressed: () {
                    setState(() {
                      answerList[5] = '네';
                      selectIndex = 1;
                      toNextPage();
                    });
                  },
                  text: '네',
                  selected: selectIndex == 1,
                ),
              ),
              Gap(8),
              SizedBox(
                height: 100,
                child: SurveyButton(
                  onPressed: () {
                    setState(() {
                      answerList[5] = '아니요';
                      selectIndex = 2;
                      toNextPage();
                    });
                  },
                  text: '아니요',
                  selected: selectIndex == 2,
                ),
              ),
            ],
          );
        },
      ),
    ),
    SurveyModel(
      question: '마지막으로 하고 싶은 말',
      child: StatefulBuilder(
        builder: (context, setState) {
          final textController = TextEditingController();
          return Column(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  child: TextField(
                    controller: textController,
                    maxLines: null, // 텍스트 필드가 여러 줄을 지원하도록 설정
                    expands: true, // TextField가 부모의 높이를 채우도록 설정
                    textAlignVertical: TextAlignVertical.top,
                    style: TextStyle(
                      fontSize: 16,
                      color: textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: '좋았던 점, 아쉬운 점 모두 좋아요!',
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: textGrey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: border),
                      ),
                    ),
                  ),
                ),
              ),
              Gap(20),
              MyTextButton(
                onPressed: () {
                  answerList[6] = textController.text;
                  toFinish();
                },
                text: "완료",
              ),
              Gap(16),
            ],
          );
        },
      ),
    ),
  ];

  toNextPage() {
    Future.delayed(Duration(milliseconds: 1000), () {
      selectIndex = 0;
      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    });
  }

  // 모든 설문조사 완료
  toFinish() async {
    // 사용자 이름 호출
    final username = await asyncPrefs.getString('name');
    try {
      // 데이터 저장 API 호출
      final response = await http.post(
        Uri.parse('https://pudez-street-playground.dev-ksanbal.workers.dev'),
        body: json.encode({
          "username": username,
          "answers": answerList.map((e) => e ?? '').toList(),
        }),
      );

      if (response.statusCode != 200) {
        // 오류 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('설문조사 제출에 실패했습니다. 다시 시도해주세요.'),
          ),
        );
      } else {
        // 응답 저장
        await asyncPrefs.setBool('surveryComplete', true);

        // 페이지 이동
        context.go('/gift');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: answerList.where((e) => e != null).length / answerList.length,
            backgroundColor: bgGrey,
            color: key,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PageView.builder(
                controller: pageController,
                itemCount: surveyList.length,
                itemBuilder: (context, index) {
                  return SurveyCard(
                    index: index + 1,
                    question: surveyList[index].question,
                    child: surveyList[index].child,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SurveyCard extends StatelessWidget {
  const SurveyCard({
    super.key,
    required this.index,
    required this.question,
    required this.child,
  });

  final int index;
  final String question;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(24),
        Text(
          'Q$index',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: key,
          ),
        ),
        Gap(4),
        Text(
          question,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        Gap(80),
        Expanded(child: child),
      ],
    );
  }
}

class SurveyButton extends StatelessWidget {
  const SurveyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.selected = false,
  });

  final Function()? onPressed;
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? keySecond : bgGrey,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? key : border,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: selected ? key : textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

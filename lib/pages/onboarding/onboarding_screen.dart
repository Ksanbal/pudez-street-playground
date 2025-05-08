import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pudez_street_playground/common/components/my_text_button.dart';
import 'package:pudez_street_playground/common/style/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  final pageController = PageController();
  int currentPage = 0;

  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });

    // 이름이 저장되어 있으면 홈 화면으로 이동
    asyncPrefs.getString('name').then((value) {
      if (value != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/');
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    nameController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(
          children: [
            // 페이지뷰
            Expanded(
              child: PageView(
                controller: pageController,
                children: [
                  const OnboardingItem(
                    title: '골목놀이터에 오신걸 환영해요!\n목감종합사회복지관과 퍼디즈가 함께해요',
                    imageProvider: NetworkImage('https://picsum.photos/640/640?random=1'),
                  ),
                  const OnboardingItem(
                    title: '오늘 활동 중 생긴 쓰레기는\n나눠준 봉투에 넣어주세요',
                    imageProvider: NetworkImage('https://picsum.photos/640/640?random=2'),
                  ),
                  const OnboardingItem(
                    title: '15개 부스 중 체험존, 놀이존 각각\n3개를 마치고, 7번 부스로 오세요',
                    imageProvider: NetworkImage('https://picsum.photos/640/640?random=3'),
                  ),
                  const OnboardingItem(
                    title: '모아온 쓰레기로 게임에 참여하면\n선물을 받을 수 있어요!',
                    imageProvider: NetworkImage('https://picsum.photos/640/640?random=4'),
                  ),
                  OnboardingNameInput(
                    formKey: formKey,
                    nameController: nameController,
                  ),
                ],
              ),
            ),
            const Gap(10),
            // 페이지뷰 인디케이터
            if (currentPage != 4)
              SmoothPageIndicator(
                controller: pageController,
                count: 4,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: textPrimary,
                  dotColor: textGrey,
                ),
              ),
            const Gap(60),
            // 버튼
            Row(
              children: [
                ...currentPage == 0
                    ? []
                    : [
                        Expanded(
                          child: MyTextButton(
                            onPressed: () {
                              // 이전 페이지로 이동
                              pageController.previousPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeIn,
                              );
                            },
                            text: "이전",
                            backgroundColor: textGrey,
                          ),
                        ),
                        const Gap(9),
                      ],
                Expanded(
                  child: MyTextButton(
                    onPressed: () {
                      if (currentPage == 4) {
                        // 이름 입력 후 다음 페이지로 이동
                        if (formKey.currentState!.validate()) {
                          context.go('/');
                          asyncPrefs.setString('name', nameController.text);
                        }
                      } else {
                        // 다음 페이지로 이동
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    text: "다음",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    super.key,
    required this.title,
    required this.imageProvider,
  });

  final String title;
  final ImageProvider<Object> imageProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Gap(60),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const Gap(40),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ExtendedImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingNameInput extends StatelessWidget {
  const OnboardingNameInput({
    super.key,
    required this.formKey,
    required this.nameController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Gap(60),
        const Text(
          "이름을 알려주세요!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textPrimary,
          ),
        ),
        const Gap(40),
        Expanded(
          child: Center(
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "이름을 입력해주세요.";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 20,
                  color: textPrimary,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 8,
                  ),
                  hintText: "홍길동",
                  hintStyle: const TextStyle(
                    fontSize: 20,
                    color: textGrey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: textGrey,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

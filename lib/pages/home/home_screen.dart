import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pudez_street_playground/common/components/map_dialog.dart';
import 'package:pudez_street_playground/common/components/qr_dialog.dart';
import 'package:pudez_street_playground/common/data/booth_list.dart';
import 'package:pudez_street_playground/common/style/color.dart';
import 'package:pudez_street_playground/pages/home/booth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();
  final ValueNotifier<List<BoothModel>> boothListNotifier = ValueNotifier(List.from(boothList));

  @override
  void initState() {
    super.initState();

    loadBoothList();
  }

  // 부스 조건 달성 조건 확인
  bool isCompleteBooth() {
    // 7번 퍼디즈 제외 활성화된 부스가 놀이 3개, 체험 3개면 이상이면
    final playCount = getPlayCount();
    final experienceCount = getExperienceCount();

    return playCount >= 3 && experienceCount >= 3;
  }

  // 참여한 놀이 부스 수
  int getPlayCount() {
    return boothList
        .where(
          (booth) => booth.id != 7 && booth.isActive && booth.boothType == '놀이',
        )
        .length;
  }

  // 참여한 체험 부스 수
  int getExperienceCount() {
    return boothList
        .where(
          (booth) => booth.id != 7 && booth.isActive && booth.boothType == '체험',
        )
        .length;
  }

  // 부스 리스트 상태 저장 및 불러오기
  loadBoothList() async {
    final data = await asyncPrefs.getString('boothList');
    if (data == null) {
      // boothList 상태 저장
      asyncPrefs.setString('boothList', json.encode(boothList));
    } else {
      // boothList 상태 불러오기
      final List<dynamic> jsonData = json.decode(data);
      for (int i = 0; i < jsonData.length; i++) {
        updateBooth(i, BoothModel.fromJson(jsonData[i]));
      }
    }
  }

  // 부스 정보 저장
  void updateBooth(int index, BoothModel updatedBooth) {
    final updatedList = List<BoothModel>.from(boothListNotifier.value);
    updatedList[index] = updatedBooth;
    boothListNotifier.value = updatedList; // 값 업데이트

    // 상태 저장
    asyncPrefs.setString('boothList', json.encode(boothList));

    if (isCompleteBooth()) {
      if (updatedBooth.id == 7 && updatedBooth.isActive) {
        context.push('/survey');
      } else {
        showMissionComplete();
      }
    }
  }

  // QR 인식창 띄우기
  void showQrScanner() async {
    // QR 인식창 띄우는 로직
    try {
      final value = await showModalBottomSheet<String?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(8),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: white,
        builder: (BuildContext context) {
          return QrDialog();
        },
      );

      if (value != null) {
        int index = int.parse(value) - 1;
        updateBooth(
          index,
          boothList[index].copyWith(
            isActive: true,
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${boothList[index].name} 부스에 참여했어요!',
              style: TextStyle(color: white),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle error
      print('Error showing QR scanner: $e');
    }
  }

  // 부스 안내도 dialog 노출
  void showMap() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MapDialog();
      },
    );
  }

  // 미션 달성 안내 dialog 노출
  void showMissionComplete() {
    showModalBottomSheet<String?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      backgroundColor: white,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                        color: textPrimary,
                      ),
                      Gap(12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "미션 성공 - 선물을 받을 수 있어요!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "6개 부스를 참여했어요! 7번 부스로 이동하세요!",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: context.pop,
                  child: Icon(
                    Icons.close,
                    color: textSecond,
                    size: 24,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // 선물 버튼 클릭
  onTapGiftButton() async {
    // 참여조건이 부족하면
    if (!isCompleteBooth()) {
      final playCount = getPlayCount();
      final experienceCount = getExperienceCount();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '놀이 부스 ${3 - playCount}개, 체험 부스 ${3 - experienceCount}개 남았어요!',
            style: TextStyle(color: white),
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    // 퍼디즈 부스가 완료되지 않았으면 7번 부스 참여
    if (!boothList[6].isActive) {
      showMissionComplete();
      return;
    }

    // 설문조사 기록 조회
    final surveryComplete = await asyncPrefs.getBool('surveryComplete');
    if (surveryComplete == null || !surveryComplete) {
      // 설문조사 기록이 없으면 설문조사 페이지로 이동
      context.push('/survey');
    } else {
      // 선물 페이지로 이동
      context.push('/gift');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: IconButton(
          icon: const Icon(Icons.map_outlined),
          onPressed: showMap,
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.gift),
            onPressed: onTapGiftButton,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: key,
        shape: const CircleBorder(),
        onPressed: showQrScanner,
        child: const Icon(
          Icons.qr_code_scanner_rounded,
          color: white,
          size: 36,
        ),
      ),
      body: ValueListenableBuilder<List<BoothModel>>(
        valueListenable: boothListNotifier,
        builder: (context, boothList, _) {
          return ListView.separated(
            itemCount: boothList.length,
            separatorBuilder: (_, __) => Divider(
              height: 0,
              color: border,
            ),
            itemBuilder: (_, index) => BoothCard(
              totalIndex: boothList.length,
              index: index,
              booth: boothList[index],
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              96,
            ),
          );
        },
      ),
    );
  }
}

class BoothCard extends StatelessWidget {
  const BoothCard({
    super.key,
    required this.totalIndex,
    required this.index,
    required this.booth,
  });

  final int totalIndex;
  final int index;
  final BoothModel booth;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      childrenPadding: EdgeInsets.only(
        left: 40,
        bottom: 14,
      ),
      expandedAlignment: Alignment.centerLeft,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      tilePadding: EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      dense: true,
      visualDensity: VisualDensity.compact,
      collapsedShape: RoundedRectangleBorder(
        side: BorderSide(
          color: border,
          width: 1,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(index == 0 ? 8 : 0),
          bottom: Radius.circular(index == totalIndex - 1 ? 8 : 0),
        ),
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: border,
          width: 1,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(index == 0 ? 8 : 0),
          bottom: Radius.circular(index == totalIndex - 1 ? 8 : 0),
        ),
      ),
      title: Row(
        children: [
          booth.isActive
              ? Icon(
                  Icons.check_circle,
                  color: textPrimary,
                  size: 20,
                )
              : Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bgGrey,
                    border: Border.all(
                      color: border,
                      width: 1.67,
                    ),
                  ),
                ),
          Gap(6),
          Flexible(
            child: Text(
              '${booth.id} - ${booth.name}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(6),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 6,
            ),
            decoration: BoxDecoration(
              color: bgGrey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                booth.boothType,
                style: TextStyle(
                  fontSize: 12,
                  color: booth.boothType == '체험' ? sky : pink,
                ),
              ),
            ),
          ),
        ],
      ),
      children: [
        Text(
          '${booth.teamName}\n${booth.description}',
          style: TextStyle(
            fontSize: 14,
            color: textGrey,
          ),
        ),
      ],
    );
  }
}

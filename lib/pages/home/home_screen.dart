import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    asyncPrefs.setString('boothList', json.encode(updatedList)); // 상태 저장
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
      }
    } catch (e) {
      // Handle error
      print('Error showing QR scanner: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        leading: IconButton(
          icon: const Icon(Icons.map_outlined),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.gift),
            onPressed: () {},
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
              booth.name,
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

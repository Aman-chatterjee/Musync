import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musync/core/theme/app_pallete.dart';
import 'package:musync/core/utils.dart';
import 'package:musync/core/widgets/custom_field.dart';
import 'package:musync/core/widgets/loader.dart';
import 'package:musync/features/home/view/viewmodel/home_viewmodel.dart';
import 'package:musync/features/home/view/widgets/audio_wave.dart';

class UploadMusicPage extends ConsumerStatefulWidget {
  const UploadMusicPage({super.key});

  @override
  ConsumerState<UploadMusicPage> createState() => _UploadMusicPageState();
}

class _UploadMusicPageState extends ConsumerState<UploadMusicPage> {
  final musicNameController = TextEditingController();
  final artistNameController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    musicNameController.dispose();
    artistNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(homeViewModelProvider, (_, next) {
      next?.when(
          data: (data) {
            showSnackBar(context, 'Upload successful');
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Music'),
        actions: [
          IconButton(
              onPressed: () async {
                if (formKey.currentState!.validate() &&
                    selectedAudio != null &&
                    selectedAudio != null) {
                  await ref.read(homeViewModelProvider.notifier).uploadMusic(
                        selectedAudio: selectedAudio!,
                        selectedImage: selectedImage!,
                        musicName: musicNameController.text,
                        artistName: artistNameController.text,
                        selectedColor: selectedColor,
                      );
                } else {
                  showSnackBar(context, 'Missing Fields!');
                }
              },
              icon: Icon(Icons.check))
        ],
        centerTitle: true,
        leading: BackButton(),
      ),
      body: isLoading
          ? Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: selectImage,
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  height: 180,
                                  width: double.infinity,
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : DottedBorder(
                                color: Pallete.borderColor,
                                dashPattern: [10, 4],
                                borderType: BorderType.RRect,
                                strokeWidth: 1,
                                strokeCap: StrokeCap.round,
                                radius: Radius.circular(10),
                                child: SizedBox(
                                  height: 180,
                                  width: double.infinity,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open_rounded,
                                        size: 40,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Select the thumbnail for your music',
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 40),
                      selectedAudio != null
                          ? AudioWave(audioPath: selectedAudio!.path)
                          : CustomField(
                              hintText: 'Pick Music',
                              controller: null,
                              isReadOnly: true,
                              onTap: () {
                                selectAudio();
                              }),
                      SizedBox(height: 20),
                      CustomField(
                          hintText: 'Music Name',
                          validator: (val) => nullCheck(val, 'Music Name'),
                          controller: musicNameController,
                          isReadOnly: false),
                      SizedBox(height: 20),
                      CustomField(
                          hintText: 'Artist Name',
                          controller: artistNameController,
                          validator: (val) => nullCheck(val, 'Artist Name'),
                          isReadOnly: false),
                      SizedBox(height: 20),
                      ColorPicker(
                          pickersEnabled: {ColorPickerType.wheel: true},
                          color: selectedColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              selectedColor = color;
                            });
                          })
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

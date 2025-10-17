import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/bloc/course/course_bloc.dart';
import 'package:e_learning/bloc/course/course_event.dart';
import 'package:e_learning/models/course.dart';
import 'package:e_learning/models/prerequisite_course.dart';
import 'package:e_learning/repositories/course_repository.dart';
import 'package:e_learning/services/cloudinary_service.dart';
import 'package:e_learning/view/onboarding/widgets/common/custom_textfield.dart';
import 'package:e_learning/view/teacher/create_course/widgets/create_course_app_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_color.dart';
import '../../../models/lesson.dart';

class CreateCourseScreen extends StatefulWidget {
  final Course? course;

  const CreateCourseScreen({super.key, this.course});

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLevel = 'Beginner';
  bool _isPremium = false;
  final List<String> _requirements = [''];
  final List<String> _learningPoints = [''];
  final _courseRepository = CourseRepository();
  final _cloudinaryService = CloudinaryService();
  final _imagePicker = ImagePicker();
  final _firestore = FirebaseFirestore.instance;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedCategoryName;
  final List<Lesson> _lessons = [];
  String? _courseImagePath;
  String? _courseImageUrl;
  bool _isLoading = false;
  List<Map<String, dynamic>> _categories = [];
  bool _isUploadingImage = false;
  Map<int, bool> _isUploadingVideo = {};
  Map<int, bool> _isUploadingResource = {};
  List<PrerequisiteCourse> _availableCourses = [
    PrerequisiteCourse(id: '1', title: 'Flutter Fundamentals'),
    PrerequisiteCourse(id: '2', title: 'Dart Pro Language'),
    PrerequisiteCourse(id: '3', title: 'Mobile App Development'),
  ];
  List<String> _selectedPrerequisites = [];
  Map<int, VideoPlayerController?> _videoControllers = {};
  Map<int, ChewieController?> _chewieControllers = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadAvailableCourses();
    if (widget.course != null) {
      _initializeCourseData();
    }
  }

  void _initializeCourseData() {
    final course = widget.course!;
    _titleController.text = course.title;
    _descriptionController.text = course.description;
    _priceController.text = course.price.toString();
    _selectedLevel = course.level;
    _selectedCategoryId = course.categoryID;
    _isPremium = course.isPremium;
    _requirements.clear();
    _requirements.addAll(course.requirements);
    _learningPoints.clear();
    _learningPoints.addAll(course.whatYouWillLearn);
    _lessons.clear();
    _lessons.addAll(course.lessons);
    _courseImageUrl = course.imageUrl;
    _selectedPrerequisites.clear();
    _selectedPrerequisites.addAll(course.prerequisites);
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      setState(() {
        _categories = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id,
            'name': data['name'] as String,
            'icon': data['icon'] as String,
          };
        }).toList();
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadAvailableCourses() async {
    try {
      final snapshot = await _firestore.collection('courses').get();
      setState(() {
        _availableCourses = snapshot.docs.map((doc) {
          final data = doc.data();
          return PrerequisiteCourse(id: doc.id, title: data['title'] as String);
        }).toList();
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load courses: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    //dispose video controller
    for (var controller in _videoControllers.values) {
      controller?.dispose();
    }
    for (var controller in _chewieControllers.values) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CreateCourseAppBar(onSubmit: _submitForm, course: widget.course),
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildImagePicker(),
                        const SizedBox(height: 32),
                        CustomTextfield(
                          controller: _titleController,
                          label: 'Course Title',
                          hint: 'Enter course title',
                          maxLines: 1,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomTextfield(
                          controller: _descriptionController,
                          label: 'Description',
                          hint: 'Enter course description',
                          maxLines: 3,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextfield(
                                controller: _priceController,
                                label: 'Price',
                                hint: 'Enter price',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: _buildDropDown()),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildCategoryDropdown(),
                        const SizedBox(height: 24),
                        _buildPremiumSwitch(),
                        const SizedBox(height: 24),
                        _buildPrerequisitesDropdown(),
                        const SizedBox(height: 32),
                        _buildDynamicList(
                          'Course Requirements',
                          _requirements,
                          (index) => _requirements.removeAt(index),
                          () => _requirements.add(''),
                        ),
                        const SizedBox(height: 32),
                        _buildDynamicList(
                          'What You Will Learn',
                          _learningPoints,
                          (index) => _requirements.removeAt(index),
                          () => _requirements.add(''),
                        ),
                        const SizedBox(height: 32),
                        _buildLessonSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Course Lessons',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            TextButton.icon(
              onPressed: _addLesson,
              icon: const Icon(Icons.add),
              label: const Text('Add Lesson'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _lessons.length,
          itemBuilder: (context, index) {
            return _buildLessonCard(_lessons[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildLessonCard(Lesson lesson, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lesson ${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text('Preview'),
                    Switch(
                      value: lesson.isPreview,
                      onChanged: (value) =>
                          _updateLesson(index, isPreview: value),
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _removeLesson(index),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            const SizedBox(height: 8),
            CustomTextfield(
              label: 'Lesson Title',
              hint: 'Enter lesson title',
              initialValue: lesson.title,
              onChanged: (value) => _updateLesson(index, title: value),
            ),
            const SizedBox(height: 8),
            CustomTextfield(
              label: 'Lesson Description',
              hint: 'Enter lesson description',
              maxLines: 2,
              initialValue: lesson.description,
              onChanged: (value) => _updateLesson(index, description: value),
            ),
            const SizedBox(height: 8),
            CustomTextfield(
              label: 'Duration (minutes)',
              hint: 'Enter duration',
              initialValue: lesson.duration.toString(),
              keyboardType: TextInputType.number,
              onChanged: (value) => _updateLesson(
                index,
                duration: int.tryParse(value ?? '0') ?? 0,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploadingVideo[index] == true
                        ? null
                        : () => _pickVideo(index),
                    icon: _isUploadingVideo[index] == true
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.video_library),
                    label: Text(
                      _isUploadingVideo[index] == true
                          ? 'Uploading...'
                          : lesson.videoUrl.isEmpty
                          ? 'Add Video'
                          : 'Change Video',
                    ),
                  ),
                ),
              ],
            ),
            // add video preview if available
            if (lesson.videoUrl.isNotEmpty)
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final aspectRation =
                      _videoControllers[index]?.value.aspectRatio ?? 16 / 9;
                  final height = maxWidth / aspectRation;

                  return Container(
                    width: maxWidth,
                    height: height.clamp(
                      200,
                      MediaQuery.of(context).size.height * 0.4,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _chewieControllers[index] != null
                          ? Chewie(controller: _chewieControllers[index]!)
                          : const Center(child: CircularProgressIndicator()),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            const Text(
              'Resource',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lesson.resources.length,
              itemBuilder: (context, resourceIndex) {
                final resource = lesson.resources[resourceIndex];
                return ListTile(
                  title: Text(resource.title),
                  subtitle: Text(resource.type),
                  trailing: IconButton(
                    onPressed: () => _removeResource(index, resourceIndex),
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
            TextButton.icon(
              onPressed: _isUploadingResource[index] == true
                  ? null
                  : () => _addResource(index),
              icon: _isUploadingResource[index] == true
                  ? const SizedBox(height: 20, width: 20)
                  : const Icon(Icons.add),
              label: Text(
                _isUploadingResource[index] == true
                    ? 'Uploading...'
                    : 'Add Resource',
              ),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addResource(int lessonIndex) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _isUploadingResource[lessonIndex] = true;
        });
        final file = result.files.first;
        final resourceUrl = await _cloudinaryService.uploadFile(file.path!);
        final resource = Resource(
          id: const Uuid().v4(),
          title: file.name,
          type: file.extension ?? 'unknown',
          url: resourceUrl,
        );
        setState(() {
          final updatedResources = List<Resource>.from(
            _lessons[lessonIndex].resources,
          )..add(resource);
          _updateLesson(lessonIndex, resource: updatedResources);
          _isUploadingResource[lessonIndex] = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploadingResource[lessonIndex] = false;
      });
      Get.snackbar(
        'Error',
        'Failed to add resource: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _removeResource(int lessonIndex, int resourceIndex) {
    setState(() {
      final updatedResources = List<Resource>.from(
        _lessons[lessonIndex].resources,
      );
      _updateLesson(lessonIndex, resource: updatedResources);
    });
  }

  Future<void> _pickVideo(int lessonIndex) async {
    try {
      final pickedFile = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _isUploadingVideo[lessonIndex] = true;
        });
        //upload video to cloudinary
        final videoUrl = await _cloudinaryService.uploadVideo(pickedFile.path);

        //upload lesson with new video URL
        setState(() {
          _lessons[lessonIndex] = _lessons[lessonIndex].copyWith(
            videoUrl: videoUrl,
          );
        });
        //initialize video player after successful upload
        await _initializeVideoPlayer(lessonIndex, videoUrl);

        setState(() {
          _isUploadingVideo[lessonIndex] = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploadingVideo[lessonIndex] = false;
      });
      Get.snackbar(
        'Error',
        'Failed to pick video: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _initializeVideoPlayer(int lessonIndex, String videoUrl) async {
    try {
      //dispose existing controllers if any
      _videoControllers[lessonIndex]?.dispose();
      _chewieControllers[lessonIndex]?.dispose();

      //create and initialize video player controller
      final videoController = VideoPlayerController.network(videoUrl);
      await videoController.initialize();

      //calculate aspect ration based on video dimensions
      final aspectRation = videoController.value.aspectRatio;

      //create chewie controller
      final chewieController = ChewieController(
        videoPlayerController: videoController,
        autoPlay: false,
        looping: false,
        aspectRatio: aspectRation,
        allowFullScreen: true,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        allowMuting: true,
        showControls: true,
        placeholder: Container(color: Colors.black),
        errorBuilder: (context, errorMessage) {
          return const Center(
            child: Text(
              'Error: Unable to load video content',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      );
      if (mounted) {
        setState(() {
          _videoControllers[lessonIndex] = videoController;
          _chewieControllers[lessonIndex] = chewieController;
        });
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to initialize player: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void _removeLesson(int index) {
    setState(() {
      //dispose video controllers when removing lesson
      _videoControllers[index]?.dispose();
      _chewieControllers[index]?.dispose();
      _videoControllers.remove(index);
      _chewieControllers.remove(index);
      _lessons.removeAt(index);
    });
  }

  void _updateLesson(
    int index, {
    String? title,
    String? description,
    String? videoUrl,
    int? duration,
    List<Resource>? resource,
    bool? isPreview,
  }) {
    setState(() {
      _lessons[index] = _lessons[index].copyWith(
        title: title,
        description: description,
        videoUrl: videoUrl,
        duration: duration,
        resources: resource,
        isPreview: isPreview,
      );
    });
  }

  void _addLesson() {
    setState(() {
      _lessons.add(
        Lesson(
          id: const Uuid().v4(),
          title: '',
          videoUrl: '',
          description: '',
          duration: 0,
          resources: [],
          isPreview: false,
        ),
      );
    });
  }

  Widget _buildPrerequisitesDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prerequisites',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text('Select Prerequisites'),
              value: null,
              items: _availableCourses.map<DropdownMenuItem<String>>((course) {
                return DropdownMenuItem(
                  value: course.id,
                  child: Text(course.title),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null &&
                    !_selectedPrerequisites.contains(newValue)) {
                  setState(() {
                    _selectedPrerequisites.add(newValue);
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _selectedPrerequisites.map((courseId) {
            final course = _availableCourses.firstWhere(
              (c) => c.id == courseId,
              orElse: () =>
                  PrerequisiteCourse(id: courseId, title: 'Unknown Course'),
            );
            return Chip(
              label: Text(course.title),
              onDeleted: () {
                setState(() {
                  _selectedPrerequisites.remove(courseId);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDynamicList(
    String title,
    List<String> items,
    Function(int) onRemove,
    Function() onAdd,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        inputDecorationTheme: InputDecorationTheme(
                          hintStyle: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      child: CustomTextfield(
                        label: '',
                        hint: 'Enter $title',
                        initialValue: items[index],
                        onChanged: (value) => items[index] = value,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (items.length > 1) {
                          onRemove(index);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              onAdd();
            });
          },
          icon: const Icon(Icons.add),
          label: Text('Add $title'),
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _selectedCategoryId,
              isExpanded: true,
              hint: const Text('Select a category'),
              items: _categories.map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category['id'] as String,
                  child: Row(
                    children: [
                      Icon(
                        _getIconData(category['icon'] as String),
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(category['name'] as String),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                  _selectedCategoryName =
                      _categories.firstWhere(
                            (cat) => cat['id'] == value,
                          )['name']
                          as String;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconData(String iconCode) {
    //convert the string hex code to integer
    return IconData(int.parse(iconCode), fontFamily: 'MaterialIcons');
  }

  Widget _buildPremiumSwitch() {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Premium Course',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          Switch(
            value: _isPremium,
            onChanged: (value) {
              setState(() {
                _isPremium = value;
              });
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDropDown() {
    const levels = ['Beginner', 'Intermediate', 'Advanced'];
    final theme = Theme.of(context);

    return DropdownButtonFormField<String>(
      initialValue: _selectedLevel,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Level',
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),

      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.primary,
      ),

      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),

      items: levels
          .map(
            (level) => DropdownMenuItem(
              value: level,
              child: Row(
                children: [
                  Icon(
                    level == 'Beginner'
                        ? Icons.flag_outlined
                        : level == 'Intermediate'
                        ? Icons.trending_up_outlined
                        : Icons.workspace_premium_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    level,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),

      onChanged: (value) => setState(() => _selectedLevel = value!),

      menuMaxHeight: 220,
      alignment: Alignment.centerLeft,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),

      selectedItemBuilder: (context) {
        return levels.map((level) {
          return Row(
            children: [
              Icon(
                level == 'Beginner'
                    ? Icons.flag_outlined
                    : level == 'Intermediate'
                    ? Icons.trending_up_outlined
                    : Icons.workspace_premium_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                level,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }).toList();
      },
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    //validate course thumbnail
    if (_courseImageUrl == null) {
      Get.snackbar(
        'Error',
        'Please select a course thumbnail',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    //validate category
    if (_selectedCategoryId == null) {
      Get.snackbar(
        'Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    // validate lesson
    if (_lessons.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add at least one lesson',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    //validate lesson fields
    String? lessonError = _validateLesson();
    if (lessonError != null) {
      Get.snackbar(
        'Error',
        lessonError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      final course = Course(
        id: widget.course?.id ?? const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _courseImageUrl!,
        instructorID: FirebaseAuth.instance.currentUser!.uid,
        categoryID: _selectedCategoryId!,
        price: double.parse(_priceController.text),
        lessons: _lessons,
        level: _selectedLevel,
        requirements: _requirements.where((r) => r.isNotEmpty).toList(),
        whatYouWillLearn: _learningPoints.where((p) => p.isNotEmpty).toList(),
        createdAt: widget.course?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        isPremium: _isPremium,
        prerequisites: _selectedPrerequisites,
        rating: widget.course?.rating ?? 0.0,
        reviewCount: widget.course?.reviewCount ?? 0,
        enrollmentCount: widget.course?.enrollmentCount ?? 0,
      );

      if (widget.course != null) {
        await _courseRepository.updateCourse(course);
        //dispatch update course event to refresh course details if in edit mode
        context.read<CourseBloc>().add(
          UpdateCourse(FirebaseAuth.instance.currentUser!.uid),
        );
        Get.back();
        Get.snackbar(
          'Success',
          'Course update successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        await _courseRepository.createCourse(course);
        Get.back();
        Get.snackbar(
          'Success',
          'Course created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create course: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String? _validateLesson() {
    for (int i = 0; i < _lessons.length; i++) {
      final lesson = _lessons[i];

      //validate lesson title
      if (lesson.title.isEmpty) {
        return 'Please enter a title for Lesson ${i + 1}';
      }

      //validate lesson description
      if (lesson.description.isEmpty) {
        return 'Please enter a description for Lesson ${i + 1}';
      }

      //validate lesson video
      if (lesson.videoUrl.isEmpty) {
        return 'Please upload a video for Lesson ${i + 1}';
      }

      //validate lesson duration
      if (lesson.duration <= 0) {
        return 'Please enter a valid duration for lesson ${i + 1}';
      }
    }
    return null;
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              image: _courseImageUrl != null && !_isUploadingImage
                  ? DecorationImage(
                      image: NetworkImage(_courseImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _isUploadingImage
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                    ),
                  )
                : _courseImageUrl == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, size: 48),
                        SizedBox(height: 8),
                        Text(
                          'Add Course Thumbnail',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
          if (_courseImageUrl != null && !_isUploadingImage)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 32),
                      const SizedBox(height: 8),
                      Text(
                        'Change Thumbnail',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        setState(() {
          _courseImagePath = pickedFile.path;
          _isUploadingImage = true;
        });
        //uploading image to cloudinary
        final imageUrl = await _cloudinaryService.uploadImage(
          pickedFile.path,
          'course_images',
        );
        setState(() {
          _courseImageUrl = imageUrl;
          _isUploadingImage = false;
        });
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      Get.snackbar(
        'Error',
        'Failed top pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}

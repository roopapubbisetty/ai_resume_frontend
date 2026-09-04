import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../models/job_model.dart';
import '../../providers/admin_provider.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/snackbar_utils.dart';
import '../../utils/validators.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/admin/admin_side_menu.dart';
import '../../widgets/primary_button.dart';

class AdminCreateJobScreen extends StatefulWidget {
  const AdminCreateJobScreen({super.key});

  @override
  State<AdminCreateJobScreen> createState() => _AdminCreateJobScreenState();
}

class _AdminCreateJobScreenState extends State<AdminCreateJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);

      final skillsList = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final newJob = JobModel(
        id: 'job_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        company: _companyController.text.trim(),
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        requiredSkills: skillsList.isEmpty ? ['Flutter', 'Dart'] : skillsList,
        preferredSkills: [],
        minExperience: '3',
        createdAt: DateTime.now(),
      );

      final success = await adminProvider.createJob(newJob);
      if (success && mounted) {
        SnackbarUtils.showSuccess(context, 'Job created successfully!');
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminJobs);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Create Job Post'),
      drawer: isDesktop ? null : const AdminSideMenu(currentRoute: AppRoutes.adminJobs),
      body: Row(
        children: [
          if (isDesktop)
            const SizedBox(
              width: 250,
              child: AdminSideMenu(currentRoute: AppRoutes.adminJobs),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add New Job Description',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        AppTextField(
                          label: 'Job Title',
                          hint: 'Senior Flutter Engineer',
                          controller: _titleController,
                          validator: (v) => Validators.validateRequired(v, 'Job Title'),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                label: 'Company Name',
                                hint: 'TechCorp Solutions',
                                controller: _companyController,
                                validator: (v) => Validators.validateRequired(v, 'Company Name'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AppTextField(
                                label: 'Location',
                                hint: 'San Francisco, CA (Remote)',
                                controller: _locationController,
                                validator: (v) => Validators.validateRequired(v, 'Location'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Required Skills (comma separated)',
                          hint: 'Flutter, Dart, REST APIs, Git, Docker',
                          controller: _skillsController,
                          validator: (v) => Validators.validateRequired(v, 'Required Skills'),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Job Description',
                          hint: 'Enter comprehensive role requirements, duties, and qualifications...',
                          controller: _descriptionController,
                          maxLines: 4,
                          validator: (v) => Validators.validateRequired(v, 'Job Description'),
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          label: 'Save & Publish Job',
                          isLoading: adminProvider.isLoading,
                          onPressed: _handleSave,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

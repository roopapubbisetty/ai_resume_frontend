import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_routes.dart';
import '../../models/job_model.dart';
import '../../providers/admin_provider.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/snackbar_utils.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/dashboard/dashboard_app_bar.dart';
import '../../widgets/admin/admin_side_menu.dart';
import '../../widgets/primary_button.dart';

class AdminEditJobScreen extends StatefulWidget {
  final JobModel? job;

  const AdminEditJobScreen({super.key, this.job});

  @override
  State<AdminEditJobScreen> createState() => _AdminEditJobScreenState();
}

class _AdminEditJobScreenState extends State<AdminEditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _companyController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;
  late TextEditingController _skillsController;

  @override
  void initState() {
    super.initState();
    final job = widget.job;
    _titleController = TextEditingController(text: job?.title ?? '');
    _companyController = TextEditingController(text: job?.company ?? '');
    _locationController = TextEditingController(text: job?.location ?? '');
    _descriptionController = TextEditingController(text: job?.description ?? '');
    _skillsController = TextEditingController(text: job?.requiredSkills.join(', ') ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  void _handleUpdate() async {
    if (_formKey.currentState!.validate() && widget.job != null) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);

      final skillsList = _skillsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final updatedJob = JobModel(
        id: widget.job!.id,
        title: _titleController.text.trim(),
        company: _companyController.text.trim(),
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        requiredSkills: skillsList,
        preferredSkills: widget.job!.preferredSkills,
        minExperience: widget.job!.minExperience,
        createdAt: widget.job!.createdAt,
      );

      final success = await adminProvider.updateJob(updatedJob);
      if (success && mounted) {
        SnackbarUtils.showSuccess(context, 'Job updated successfully!');
        Navigator.of(context).pushReplacementNamed(AppRoutes.adminJobs);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: const DashboardAppBar(title: 'Edit Job Post'),
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
                          'Update Job Post',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        AppTextField(
                          label: 'Job Title',
                          controller: _titleController,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Company',
                          controller: _companyController,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Location',
                          controller: _locationController,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Required Skills',
                          controller: _skillsController,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Description',
                          controller: _descriptionController,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          label: 'Update Job Details',
                          isLoading: adminProvider.isLoading,
                          onPressed: _handleUpdate,
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

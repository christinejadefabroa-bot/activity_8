
import 'package:flutter/material.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

enum ReportUiState { idle, loading, success, empty, error }

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() =>
      _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  ReportUiState _uiState = ReportUiState.idle;
  String _category = 'General Concern';
  bool _simulateFailure = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _uiState = ReportUiState.loading;
    });

    try {
      // Simulates an asynchronous request.
      await Future<void>.delayed(
        const Duration(seconds: 3),
      );

      if (_simulateFailure) {
        throw Exception('Simulated request failure');
      }

      if (!mounted) return;

      setState(() {
        _uiState = ReportUiState.success;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _uiState = ReportUiState.error;
      });
    }
  }

  Widget buildStateMessage() {
    switch (_uiState) {
      case ReportUiState.loading:
        return const Card(
          child: ListTile(
            leading: CircularProgressIndicator(),
            title: Text('Submitting report...'),
            subtitle: Text(
              'Please wait. This is a simulated request.',
            ),
          ),
        );

      case ReportUiState.success:
        return Card(
          color: Colors.green.shade50,
          child: const ListTile(
            leading: Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            title: Text('Report submitted successfully!'),
            subtitle: Text(
              'Demo only: no database record was saved.',
            ),
          ),
        );

      case ReportUiState.empty:
        return Card(
          child: ListTile(
            leading: const Icon(Icons.inbox_outlined),
            title: const Text('No reports available'),
            subtitle: const Text(
              'There are no report records to display yet.',
            ),
            trailing: TextButton(
              onPressed: () {
                setState(() {
                  _uiState = ReportUiState.idle;
                });
              },
              child: const Text('Back to form'),
            ),
          ),
        );

      case ReportUiState.error:
        return Card(
          color: Colors.red.shade50,
          child: ListTile(
            leading: const Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            title: const Text('Submission failed'),
            subtitle: const Text(
              'A simulated error occurred. Check your input '
              'and try again.',
            ),
            trailing: TextButton(
              onPressed: submitReport,
              child: const Text('Retry'),
            ),
          ),
        );

      case ReportUiState.idle:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _uiState == ReportUiState.loading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Form'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Submit a Report',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Complete the form below to report a concern.',
              ),
              const SizedBox(height: 20),

              buildStateMessage(),

              if (_uiState == ReportUiState.success)
                AppButton(
                  text: 'Submit Another Report',
                  onPressed: () {
                    setState(() {
                      _uiState = ReportUiState.idle;
                      _titleController.clear();
                      _descriptionController.clear();
                      _locationController.clear();
                      _category = 'General Concern';
                      _simulateFailure = false;
                    });
                  },
                ),

              if (_uiState != ReportUiState.empty &&
                  _uiState != ReportUiState.success) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _titleController,
                        label: 'Report Title',
                        hint: 'Enter the report title',
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter a report title';
                          }
                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'General Concern',
                            child: Text('General Concern'),
                          ),
                          DropdownMenuItem(
                            value: 'Facility',
                            child: Text('Facility'),
                          ),
                          DropdownMenuItem(
                            value: 'Safety',
                            child: Text('Safety'),
                          ),
                          DropdownMenuItem(
                            value: 'Other',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: isLoading
                            ? null
                            : (value) {
                                if (value != null) {
                                  setState(() {
                                    _category = value;
                                  });
                                }
                              },
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Explain the concern',
                        maxLines: 3,
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        controller: _locationController,
                        label: 'Location',
                        hint: 'Where did it happen?',
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Simulate an error (testing only)',
                  ),
                  subtitle: const Text(
                    'Turn on to demonstrate the Error state.',
                  ),
                  value: _simulateFailure,
                  onChanged: isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _simulateFailure = value;
                          });
                        },
                ),
                const SizedBox(height: 12),

                AppButton(
                  text: 'Submit Report',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : submitReport,
                ),
                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          setState(() {
                            _uiState = ReportUiState.empty;
                          });
                        },
                  icon: const Icon(Icons.inbox_outlined),
                  label: const Text('View Reports'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

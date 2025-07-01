import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbridge_volunteers_flutter/core/repository/auth_repository.dart';
import 'package:foodbridge_volunteers_flutter/logic/stripe/bloc/stripe_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  bool _isWebViewLoading = true;
  final _gradientColors = [Colors.blue.shade700, Colors.green.shade600];

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => _isWebViewLoading = true),
          onPageFinished: (url) => setState(() => _isWebViewLoading = false),
          onUrlChange: (urlChange) {
            if (urlChange.url?.contains('yourapp://stripe-redirect') ?? false) {
              Navigator.pop(context);
            }
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StripeBloc(
        authRepository: AuthRepository(),
      )..add(GetStripeRefreshUrl()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complete Onboarding',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white)),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          actions: [
            BlocBuilder<StripeBloc, StripeState>(
              builder: (context, state) {
                return IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.refresh, color: Colors.white),
                  ),
                  onPressed: state is! StripeUrlLoading
                      ? () => context.read<StripeBloc>().add(GetStripeRefreshUrl())
                      : null,
                );
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_gradientColors[1].withOpacity(0.05), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: BlocListener<StripeBloc, StripeState>(
            listener: (context, state) {
              if (state is StripeUrlLoaded) {
                _controller.loadRequest(Uri.parse(state.url));
              }
            },
            child: BlocBuilder<StripeBloc, StripeState>(
              builder: (context, state) {
                if (state is StripeUrlLoading) {
                  return _buildLoadingState();
                }
                
                if (state is StripeUrlError) {
                  return _buildErrorState(context, state.message);
                }

                return _buildWebView();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator.adaptive(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 20),
          Text('Preparing your onboarding...',
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, 
                    color: Colors.red.shade400, 
                    size: 40),
                const SizedBox(height: 16),
                Text('Oops! Something went wrong',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(error,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  onPressed: () => context.read<StripeBloc>().add(GetStripeRefreshUrl()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebView() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: WebViewWidget(controller: _controller),
        ),
        if (_isWebViewLoading)
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 16),
                  Text('Loading onboarding form...',
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
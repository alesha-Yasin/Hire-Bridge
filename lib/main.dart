import 'package:flutter/material.dart';
import 'package:hirebridge/HireBridgeApp.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRobG12YXlmemZ6cm1sdWplbWFpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU0NzI0MDMsImV4cCI6MjA4MTA0ODQwM30.4fwU03XxLBewLCDzdE9LE8GWh-MwIJ8m9aE9HMJMypg',
    url: 'https://thlmvayfzfzrmlujemai.supabase.co',
  );
  
  runApp(const HireBridgeApp());
}


import 'package:flutter/material.dart';
import 'package:hirebridge/HireBridgeApp.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://iufcqglouqvjbjppvsba.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml1ZmNxZ2xvdXF2amJqcHB2c2JhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc3MjE3NDQsImV4cCI6MjA4MzI5Nzc0NH0.JQSQfJ-Ndw1Xa9jLI83zmSCcOdnRlAyfIvA7eHjy9Xc',
  );
  
  runApp(const HireBridgeApp());
}


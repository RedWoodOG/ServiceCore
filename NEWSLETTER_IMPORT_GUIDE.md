# Newsletter Import Guide

This guide explains how to import newsletter content from a PDF file into the Company Feed.

## Overview

The newsletter import feature allows you to extract announcements from PDF newsletters and add them to the company feed. The system automatically:
- Extracts text from the PDF
- Parses content into structured announcements
- Categorizes announcements (HR, Safety, Fleet, General)
- Detects action labels (ACKNOWLEDGE, VIEW POLICY, etc.)
- Inserts announcements into the database

## Method 1: Using the UI (Recommended)

1. **Open the Portal app**
2. **Navigate to the Home dashboard**
3. **In the Company Feed section**, click the **upload icon** (📤) next to the "Company Feed" header
4. **Select your PDF file** from the file picker
5. **Wait for import** - the system will extract and parse the content
6. **View results** - announcements will appear in the Company Feed

## Method 2: Command-Line Script (Proper CLI)

The import script uses proper command-line argument parsing with the `args` package.

**Standard Usage:**
```bash
# Install dependencies first
flutter pub get

# Run with explicit path
dart run lib/scripts/import_newsletter.dart --pdf-path "C:\Users\jwhit\Downloads\2026 January Newsletter .pdf"

# Or use short form
dart run lib/scripts/import_newsletter.dart -p "C:\path\to\newsletter.pdf"
```

**Using the batch file (Windows):**
```batch
# With default path
IMPORT_NEWSLETTER.bat

# With custom path
IMPORT_NEWSLETTER.bat "C:\path\to\newsletter.pdf"
```

**Using environment variable:**
```batch
set PDF_PATH=C:\Users\jwhit\Downloads\2026 January Newsletter .pdf
dart run lib/scripts/import_newsletter.dart
```

**Help:**
```bash
dart run lib/scripts/import_newsletter.dart --help
```

## How It Works

### PDF Text Extraction
- Uses Syncfusion PDF library to extract text from all pages
- Preserves paragraph structure and formatting

### Content Parsing
The parser looks for:
- **Titles**: Short lines (under 100 chars), possibly numbered, title case, or all caps
- **Body Text**: Longer paragraphs following titles
- **Categories**: Detected from keywords:
  - **HR**: "hr", "human resources", "benefits", "enrollment", "insurance", "payroll"
  - **Safety**: "safety", "hazard", "warning", "advisory", "precaution"
  - **Fleet**: "fleet", "vehicle", "truck", "repair", "maintenance"
  - **General**: Default category for other content
- **Action Labels**: Detected from phrases like "acknowledge", "view policy", "select benefits", etc.

### Announcement Structure
Each announcement includes:
- **Title**: Extracted from headings or first line
- **Body**: Full text content (truncated to 500 chars if too long)
- **Category**: Auto-detected or "general"
- **Action Label**: Optional button text
- **Published Date**: Current date/time
- **Active**: Set to true (visible in feed)

## Files Created

- `lib/services/newsletter_import_service.dart` - Core import logic
- `lib/features/home/import_newsletter_sheet.dart` - UI component
- `lib/scripts/import_newsletter.dart` - Standalone import script

## Troubleshooting

### PDF Not Found
- Ensure the file path is correct
- Check file permissions
- Verify the file is a valid PDF

### No Announcements Created
- The PDF might not have extractable text (scanned images)
- Try using OCR or converting the PDF to text first
- Check the console for parsing errors

### Import Errors
- Ensure `syncfusion_flutter_pdf` package is installed: `flutter pub get`
- Check that the database is accessible
- Verify file permissions

## Next Steps

After importing:
1. **Review announcements** in the Company Feed
2. **Edit if needed** using the "Post Announcement" feature
3. **Acknowledge** safety-related announcements
4. **Archive old announcements** by setting them to inactive

## Notes

- Announcements are added to the existing feed (not replacing)
- The parser is intelligent but may need manual review for complex layouts
- Large PDFs may take a few seconds to process
- All announcements are set to "active" by default

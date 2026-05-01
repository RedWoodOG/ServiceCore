# Git Repository Setup - FSC Portal

**Repository Initialized:** January 31, 2026  
**Location:** `H:\FSC_Portal\FSC-Portal`  
**Branch:** master  
**Initial Commit:** 3b14cf8

---

## Repository Overview

This Git repository contains the **FSC Portal v1.1.0 Development Branch**, an offline-first Flutter desktop application for field service technicians managing banking equipment.

### Project Status
- **Completion:** 85-90% (Beta - Production Ready)
- **Core Features:** 100% Complete
- **Files Tracked:** 237 files
- **Lines of Code:** 74,334+ insertions

---

## Repository Structure

```
FSC-Portal/
├── .git/                          # Git repository data
├── .gitignore                     # Comprehensive ignore rules
├── lib/                           # Main application source code
│   ├── app_shell/                 # Navigation and shell components
│   ├── database/                  # Drift database and schema
│   ├── features/                  # Feature modules (9 features)
│   ├── services/                  # Business logic services
│   ├── providers/                 # State management
│   ├── theme/                     # Design system
│   ├── widgets/                   # Reusable components
│   ├── util/                      # Utilities
│   └── main.dart                  # Application entry point
├── assets/                        # Images, logos, icons
├── android/                       # Android platform (future)
├── windows/                       # Windows platform (current)
├── test/                          # Unit and integration tests
├── docs/                          # Documentation
├── execution/                     # Python scripts for automation
├── directives/                    # AI agent directives
└── [Documentation Files]          # 60+ markdown documentation files
```

---

## What's Tracked in Git

### Application Code (237 files)
✅ All Dart source files (`lib/`, `test/`)  
✅ Platform-specific code (`windows/`, `android/`)  
✅ Assets (logos, images)  
✅ Configuration files (`pubspec.yaml`, `analysis_options.yaml`)  
✅ Documentation (README, guides, audits)  
✅ Scripts (PowerShell, Python)  

### What's Ignored (.gitignore)
❌ Build artifacts (`/build/`, `*.exe`)  
❌ Generated files (`.dart_tool/`, `*.g.dart` are tracked but builds ignored)  
❌ Dependencies (`.pub-cache/`, `node_modules/`)  
❌ Temporary files (`.tmp/`, `xlsx_temp/`, `inventory_temp/`)  
❌ Database files (`*.sqlite`, `*.db`)  
❌ Environment secrets (`.env`, `credentials.json`)  
❌ IDE-specific files (`.idea/`, build artifacts)  

---

## Technology Stack (Git Tracked)

### Flutter/Dart
- **SDK:** Flutter 3.0+
- **Language:** Dart (>=3.0.0 <4.0.0)
- **State Management:** Provider v6.1.2
- **Database:** Drift v2.20.0 (SQLite ORM)
- **Mapping:** flutter_map v8.2.2

### Key Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter: sdk
  drift: ^2.20.0              # Database ORM
  sqlite3: ^2.1.0              # SQLite engine
  provider: ^6.1.2             # State management
  flutter_map: ^8.2.2          # Mapping
  cryptography: ^2.7.0         # Encryption (Phase 2)
  flutter_secure_storage: ^9.2.2  # Secure storage
```

---

## Git Best Practices for This Project

### Branch Strategy
```
master (main development branch)
  ├── feature/authentication        # Windows SID auth
  ├── feature/encryption             # Hybrid encryption
  ├── feature/ui-enhancements        # UI improvements
  └── hotfix/*                       # Critical fixes
```

### Recommended Workflow
1. **Feature Development:**
   ```bash
   git checkout -b feature/feature-name
   # Make changes
   git add .
   git commit -m "Add feature description"
   git checkout master
   git merge feature/feature-name
   ```

2. **Commit Message Convention:**
   ```
   <type>: <subject>
   
   <body>
   
   Examples:
   - feat: Add Windows SID authentication
   - fix: Resolve map rendering issue
   - docs: Update README with build instructions
   - refactor: Reorganize database schema
   - test: Add unit tests for encryption service
   ```

3. **Before Committing:**
   ```bash
   # Check status
   git status
   
   # Review changes
   git diff
   
   # Stage selectively
   git add path/to/file
   
   # Commit with meaningful message
   git commit -m "Clear description of what changed and why"
   ```

---

## Deployment Workflow

### Development → Production Flow

1. **Development Branch (Current):**
   - Location: `H:\FSC_Portal\FSC-Portal`
   - Branch: `master`
   - Purpose: Active development, experiments, security features

2. **Stable Branch (Separate):**
   - Location: `H:\FSC_Portal\Offline-Portal`
   - Version: v1.0.0 (Stable MVP)
   - Purpose: Production-ready, frozen

3. **Merging Flow:**
   ```bash
   # After thorough testing in FSC-Portal
   cd H:\FSC_Portal\FSC-Portal
   git log --oneline  # Review commits
   
   # Create release branch
   git checkout -b release/v1.1.0
   
   # Build and test
   flutter build windows --release
   
   # Tag the release
   git tag -a v1.1.0 -m "Release version 1.1.0 with security features"
   
   # Optionally merge back to stable (manual decision)
   ```

---

## Important Files in Git

### Critical Configuration
- `pubspec.yaml` - Flutter dependencies and metadata
- `analysis_options.yaml` - Dart linter configuration
- `.gitignore` - Comprehensive ignore rules (enhanced)
- `lib/main.dart` - Application entry point

### Database Schema
- `lib/database/app_database.dart` - Drift schema definitions
- `lib/database/app_database.g.dart` - Generated Drift code (tracked)
- `lib/database/seed_service.dart` - Sample data seeding

### Documentation (60+ files)
- `README.md` - Project overview
- `AI_CONTEXT.md` - Design system and context for AI
- `PROJECT_STATUS_REPORT_2026.md` - Comprehensive status
- `DEVELOPMENT_GUIDE.md` - Developer onboarding
- `FSC_BRAND_GUIDE.md` - Brand guidelines
- Plus 50+ phase reports, audits, and guides

---

## Repository Statistics

```
Initial Commit: 3b14cf8
Date: January 31, 2026
Files: 237
Insertions: 74,334 lines
Deletions: 0 lines
```

### File Breakdown by Type
```
Dart files:     94 files
Markdown docs:  80 files
Config files:   14 files
Assets:         15 files (images, logos)
Platform code:  18 files (Windows/Android)
Scripts:        8 files (PowerShell, Python)
Tests:          3 files
Other:          5 files
```

---

## Next Steps

### Immediate Actions
1. ✅ **Git repository initialized** (COMPLETE)
2. ✅ **Initial commit created** (COMPLETE)
3. ⏳ **Set up remote repository** (GitHub/GitLab/Azure DevOps)
4. ⏳ **Configure branch protection**
5. ⏳ **Set up CI/CD pipeline**

### Future Enhancements
- **Remote Repository Setup:**
  ```bash
  git remote add origin <your-remote-url>
  git push -u origin master
  ```

- **Branch Protection:**
  - Require pull requests for master
  - Require code review
  - Require passing tests

- **CI/CD Pipeline:**
  - Automated builds on commit
  - Automated tests
  - Version tagging
  - Release artifact generation

---

## Common Git Commands for This Project

### Daily Development
```bash
# Check status
git status

# View changes
git diff

# Stage all changes
git add .

# Commit with message
git commit -m "Description of changes"

# View history
git log --oneline --graph

# Create feature branch
git checkout -b feature/new-feature

# Switch branches
git checkout master

# Merge feature
git merge feature/new-feature

# View current branch
git branch
```

### Maintenance
```bash
# View repository size
git count-objects -vH

# Clean up
git gc

# View remote
git remote -v

# View tags
git tag

# Create annotated tag
git tag -a v1.1.0 -m "Release v1.1.0"
```

---

## Recovery and Backup

### Repository Backup
The entire repository can be backed up by copying the `.git` folder or using:
```bash
git clone --bare H:\FSC_Portal\FSC-Portal H:\Backups\FSC-Portal.git
```

### Restore from Backup
```bash
git clone H:\Backups\FSC-Portal.git H:\FSC_Portal\FSC-Portal-Restored
```

### View All Commits
```bash
git log --all --graph --decorate --oneline
```

---

## Version Control Philosophy

This repository follows these principles:

1. **Commit Often:** Small, atomic commits are better than large monolithic ones
2. **Meaningful Messages:** Each commit message should explain *why*, not just *what*
3. **Branch for Features:** Use branches for all new development
4. **Test Before Merge:** Always test thoroughly before merging to master
5. **Document Changes:** Update documentation in the same commit as code changes
6. **Tag Releases:** Use semantic versioning tags (v1.0.0, v1.1.0, etc.)

---

## Support and Documentation

- **Project Status:** `PROJECT_STATUS_REPORT_2026.md`
- **Development Guide:** `DEVELOPMENT_GUIDE.md`
- **Design System:** `AI_CONTEXT.md`
- **Build Instructions:** `HOW_TO_LAUNCH.md`
- **Testing Guide:** `QUICK_TEST_GUIDE.md`

---

**Repository Maintained by:** VyreVault Studios  
**Last Updated:** January 31, 2026  
**Git Version:** Check with `git --version`

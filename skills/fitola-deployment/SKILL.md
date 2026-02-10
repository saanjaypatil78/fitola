---
name: fitola-deployment
description: Deployment automation skill for Fitola
version: 1.0.0
author: Fitola Team
tags: [deployment, devops, ci-cd, vercel]
---

# Fitola Deployment

Automated deployment for Fitola backend and mobile apps.

## Deployment Targets

### Backend (Vercel)
```bash
# Deploy to production
vercel --prod

# Deploy to staging
vercel
```

### Mobile (Android)
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### Mobile (iOS)
```bash
# Build for App Store
flutter build ios --release
```

### Web
```bash
# Build web app
flutter build web --release
```

## CI/CD Pipeline
Automated testing, building, and deployment via GitHub Actions.

## Best Practices
1. Test before deploy
2. Use environment variables
3. Implement health checks
4. Enable monitoring
5. Plan rollback strategy

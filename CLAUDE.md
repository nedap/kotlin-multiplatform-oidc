# Kotlin Multiplatform OIDC Project Guide

## Build Commands
- Build entire project: `./gradlew build`
- Run all tests: `./gradlew test`
- Run single test: `./gradlew :module-name:test --tests "fully.qualified.TestClass"`
- Clean build: `./gradlew clean build`

## Code Style Guidelines
- Follow Kotlin official code style (kotlin.code.style=official)
- Use platform-specific implementations with expect/actual pattern
- Organize imports alphabetically and group by package
- Naming: camelCase for properties/methods, PascalCase for classes/interfaces
- Target JVM 17 and Kotlin 2.0.20 compatibility
- Use suspend functions for async operations
- Handle errors with Result type and RunCatchingWrapException
- Prefer explicit types for public API
- Add @ExperimentalOpenIdConnect annotation for experimental features

## Project Structure
- Platform-specific code lives in respective sourceSet directories
- Share common code via commonMain
- Use convention plugins for consistent configuration
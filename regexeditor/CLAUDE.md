# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

RegexEditor is a Vaadin Spring Boot application that provides a web interface for testing regular expressions against sample text. The application demonstrates real-time validation of regex patterns and matching against input text.

## Build and Development Commands

### Development
- `./mvnw` (Linux/Mac) or `mvnw` (Windows) - Start development server on http://localhost:8080
- `./mvnw spring-boot:run` - Alternative way to start the application

### Production Build
- `./mvnw clean package -Pproduction` - Create production JAR in target/ folder
- `java -jar target/regexeditor-1.0-SNAPSHOT.jar` - Run production build

### Docker
- `mvn clean package -Pproduction && docker build . -t regexeditor:latest` - Build Docker image
- `docker run -p 8080:8080 regexeditor:latest` - Run containerized application

### Testing
- `./mvnw test` - Run unit tests
- `./mvnw verify -Pit` - Run integration tests (starts server automatically)

## Architecture

### Technology Stack
- **Backend**: Spring Boot 3.3.5 with Java 17
- **Frontend**: Vaadin 24.7.6 (full-stack web framework)
- **UI Components**: Vaadin Flow components with Lumo theme
- **Build**: Maven with Spring Boot starter parent

### Key Components

**RegexEditorView** (`src/main/java/com/rdebug/views/regexeditor/RegexEditorView.java`)
- Main application view with regex input and test text area
- Contains pattern matching logic with case-insensitive and multiline support
- Handles Enter key shortcut for testing

**RegexTextField** (`src/main/java/com/rdebug/views/regexeditor/RegexTextField.java`)
- Custom TextField component with real-time regex validation
- Uses SerializablePredicate for pattern validation
- Provides immediate visual feedback on invalid patterns

**MainLayout** (`src/main/java/com/rdebug/views/MainLayout.java`)
- Application shell using Vaadin AppLayout
- Contains navigation header and menu structure
- Uses LineAwesome icons for UI elements

### Frontend Structure
- `frontend/themes/regexeditor/` - Custom CSS styling and theme configuration
- `frontend/index.html` - Main HTML template
- Vaadin handles frontend bundling and TypeScript compilation automatically

### Pattern Matching Logic
The application uses a custom pattern compilation strategy:
- Patterns starting with `^` use CASE_INSENSITIVE | MULTILINE flags
- Other patterns use only CASE_INSENSITIVE flag
- Real-time validation prevents invalid regex compilation

## Development Notes

- The application uses Spring Boot DevTools for hot reloading during development
- Vaadin handles frontend resource compilation automatically
- Maven wrapper scripts (mvnw/mvnw.cmd) ensure consistent build environment
- Integration tests use TestBench for UI testing
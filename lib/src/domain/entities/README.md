# Entities

This directory contains pure Dart objects representing core business entities.

## Responsibilities
- Define domain models independent of presentation/data layers
- Represent core business concepts
- Contain business logic and validation rules
- Be framework-agnostic and testable

## Structure
Entities should be:
- Immutable (use `final` or `@immutable`)
- Pure Dart classes without Flutter dependencies
- Equatable for value comparison

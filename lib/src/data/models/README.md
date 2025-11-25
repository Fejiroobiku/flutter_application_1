# Models

This directory contains data model classes for API responses and local storage.

## Responsibilities
- Define JSON serialization/deserialization
- Map API responses to usable objects
- Handle data transformations
- Extend or map to domain entities
- Support both JSON and Dart object conversions

## Structure
Models typically:
- Include `fromJson()` and `toJson()` methods
- Extend domain entities or convert to them
- Use annotations for JSON serialization (e.g., `@JsonSerializable`)

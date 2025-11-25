# Data Sources

This directory contains abstract and concrete data source implementations.

## Responsibilities
- Define abstract interfaces for different data sources
- Implement remote data access (APIs)
- Implement local data access (databases, cache)
- Handle low-level data operations
- Manage API calls and local storage interactions

## Structure
Typically organized as:
- `remote_data_source.dart` - Abstract interface for remote data
- `remote_data_source_impl.dart` - HTTP client implementation
- `local_data_source.dart` - Abstract interface for local storage
- `local_data_source_impl.dart` - SQLite/SharedPreferences implementation

# Use Cases

This directory contains use case classes implementing specific business logic operations.

## Responsibilities
- Encapsulate specific business logic flows
- Provide single responsibility operations
- Act as mediators between presentation and repositories
- Handle operation parameters and results

## Structure
Each use case typically:
- Extends a base `UseCase` class
- Implements a `call()` method
- Takes parameters and returns a result
- Depends on repositories and other use cases

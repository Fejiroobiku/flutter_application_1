# Repositories

This directory contains abstract repository interfaces that define contracts for data operations.

## Responsibilities
- Define abstract interfaces for data access
- Specify what data operations are available
- Act as contracts between domain and data layers
- Enable dependency inversion and testing

## Structure
Repositories are abstract classes defining methods that:
- Return entities or results
- Can throw domain-level exceptions
- Are independent of data sources

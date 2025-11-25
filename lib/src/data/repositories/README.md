# Repositories

This directory contains concrete repository implementations combining multiple data sources.

## Responsibilities
- Implement abstract repository interfaces from domain layer
- Choose between remote and local data sources
- Handle caching strategies
- Perform data transformations (model to entity)
- Manage network and storage errors

## Structure
Repositories:
- Implement domain repository interfaces
- Inject data sources as dependencies
- Coordinate between remote and local sources
- Convert models to entities

## [Unreleased]

## [0.2.0] - 2025-11-19

- Introduced `AgentStatusBulb::Bulb` to wrap SwitchBot integration and provide run/wait/idle/off color APIs with automatic power control
- Rebuilt the CLI on top of Thor and routed every command through `handle_error` to normalize error handling
- Simplified configuration input/save/load flows by driving them from a single field definition list
- Added RSpec coverage for CLI, Configure, and Bulb to document expected behaviour
- Added RuboCop configuration to keep coding style consistent

## [0.1.0] - 2025-11-18

- Initial release

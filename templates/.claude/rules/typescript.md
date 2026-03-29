# TypeScript Rules

## Coding Style
- Use `const` by default, `let` only when reassignment is needed
- Prefer `interface` over `type` for object shapes
- Explicit return types on exported functions
- Use template literals for string interpolation
- Prefer `unknown` over `any`; narrow with type guards
- Use optional chaining (`?.`) and nullish coalescing (`??`)
- Destructure objects and arrays at point of use
- 2-space indentation, single quotes, no semicolons (or match project config)

## Patterns
- Use discriminated unions for state machines and variant types
- Prefer `Map`/`Set` over plain objects for dynamic keys
- Use `readonly` for arrays and objects that shouldn't be mutated
- Prefer `Promise.all` for independent async operations
- Use `satisfies` operator for type-safe object literals
- Avoid enums — use `as const` objects instead
- Handle errors with Result types or explicit try/catch (never silently)
- Use `Zod` or similar for runtime validation at system boundaries

## Testing
- Use Vitest or Jest with `describe`/`it` blocks
- Test behavior, not implementation details
- Mock external dependencies, not internal modules
- Use `beforeEach` for setup, avoid shared mutable state between tests
- Test error paths and edge cases, not just happy paths
- Aim for 80%+ coverage on business logic
- Use `test.each` for parameterized tests

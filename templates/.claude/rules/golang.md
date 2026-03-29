# Go Rules

## Coding Style
- Follow `gofmt` and `go vet` output unconditionally
- Use short variable names for small scopes, descriptive for large scopes
- Return errors, don't panic (except truly unrecoverable situations)
- Use `context.Context` as the first parameter for functions that do I/O
- Prefer composition over inheritance (embed interfaces)
- Use `errors.Is` and `errors.As` for error checking, not string comparison
- Keep functions under 50 lines
- Group imports: stdlib, external, internal (with blank line separators)

## Patterns
- Use table-driven tests for parameterized testing
- Use interfaces at the consumer, not the producer
- Use `sync.Once` for lazy initialization
- Prefer channels for coordination, mutexes for state protection
- Use `errgroup` for parallel operations with error handling
- Use `functional options` pattern for configurable constructors
- Return concrete types, accept interfaces
- Use `context.WithCancel` for cancellation propagation

## Testing
- Use `testing.T` with subtests (`t.Run`)
- Table-driven tests as the default pattern
- Use `testify/assert` or stdlib `testing` (match project convention)
- Use `httptest` for HTTP handler testing
- Use `t.Parallel()` for independent tests
- Benchmark with `testing.B` for performance-critical code
- Use `t.Helper()` in test helper functions
- Test exported API surface, not internal implementation

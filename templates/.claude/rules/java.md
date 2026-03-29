# Java Rules

## Coding Style
- Follow Google Java Style Guide
- Use `var` for local variables with obvious types (Java 10+)
- Use records for immutable data carriers (Java 16+)
- Use sealed classes for restricted hierarchies (Java 17+)
- Use pattern matching in switch expressions (Java 21+)
- Prefer `Optional` over null returns for methods that may not have a result
- Use `final` for variables that shouldn't be reassigned
- 4-space indentation, opening brace on same line

## Patterns
- Use dependency injection (constructor injection preferred)
- Use `Stream` API for collection transformations
- Use `CompletableFuture` for async operations
- Prefer immutable collections (`List.of`, `Map.of`, `Set.of`)
- Use builder pattern for objects with many optional fields
- Handle checked exceptions at the appropriate level, not just wrap-and-rethrow
- Use `try-with-resources` for `AutoCloseable` resources
- Use virtual threads (Java 21+) for I/O-bound concurrency

## Testing
- Use JUnit 5 with `@Test`, `@ParameterizedTest`, `@Nested`
- Use Mockito for mocking dependencies
- Use `assertThat` (AssertJ) for readable assertions
- Use `@BeforeEach` for test setup
- Test at the service layer, mock repositories and external calls
- Use `@SpringBootTest` sparingly — prefer unit tests
- Use `Testcontainers` for integration tests with real databases
- Aim for 80%+ coverage on business logic

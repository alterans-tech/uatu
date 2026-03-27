---
name: test-file
description: Generate a comprehensive test file for any source file. Language-agnostic — detects the project's test framework and generates appropriate test structure. Covers happy path, edge cases, and error scenarios.
---

# Test File Generator

Generate comprehensive tests for any source file.

## Usage

```
/test-file <path/to/source-file>
```

**Examples:**
```
/test-file src/services/auth-service.ts
/test-file src/api/users.py
/test-file pkg/handlers/order.go
/test-file src/utils/format.ts
```

## What Gets Generated

A test file co-located with the source file, following project conventions:

| Source | Test File |
|--------|-----------|
| `src/service.ts` | `src/service.test.ts` |
| `src/service.py` | `src/test_service.py` |
| `pkg/handler.go` | `pkg/handler_test.go` |
| `src/util.ts` | `src/util.spec.ts` (if `.spec` is convention) |

## Instructions

When this skill is invoked:

1. **Read the source file** — understand what it exports and does
2. **Detect test framework:**
   - TypeScript/JavaScript: Jest, Vitest, Mocha
   - Python: pytest, unittest
   - Go: standard `testing` package
3. **Identify what to test:**
   - All exported functions/methods/classes
   - Public API surface only (not internals)
4. **Generate test cases for each export:**
   - Happy path (typical valid input → expected output)
   - Edge cases (empty, null, boundary values)
   - Error cases (invalid input, thrown errors)
5. **Create the test file** with appropriate framework syntax

## Test Structure (TypeScript/Jest example)

```typescript
import { functionToTest } from './source-file';

describe('functionToTest', () => {
  describe('happy path', () => {
    it('should return expected result for valid input', () => {
      expect(functionToTest(validInput)).toBe(expectedOutput);
    });
  });

  describe('edge cases', () => {
    it('should handle empty input', () => {
      expect(functionToTest('')).toBe(defaultOutput);
    });

    it('should handle null input', () => {
      expect(() => functionToTest(null)).toThrow();
    });
  });

  describe('error scenarios', () => {
    it('should throw on invalid input', () => {
      expect(() => functionToTest(invalidInput)).toThrow('expected error message');
    });
  });
});
```

## Quality Requirements

- Every exported function has at least one test
- Tests are independent (no shared mutable state between tests)
- Test names describe behavior, not implementation (`it('should return...')` not `it('calls method...')`)
- Mocks are minimal — only mock external dependencies
- Tests run in isolation (no network, no filesystem unless explicitly testing I/O)

## Framework-Specific Notes

**Python (pytest):**
```python
def test_function_name_happy_path():
    assert function_to_test(valid_input) == expected_output

def test_function_name_raises_on_invalid():
    with pytest.raises(ValueError):
        function_to_test(invalid_input)
```

**Go:**
```go
func TestFunctionName(t *testing.T) {
    t.Run("happy path", func(t *testing.T) {
        result, err := FunctionToTest(validInput)
        assert.NoError(t, err)
        assert.Equal(t, expected, result)
    })
}
```

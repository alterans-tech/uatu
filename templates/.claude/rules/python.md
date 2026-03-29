# Python Rules

## Coding Style
- Follow PEP 8 strictly
- Use type hints on all function signatures
- Use f-strings for string formatting
- Prefer `pathlib.Path` over `os.path`
- Use `dataclasses` or `pydantic` for data structures
- 4-space indentation, double quotes
- Use `from __future__ import annotations` for forward references
- Prefer comprehensions over `map`/`filter` for readability

## Patterns
- Use context managers (`with`) for resource management
- Prefer `enum.Enum` for fixed sets of values
- Use `functools.lru_cache` for expensive pure functions
- Handle errors with specific exceptions, not bare `except`
- Use `logging` module, never `print()` in production code
- Prefer `collections.defaultdict` over manual key checking
- Use generators for large sequences (memory efficiency)
- Use `asyncio` for I/O-bound concurrency, not threading

## Testing
- Use `pytest` with fixtures and parametrize
- Use `conftest.py` for shared fixtures
- Mock with `unittest.mock.patch` or `pytest-mock`
- Use `pytest.raises` for exception testing
- Organize tests to mirror source structure
- Use `pytest.mark.parametrize` for data-driven tests
- Aim for 80%+ coverage on business logic
- Use `factory_boy` or fixtures for test data, not hardcoded values

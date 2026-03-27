---
name: react-component
description: Generate a standard React component with TypeScript, proper file structure, and co-located tests. Adapts to project conventions (Tailwind vs CSS modules, named vs default exports, etc.).
---

# React Component Generator

Generate a complete, production-ready React component with TypeScript.

## Usage

```
/react-component <ComponentName> [description]
```

**Examples:**
```
/react-component UserProfile
/react-component PaymentForm A form for collecting payment details
/react-component DataTable Sortable, paginated table with filter support
```

## What Gets Generated

1. **Component file** — `src/components/<ComponentName>/<ComponentName>.tsx`
2. **Index file** — `src/components/<ComponentName>/index.ts`
3. **Test file** — `src/components/<ComponentName>/<ComponentName>.test.tsx`
4. **Stories file** (optional) — `src/components/<ComponentName>/<ComponentName>.stories.tsx`

## Component Template

```typescript
// src/components/<ComponentName>/<ComponentName>.tsx
import React from 'react';

interface <ComponentName>Props {
  // Define props here
  className?: string;
  children?: React.ReactNode;
}

export function <ComponentName>({ className, children }: <ComponentName>Props) {
  return (
    <div className={className}>
      {children}
    </div>
  );
}
```

## Instructions

When this skill is invoked:

1. Ask for component name if not provided
2. Detect project conventions:
   - Check for `tailwind.config.js` → use Tailwind classes
   - Check for `*.module.css` usage → use CSS modules
   - Check existing components for naming/export patterns
3. Detect test framework:
   - Check for `jest.config.*` → use Jest + Testing Library
   - Check for `vitest.config.*` → use Vitest
4. Generate all component files following detected conventions
5. Add component to barrel export if `src/components/index.ts` exists

## Conventions to Detect

| Convention | Detection | Default |
|------------|-----------|---------|
| Styling | tailwind.config.js, *.module.css | className prop only |
| Exports | Existing component files | Named export |
| Test setup | jest.config.*, vitest.config.* | Jest |
| Stories | .storybook/ directory | Skip stories |
| Path alias | tsconfig.json paths | Use relative imports |

## Quality Requirements

- TypeScript interfaces for all props (no `any`)
- Proper displayName for debugging
- aria attributes for accessibility where appropriate
- Test covers: renders without errors, handles empty state, handles key interactions

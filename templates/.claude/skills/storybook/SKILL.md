---
name: storybook
description: Storybook story generation, interaction tests, and component documentation. Triggers when creating or modifying React/Vue/Svelte components. Generates CSF3 stories with args, play functions, and autodocs.
---

# Storybook

## When to Activate

Trigger when:
- Creating a new React/Vue/Svelte component
- User mentions "story", "storybook", "stories"
- A component file exists without a corresponding `.stories.ts` file
- User asks for component documentation or interaction tests

## Story File Generation (CSF3)

When creating a component, generate a `.stories.ts` file alongside it:

```typescript
import type { Meta, StoryObj } from '@storybook/react'
import { ComponentName } from './ComponentName'

const meta = {
  component: ComponentName,
  tags: ['autodocs'],
  parameters: {
    layout: 'centered',  // or 'fullscreen', 'padded'
  },
} satisfies Meta<typeof ComponentName>

export default meta
type Story = StoryObj<typeof meta>

// Default state
export const Default: Story = {
  args: {
    // Map all required props
  },
}

// Variant for each significant prop combination
export const Loading: Story = {
  args: {
    isLoading: true,
  },
}

export const Error: Story = {
  args: {
    error: 'Something went wrong',
  },
}

export const Empty: Story = {
  args: {
    items: [],
  },
}
```

### Story Naming Rules

- One story per significant visual/behavioral state
- Name stories by STATE, not by prop values: `Loading`, `Empty`, `WithError`, `Disabled`
- Always include: `Default`, at least one error state, at least one edge case
- Use PascalCase for story names

## Args and ArgTypes

Map TypeScript props to Storybook controls:

```typescript
const meta = {
  component: Button,
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'ghost'],
    },
    size: {
      control: 'radio',
      options: ['sm', 'md', 'lg'],
    },
    disabled: { control: 'boolean' },
    onClick: { action: 'clicked' },  // Log actions
    color: { control: 'color' },
    count: { control: { type: 'range', min: 0, max: 100 } },
  },
} satisfies Meta<typeof Button>
```

**Auto-infer when possible.** If the component uses TypeScript, Storybook auto-generates controls from prop types. Only define `argTypes` when you need custom controls.

## Interaction Tests (Play Functions)

Add `play` functions for user interaction testing:

```typescript
import { expect } from 'storybook/test'
import { userEvent, within } from '@storybook/test'

export const SubmitForm: Story = {
  args: { /* form defaults */ },
  play: async ({ canvasElement, step }) => {
    const canvas = within(canvasElement)

    await step('Fill form', async () => {
      await userEvent.type(canvas.getByLabelText('Email'), 'user@test.com')
      await userEvent.type(canvas.getByLabelText('Password'), 'password123')
    })

    await step('Submit', async () => {
      await userEvent.click(canvas.getByRole('button', { name: /submit/i }))
    })

    await step('Verify success', async () => {
      await expect(canvas.getByText('Welcome')).toBeInTheDocument()
    })
  },
}
```

### When to Add Play Functions

- Forms with validation → test submit, error states, field interactions
- Toggle/accordion components → test open/close behavior
- Modals/dialogs → test open, close, backdrop click
- Lists with actions → test add, remove, reorder
- Any component with user-driven state changes

## Decorators

Wrap stories with context providers:

```typescript
const meta = {
  component: UserProfile,
  decorators: [
    // Theme provider
    (Story) => (
      <ThemeProvider theme={lightTheme}>
        <Story />
      </ThemeProvider>
    ),
    // Router context
    (Story) => (
      <MemoryRouter initialEntries={['/profile']}>
        <Story />
      </MemoryRouter>
    ),
  ],
} satisfies Meta<typeof UserProfile>
```

**Use decorators when:**
- Component requires ThemeProvider, Redux store, Router, IntlProvider
- Component needs specific layout wrapper (max-width, padding)
- Component relies on context that doesn't exist in isolation

## Testing Setup

### Vitest Addon (Recommended)

```typescript
// .storybook/vitest.setup.ts
import { setProjectAnnotations } from '@storybook/react'
import * as projectAnnotations from './preview'

setProjectAnnotations(projectAnnotations)
```

Run stories as tests:
```bash
npx vitest --project storybook
```

### Visual Regression (Chromatic)

```bash
npm install -D @chromatic-com/storybook
npx chromatic --project-token=<token>
```

Captures pixel-perfect snapshots of every story. Shows diffs in PR checks.

### Accessibility

```bash
npx storybook add @storybook/addon-a11y
```

Auto-runs axe-core accessibility audits on every story. Failures show in the Accessibility panel.

## File Structure Convention

```
src/components/
├── Button/
│   ├── Button.tsx              # Component
│   ├── Button.stories.ts       # Stories (CSF3)
│   ├── Button.test.ts          # Unit tests
│   └── index.ts                # Re-export
```

Stories file is ALWAYS co-located with the component. Name: `{Component}.stories.ts`.

## Integration with react-component Skill

When the `react-component` skill creates a new component, this skill should auto-generate the stories file. The stories file includes:
- `Default` story with all required props
- One story per variant/state (loading, error, empty, disabled)
- `play` function if the component has interactive behavior
- `autodocs` tag for automatic documentation
- Appropriate decorators if the component needs providers

## Design System Stories

For design system components, add comprehensive coverage:

```typescript
// Size variants
export const Small: Story = { args: { size: 'sm' } }
export const Medium: Story = { args: { size: 'md' } }
export const Large: Story = { args: { size: 'lg' } }

// Color variants
export const Primary: Story = { args: { variant: 'primary' } }
export const Secondary: Story = { args: { variant: 'secondary' } }
export const Ghost: Story = { args: { variant: 'ghost' } }

// Composition
export const ButtonGroup: Story = {
  render: () => (
    <div style={{ display: 'flex', gap: '8px' }}>
      <Button variant="primary">Save</Button>
      <Button variant="secondary">Cancel</Button>
      <Button variant="ghost">Reset</Button>
    </div>
  ),
}
```

## Common Mistakes to Avoid

- Don't duplicate component logic in stories — use `args` to drive variants
- Don't hardcode data — use `args` so controls work
- Don't skip error/empty states — these are the most useful stories
- Don't use `any` for Meta type — use `satisfies Meta<typeof Component>`
- Don't forget `tags: ['autodocs']` — it enables free documentation
- Don't put stories in a separate `/stories` directory — co-locate with component

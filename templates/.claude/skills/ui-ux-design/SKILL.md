---
name: ui-ux-design
description: Design intelligence for UI/UX work. Provides industry-specific design rules, pre-delivery checklist, and accessibility guidelines. Triggers on component/UI file creation.
---

# UI/UX Design Intelligence

## When to Activate

Trigger when:
- Creating or modifying React/Vue/Svelte components
- Working on CSS, Tailwind, or styling files
- Designing layouts, forms, or navigation
- User mentions "design", "UI", "UX", "accessibility", "responsive"

## Pre-Delivery UX Checklist

Before marking any UI work as complete, verify ALL items:

1. **Contrast**: Text meets WCAG AA (4.5:1 normal, 3:1 large text)
2. **Touch targets**: Interactive elements are minimum 44x44px on mobile
3. **Cursor**: All clickable elements have `cursor: pointer`
4. **Focus states**: All interactive elements have visible focus indicators
5. **Loading states**: Async operations show loading feedback
6. **Empty states**: Lists/tables have meaningful empty state content
7. **Error states**: Form validation shows inline errors with guidance
8. **Responsive**: Layout works on 320px, 768px, 1024px, 1440px widths
9. **Keyboard navigation**: All functionality accessible via keyboard (Tab, Enter, Escape)
10. **Screen reader**: Images have alt text, buttons have labels, landmarks used
11. **Color independence**: Information not conveyed by color alone
12. **Typography**: Body text 16px+, line-height 1.5+, max line length ~70ch
13. **Consistency**: Spacing, colors, and typography follow design system tokens

## Design Anti-Patterns to Avoid

- Generic AI purple/pink gradients (unless the brand specifically uses them)
- Icon-only buttons without labels or tooltips
- Infinite scroll without "back to top" or position memory
- Modal dialogs for non-critical information
- Auto-playing media without user consent
- Light gray text on white backgrounds (contrast fail)
- Horizontal scrolling on mobile for primary content

## Design Tokens Pattern

When a project has a design system, USE IT:
```
// Prefer tokens over raw values
color: var(--color-primary)     // not: color: #3b82f6
spacing: var(--spacing-4)       // not: margin: 16px
font-size: var(--text-base)     // not: font-size: 14px
```

## Accessibility Quick Reference

- `role="button"` on non-button clickable elements
- `aria-label` on icon-only buttons
- `aria-live="polite"` for dynamic content updates
- `aria-expanded` on toggleable sections
- Semantic HTML: `<nav>`, `<main>`, `<aside>`, `<header>`, `<footer>`
- Skip navigation link as first focusable element

# Figma Build Checklist (Download-Ready)

- [ ] Create pages: 01_DesignSystem, 02_Wireframes, 03_HighFidelity/Mobile, 04_HighFidelity/Web, 05_Prototypes, 06_Subscription, 07_DietPlans.
- [ ] Import design tokens (`design-tokens.json`) into Tokens Studio.
- [ ] Create component library from `components.csv` using Auto Layout + variants.
- [ ] Build all screen frames listed in `screens.csv`.
- [ ] Apply constraints and responsive behavior for mobile/tablet/desktop.
- [ ] Add interaction links based on `prototype-flows.md`.
- [ ] Validate accessibility (WCAG AA contrast + min tap targets 44x44).
- [ ] Export deliverables:
  - [ ] PNG preview set (2x)
  - [ ] PDF storyboard
  - [ ] Publish component library
  - [ ] Shareable Figma prototype links

## Export naming convention
`FitLens_[Platform]_[ScreenName]_[State]_[v1].png`

## Developer handoff
- Include redlines for spacing, typography, and token references.
- Map components to implementation names (Material 3 / MUI compatible).

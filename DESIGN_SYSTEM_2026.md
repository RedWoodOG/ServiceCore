# Offline-Portal Design System 2.0 (2026 Edition)

## Philosophy: "The Glass Cockpit"

The 2026 design update ("Gemini Upgrade") focuses on adapting field service interfaces for modern high-resolution OLED displays while minimizing cognitive load for technicians in the field.

### Key Research & Principles

1. **Mica & Glassmorphism (Neumorphism 2.0)**
    * **Why:** Provides depth and hierarchy without checking "flat" UI surfaces that feel cheap.
    * **Implementation:** `GlassCard` widget using `BackdropFilter` and translucent gradients (`AppGradients.glassSurface`).
    * **Benefit:** Allows context (map or list content) to be vaguely visible behind overlays, maintaining spatial awareness.

2. **Cognitive Load Reduction**
    * **Why:** Field techs function in high-stress, distracting environments.
    * **Implementation:**
        * **High Contrast Texts:** `AppTypography` ensures legibility.
        * **Subtle Gradients:** `AppGradients.deepBackground` replaces pitch black to reduce eye strain while maintaining battery savings.
        * **Clear Status Indication:** New status badges with "glow" borders for instant recognition.

3. **Adaptive Interactions**
    * **Why:** Technicians need feedback.
    * **Implementation:** `InkWell` splashes within glass surfaces provide immediate touch feedback.

## New Components

### `GlassCard`

The core building block for content.
* **Location:** `lib/widgets/glass_card.dart`
* **Usage:** Replaces standard `Card` and `Container`.
* **Properties:**
  * `hasShine`: Adds a subtle top-left to bottom-right specular highlight.
  * `activeBorderColor`: Allows dynamic tinting for status (e.g., Blue for "Open").

### `AppTheme` Updates

- **`AppGradients`**: New class for standardized gradients.
* **`AppGlass`**: Primitives for blur strength and border opacity.
* **`AppAnimations`**: Standardized duration constants (200ms, 300ms) for consistent feel.

## Future Roadmap (Next Steps)

1. **Animated Transitions**: Implement `OpenContainer` for card-to-detail expansions.
2. **Context-Aware Home**: Use the "Morning Briefing" slot to show shift-specific data (Morning = Traffic/Weather, Evening = Sync Status).
3. **Haptic Feedback**: Add `HapticFeedback.lightImpact()` to `GlassCard` taps for tactile confirmation.

# typed: true
# check-errors: true
# options: showDocs

values = ['a', 'long']
minimum = values.min { |left, right| left.length <=> right.length }
maximum = values.max { |left, right| left.length <=> right.length }
minimum&.upcase
maximum&.downcase

# Positional-count calls already use ordinary Array dispatch.
values.min(2) { |left, right| left.length <=> right.length }.each(&:upcase)
values.max(2) { |left, right| left.length <=> right.length }.each(&:downcase)

# Empty receivers still typecheck their comparator without an internal error.
[].min { |left, right| 0 }
[].max { |left, right| 0 }

# Preserve the precise, non-nil result for the existing no-block shortcut.
values.min.upcase
values.max.downcase

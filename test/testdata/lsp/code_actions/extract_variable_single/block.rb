# typed: true
# selective-apply-code-action: refactor.extract
# enable-experimental-lsp-extract-to-variable: true

[].each { |x| return 0 if x.foo}
#                         ^^^^^ apply-code-action: [A] Extract Variable

1.times do |x| 1 + 123 end
#                  ^^^ apply-code-action: [B] Extract Variable

1.times do |x| 1 + 1; 1 + 1234 end
#                         ^^^^ apply-code-action: [C] Extract Variable

1.times do |x|
  1 + 12345
#     ^^^^^ apply-code-action: [D] Extract Variable
end

1.times do |x|
  1 + 1
  1 + 123456
#     ^^^^^^ apply-code-action: [E] Extract Variable
end

1.times do |x|
  1 + 1
  1 + 2; 1 + 1234567
#            ^^^^^^^ apply-code-action: [F] Extract Variable
end

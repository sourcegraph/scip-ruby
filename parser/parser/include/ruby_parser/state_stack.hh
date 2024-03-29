#ifndef RUBY_PARSER_STATE_STACK_HH
#define RUBY_PARSER_STATE_STACK_HH

#include <memory>
#include <vector>

namespace ruby_parser {
class state_stack {
    std::vector<bool> stack;

public:
    void push(bool state);
    bool pop();
    void lexpop();
    void clear();
    bool active() const;
};
} // namespace ruby_parser

#endif

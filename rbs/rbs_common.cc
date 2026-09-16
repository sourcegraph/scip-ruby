#include "rbs/rbs_common.h"

namespace sorbet::rbs {

rbs_string_t makeRBSString(std::string_view str) {
    return rbs_string_new(str.data(), str.data() + str.size());
}

core::LocOffsets RBSDeclaration::commentLoc() const {
    return comments.front().commentLoc.join(comments.back().commentLoc);
}

RBSDeclaration RBSDeclaration::withoutPrefix(size_t length) const {
    ENFORCE(length <= string.size());
    CommentsVector result;
    for (auto &comment : comments) {
        if (length >= comment.string.size() && &comment != &comments.back()) {
            length -= comment.string.size();
            continue;
        }
        auto remaining = comment;
        remaining.typeLoc.beginLoc += length;
        remaining.string.remove_prefix(length);
        result.emplace_back(remaining);
        length = 0;
    }
    return RBSDeclaration{std::move(result)};
}

core::LocOffsets RBSDeclaration::firstLineTypeLoc() const {
    return comments.front().typeLoc;
}

core::LocOffsets RBSDeclaration::fullTypeLoc() const {
    return comments.front().typeLoc.join(comments.back().typeLoc);
}

core::LocOffsets RBSDeclaration::typeLocFromRange(const rbs_location_range &range) const {
    int rangeOffset = range.start_byte;
    int rangeLength = range.end_byte - range.start_byte;

    for (const auto &comment : comments) {
        int commentTypeLength = comment.typeLoc.endLoc - comment.typeLoc.beginLoc;
        if (rangeOffset < commentTypeLength) {
            auto beginLoc = comment.typeLoc.beginLoc + rangeOffset;
            auto endLoc = beginLoc + rangeLength;

            if (rangeLength > commentTypeLength) {
                endLoc = comment.typeLoc.endLoc;
            }

            return core::LocOffsets{beginLoc, endLoc};
        }
        rangeOffset -= commentTypeLength;
    }
    return comments.front().typeLoc;
}

} // namespace sorbet::rbs

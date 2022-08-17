---
name: Report missing/poor/incorrect code intelligence
about: This is for undesirable behavior when using features like Find references, Go to definition, hover documentation etc.
labels: bug, unconfirmed
---

#### Input

<!--
TODO: Please paste your anonymized, minimal code snippet here.
If you do not have time to minimize, it is OK to paste a non-minimal
snippet too. If you do not have time to anonymize, it is OK
to skip this, but that may make it harder to triage your issue.

It is also OK to paste information about multiple files.
If you're sharing a link to a minimal repo,
please mention the git SHA!
-->

```ruby
```

#### Undesirable behavior

<!-- If your code is OSS, please share a Sourcegraph.com link
and a screenshot of the entire browser window. -->

The functionality for the feature(s):
<!--
- Find references
- Go to definition
- Hover documentation
- Other: <more info here>
-->

has undesirable behavior:
<!--
- Does not have any code intelligence at all
- Code intelligence is low-quality; could do with improvements
- Has incorrect information
- Other: <more info here>
-->

in the following contexts that I've seen:
<!--
- Within a single function
- Across functions within the same file
- Across files within the same gem
- Across different gems
-->

#### Expected behavior

<!-- What should work differently? -->

#### scip-ruby-debug indexing output

<!--
Temporarily replace the 'scip-ruby' in your gemspec or Gemfile
with a dependency on the same version of scip-ruby-debug instead
(by editing your gemspec or Gemfile) and re-run the indexing step.

If you see a crash (e.g. an assertion being hit), please report it below:
--->

After replacing `scip-ruby` with `scip-ruby-debug` in my Gemfile/gemspec,
and running `bundle install`, I re-ran `bundle exec scip-ruby <paste args>`
<!-- and that completed successfully without crashing. -->
and got this<!-- anonymized --> crash output:

```txt
```

#### Configuration information

I ran the following commands:

```bash
ruby --version
bundle --version
bundle info sorbet
bundle info scip-ruby
```

and got this<!-- anonymized --> output:

```txt
```

#### (Optional) Additional info

<!-- Any additional information you'd like to share. For example,
if you're using a tool other than bundler for managing code. -->

<!-- THANK YOU for taking the time to fill out this bug report! 🙌🏽 -->

---
name: Report a crash
about: This is for crashes encountered in scip-ruby.
labels: bug, crash, unconfirmed
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

#### Sorbet type-checking output

I ran `bundle exec srb tc` and got this<!-- anonymized --> output:

```txt
```

#### scip-ruby indexing output

I ran `bundle exec scip-ruby <paste args here>`
and got this<!-- anonymized --> output:

```txt
```

#### scip-ruby-debug indexing output

<!--
Temporarily replace the 'scip-ruby' in your gemspec or Gemfile
with a dependency on the same version of scip-ruby-debug instead
(by editing your gemspec or Gemfile) and re-run the indexing step.

Report an assertion failure and/or stack traces below.
--->

After replacing `scip-ruby` with `scip-ruby-debug` in my Gemfile/gemspec,
and running `bundle install`, I re-ran `bundle exec scip-ruby <paste args>`
and got this<!-- anonymized --> output:

```txt
```

#### Configuration information

I ran the following commands:

```bash
uname -A
ruby --version
bundle --version
bundle info srb
bundle info scip-ruby
```

and got this output:

```txt
```

#### (Optional) Additional info

<!-- Any additional information you'd like to share. For example,
if you're using a tool other than bundler for managing code. -->

<!-- THANK YOU for taking the time to fill out this bug report! 🙌🏽 -->

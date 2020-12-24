# typed: strict
T.let("foo", String)
T.assert_type!("foo", String)
T.cast("foo", String) # error: Useless cast
T.unsafe(String)
T.nilable(String)
T.proc
T.proc.params(arg0: String, arg1: Integer)
T.class_of(String)
T.noreturn
T.enum([:a, :b])

T.untyped
T.any(String) # error: Not enough arguments provided for method `any` on `T.class_of(T)`
T.all(String) # error: Not enough arguments provided for method `all` on `T.class_of(T)`
T.any(String, Integer, Symbol)
T.all(String, Integer, Symbol)


T.let # error: Not enough arguments provided for method `let` on `T.class_of(T)`. Expected: `2`, got: `0`
T.assert_type! # error: Not enough arguments provided for method `assert_type!` on `T.class_of(T)`. Expected: `2`, got: `0`
T.cast # error: Not enough arguments provided for method `cast` on `T.class_of(T)`. Expected: `2`, got: `0`
T.unsafe # error: Not enough arguments provided for method `unsafe` on `T.class_of(T)`. Expected: `1`, got: `0`
T.nilable # error: Not enough arguments provided for method `nilable` on `T.class_of(T)`. Expected: `1`, got: `0`
T.proc(String) # error: Too many arguments provided for method `T.proc`. Expected: `0`, got: `1`
T.class_of # error: Not enough arguments provided for method `class_of` on `T.class_of(T)`. Expected: `1`, got: `0`
T.noreturn(String) # error: Too many arguments provided for method `T.noreturn`. Expected: `0`, got: `1`
T.enum # error: Not enough arguments provided for method `enum` on `T.class_of(T)`. Expected: `1`, got: `0`

T.untyped(String) # error: Too many arguments provided for method `T.untyped`. Expected: `0`, got: `1`
T.any # error: Not enough arguments provided for method `any` on `T.class_of(T)`. Expected: `2+`, got: `0`
T.all # error: Not enough arguments provided for method `all` on `T.class_of(T)`. Expected: `2+`, got: `0`

T.assert_type!(false, T::Boolean)

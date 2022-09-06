 # typed: true
 
 # NOTE[implicit-arg-passing]: In this example, Sorbet generates a CFG where
 # a and b are implicitly passed to a method call at the 'super'.
 # In theory, we could emit references to a and b at the 'super'
 # call (following Sorbet strictly), but RubyMine doesn't do this.
 # So let's not emit those.
 #
 # This only seems to trigger when there are two parameters, not one.
 # A Sorbet bug, perhaps?
 #
 # bb0[rubyRegionId=0, firstDead=8]():
 #     <self>: C = cast(<self>: NilClass, C);
 #     a: T.untyped = load_arg(a)
 #     b: T.untyped = load_arg(b)
 #     <blk>: T.untyped = load_arg(<blk>)
 #     <cfgAlias>$4: T.class_of(<Magic>) = alias <C <Magic>>
 #     <statTemp>$6: Symbol(:<super>) = :<super>
 #     <returnMethodTemp>$2: T.untyped = <cfgAlias>$4: T.class_of(<Magic>).<call-with-block>(<self>: C, <statTemp>$6: Symbol(:<super>), <blk>: T.untyped, a: T.untyped, b: T.untyped)
 #     <finalReturn>: T.noreturn = return <returnMethodTemp>$2: T.untyped
 class C
#      ^ definition [..] C#
   def f(a, b)
#      ^ definition [..] C#f().
#        ^ definition local 1~#3809224601
#           ^ definition local 2~#3809224601
     super
#    ^^^^^ reference [..] `<Class:<Magic>>`#`<call-with-block>`().
   end
 end

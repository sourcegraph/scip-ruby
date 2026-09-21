# typed: true
# check-errors: true

module Types
  Text = T.type_alias { String }
  Checked = T.type_alias { Text }.checked(:never)
  Other = T.type_alias { Integer }

  class Box
    extend T::Sig, T::Generic
    Elem = type_member
  end
end

module OtherTypes
  Text = T.type_alias { Integer }
end

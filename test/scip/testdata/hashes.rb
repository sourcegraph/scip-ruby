# typed: true

def hashes(h, k)
  h["hello"] = "world"
  old = h["world"]
  h[k] = h[old]
end

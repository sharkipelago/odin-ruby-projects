# frozen_string_literal: true

def substrings(string, valid_substrings)
  ret_hash = {}
  valid_substrings.each do |substring|
    ret_hash[substring] = string.scan(Regexp.new(substring, true)).length
  end
  ret_hash.reject! { |_k, v| v.zero? }
end

# frozen_string_literal: true

def shift_char(ascii, shift_by)
  is_upcase = ascii.between?('A'.ord, 'Z'.ord)
  start_ascii = is_upcase ? 'A'.ord : 'a'.ord
  end_ascii = is_upcase ? 'Z'.ord : 'z'.ord
  return ascii.chr unless ascii.between?(start_ascii, end_ascii)

  new_ascii = ascii + shift_by
  return shift_char((new_ascii - end_ascii) + start_ascii - 1, 0) if new_ascii > end_ascii

  new_ascii.chr
end

def caesar_cipher(string, shift_by)
  string.split('').map { |char| shift_char(char.ord, shift_by) }.join
end

puts caesar_cipher('What a string!', 5)
puts caesar_cipher('ABCDEFG?<>>?HIJKL!', 2)

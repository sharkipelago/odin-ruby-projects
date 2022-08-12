# frozen_string_literal: true

def stock_picker(days)
  min = days.min
  max = days.max
  return [days.index(min), days.index(max)] if days.index(min) < days.index(max)

  left = 0
  buy = 0
  right = 1
  sell = 1

  while right < days.length
    if days[left] > days[right]
      left = right
    elsif days[sell] - days[buy] < days[right] - days[left]
      buy = left
      sell = right
    end
    right += 1
  end

  [buy, sell]
end

# stock_picker([17,3,6,9,15,8,6,1,10])

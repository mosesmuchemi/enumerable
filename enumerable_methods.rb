# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    item_select = []
    my_each { |i| item_select << i if yield(i) }
    item_select
  end
end

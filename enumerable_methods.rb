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

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_all?(param = nil)
    if block_given?
      my_each { |i| return false unless yield(i) }
    elsif param.class == Class
      my_each { |i| return false unless i.class == param }
    elsif param.class == Regexp
      my_each { |i| return false unless i =~ param }
    elsif param.nil?
      my_each { |i| return false unless i }
    else
      my_each { |i| return false unless i == param }
    end
    true
  end

  def my_any?(param = nil)
    if block_given?
      my_each { |i| return true if yield(i) }
    elsif param.class == Class
      my_each { |i| return true if i.class == param }
    elsif param.class == Regexp
      my_each { |i| return true if i =~ param }
    elsif param.nil?
      my_each { |i| return true if i }
    else
      my_each { |i| return true if i == param }
    end
    false
  end

  def my_none?(param = nil)
    if block_given?
      my_each { |i| return false if yield(i) }
    elsif param.class == Class
      my_each { |i| return false if i.class == param }
    elsif param.class == Regexp
      my_each { |i| return false if i =~ param }
    elsif param.nil?
      my_each { |i| return false if i }
    else
      my_each { |i| return false if i == param }
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    true
  end

  def my_count(items = nil)
    count = 0
    if block_given?
      my_each { |i| count += 1 if yield(i) == true }
    elsif items.nil?
      my_each { count += 1 }
    else
      my_each { |i| count += 1 if i == items }
    end
    count
  end

  # refactored to take in proc or block
  def my_map(arg = nil)
    return :my_map unless block_given?

    arr = []
    my_each do |i|
      arr << !arg.nil? ? arg.call(i) : yield(i)
    end
    arr
  end

  def my_inject(arg = self[0])
    my_each_with_index do |value, index|
      arg = yield(arg, value) if index.positive?
    end
    arg
  end
end

def multiply_els(arr)
  arr.my_inject { |a, b| a * b }
end

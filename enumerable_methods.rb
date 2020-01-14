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
    return to_enum unless block_given?

    arr = []
    my_each do |i|
      arr.push(!arg.nil? ? arg.call(i) : yield(i))
    end
    arr
  end

  def my_inject(accumulator = nil, operation = nil, &block)
    if operation.nil? && block.nil?
      operation = accumulator
      accumulator = nil
    end
    block = case operation
            when Symbol
              ->(acc, value) { acc.send(operation, value) }
            when nil
              block
            else
              raise ArgumentError, 'the operation provided must be a symbol'
            end
    if accumulator.nil?
      ignore_first = true
      accumulator = first
    end

    index = 0

    each do |element|
      accumulator = block.call(accumulator, element) unless ignore_first && index.zero?
      index += 1
    end
    accumulator
  end

  def my_inject_binary_operation(the_memo, operator, enum)
    return "#{operator} is not a symbol" unless operator.is_a?(Symbol)

    enum.each { |item| the_memo = the_memo.send(operator, item) }
    the_memo
  end
end

# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
def multiply_els(arr)
  arr.my_inject { |a, b| a * b }
end

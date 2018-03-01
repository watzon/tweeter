module Tweeter::Enumerable(T)
  include ::Enumerable(T)

  def each
    start = 0
    loop do
      @collection[start..-1].each do |element|
        yield element
      end
      start = [@collection.size, start].max
      break if last?
      fetch_next_page
    end
  end

  def empty?
    size < 1
  end

  private def last?
    true
  end
end

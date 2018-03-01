module Tweeter::Enumerable(T)
  include ::Enumerable(T)

  def each(start = 0, &block : T ->)
    @collection[start..-1].each do |element|
      yield element
    end
    unless last?
      start = [@collection.size, start].max
      fetch_next_page
      each(start, &block)
    end
  end

  private def last?
    true
  end
end

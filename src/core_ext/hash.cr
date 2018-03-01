class Hash(K, V)
  def sort
    to_a.sort.to_h
  end

  # Returns a tuple populated with the elements at the given indexes. Invalid indexes are ignored.
  def values_at?(*indexes : K)
    indexes.map { |index| self[index]? }
  end

  def to_query_string
    query = HTTP::Params.build do |form_builder|
      each do |key, value|
        form_builder.add(key.to_s, value)
      end
    end
    query.empty? ? "" : "?" + query
  end

  # Returns a new hash with all keys converted using the block operation.
  # The block can change a type of keys.
  #
  # ```
  # hash = {:a => 1, :b => 2, :c => 3}
  # hash.transform_keys { |key| key.to_s } # => {"A" => 1, "B" => 2, "C" => 3}
  # ```
  def transform_keys(&block : K -> K2) forall K2
    each_with_object({} of K2 => V) do |(key, value), memo|
      memo[yield(key)] = value
    end
  end

  # Returns a new hash with the results of running block once for every value.
  # The block can change a type of values.
  #
  # ```
  # hash = {:a => 1, :b => 2, :c => 3}
  # hash.transform_values { |value| value + 1 } # => {:a => 2, :b => 3, :c => 4}
  def transform_values(&block : V -> V2) forall V2
    each_with_object({} of K => V2) do |(key, value), memo|
      memo[key] = yield(value)
    end
  end

  # Destructively transforms all keys using a block. Same as transform_keys but modifies in place.
  # The block cannot change a type of keys.
  #
  # ```
  # hash = {"a" => 1, "b" => 2, "c" => 3}
  # hash.transform_key! { |key| key.succ }
  # hash # => {"b" => 1, "c" => 2, "d" => 3}
  def transform_keys!(&block : K -> K)
    current = @first
    while current
      current.key = yield(current.key)
      current = current.fore
    end
  end

  # Destructively transforms all values using a block. Same as transform_values but modifies in place.
  # The block cannot change a type of values.
  #
  # ```
  # hash = {:a => 1, :b => 2, :c => 3}
  # hash.transform_values! { |value| value + 1 }
  # hash # => {:a => 2, :b => 3, :c => 4}
  def transform_values!(&block : V -> V)
    current = @first
    while current
      current.value = yield(current.value)
      current = current.fore
    end
  end
end

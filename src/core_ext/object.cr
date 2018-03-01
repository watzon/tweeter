class Object
  macro equalize(*args, other_class = nil, strict = true)
    {{ other_class = other_class ? other_class.id : @type.id }}
    def ==(other : {{ other_class }})
      {% if strict %}
        return false unless other.class == {{ other_class }}
      {% end %}
      {% for arg in args %}
        return false unless {{ arg.first.id }} == other.{{ arg.last.id }}
      {% end %}
      true
    end
  end

  macro alias_method(new_name, existing_method)
    def {{ new_name.id }}(*args, **kwargs)
      {{ existing_method.id }}(*args, **kwargs)
    end
  end
end

require "json"

module Tweeter
  abstract class Base
    macro create_initializer(_properties_, debugger = false)
      # This flag makes sure that we know this class's initializer
      # was created with this macro
      MACRO_INITIALIZED = true

      # If there is a superclass take the superclass's properties and merge
      # them with this class's properties
      {% unless @type.superclass.id == "Reference" %}
        {% unless @type.superclass.constant("MACRO_INITIALIZED") == nil %}
          {% for key, value in @type.superclass.constant("BASE_PROPS") %}
            {% _properties_[key] = value if _properties_[key].is_a?(NilLiteral) %}
          {% end %}
        {% end %}
      {% end %}

      # Create a reference to the passed in properties. This will only be
      # used when a class extends another class
      BASE_PROPS = {{_properties_}}

      # Normalize the keys in _properties_
      {% for key, value in _properties_ %}
        {% unless value.is_a?(HashLiteral) || value.is_a?(NamedTupleLiteral) %}
          {% _properties_[key] = {type: value} %}
        {% end %}
      {% end %}

      # Create instance variables. If `nilable` is true set the variable to nilable.
      {% for key, value in _properties_ %}
        @{{key.id}} : {{ value[:type] }} {{ (value[:nilable] ? "?" : "").id }}

        # Create setters
        {% if value[:setter] == nil ? true : value[:setter] %}
          def {{key.id}}=(_{{key.id}} : {{value[:type]}} {{ (value[:nilable] ? "?" : "").id }})
            @{{key.id}} = _{{key.id}}
          end
        {% end %}

        # Create getters
        {% if value[:getter] == nil ? true : value[:getter] %}
          def {{key.id}}
            @{{key.id}}
          end
        {% end %}

        # Create `variable_present?` methods if required
        {% if value[:presence] %}
          @{{key.id}}_present : Bool = false

          def {{key.id}}_present?
            @{{key.id}}_present
          end
        {% end %}
      {% end %}

      # Create an initializer that accepts named arguments for each value
      # in _properties_. Nilable arguments will default to `nil` and come
      # after required arguments.
      def initialize(
        {% for key, value in _properties_ %}
          {% if !value[:nilable] && !value[:mustbe] && value[:mustbe] != false && !value[:default] && value[:default] != false %}
            {{key.id}},
          {% end %}
        {% end %}
        {% for key, value in _properties_ %}
          {% if value[:nilable] && !value[:mustbe] && value[:mustbe] != false && !value[:default] && value[:default] != false %}
            {{key.id}} {{ (value[:nilable] ? "= nil, " : ", ").id }}
          {% end %}
        {% end %}
        {% for key, value in _properties_ %}
          {% if value[:default] || value[:default] == false %}
            {{key.id}} = {{ value[:default] }},
          {% end %}
        {% end %}
        )
        {% for key, value in _properties_ %}
          {% if value[:mustbe] || value[:mustbe] == false %}
          @{{key.id}} = {{value[:mustbe]}}
          {% elsif value[:type].is_a?(Path) && value[:type].resolve? %}
            {% kind = value[:type].resolve %}
            {% if kind.constant("MACRO_INITIALIZED") %}
              if {{key.id}}.is_a?(NamedTuple)
                {{key.id}} = {{kind.id}}.new({{key.id}})
              end
            {% end %}
            @{{key.id}} = {{key.id}}
          {% else %}
            @{{key.id}} = {{key.id}}
          {% end %}
        {% end %}
      end

      def self.new(other : {{@type.id}})
        other.dup
      end

      def self.new(properties : NamedTuple)
        new(**properties)
      end

      # Now wrap `JSON.mapping`
      JSON.mapping({{_properties_}})

      {% if debugger %}
       {{debug}}
      {% end %}
    end

    macro create_initializer(**_properties_)
      properties({{properties}})
    end
  end
end

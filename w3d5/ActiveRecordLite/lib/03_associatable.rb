require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = { foreign_key: "#{name}_id".to_sym, class_name: name.to_s.camelcase, primary_key: :id }

    defaults.keys.each do |key|
      send("#{key}=", options[key] || defaults[key])
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = { foreign_key: "#{self_class_name.underscore}_id".to_sym, class_name: name.to_s.singularize.camelcase, primary_key: :id }

    defaults.keys.each do |key|
      send("#{key}=", options[key] || defaults[key])
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name, options)
    define_method(name) do
      options = self.class.assoc_options[name]
      primary = send(options.foreign_key)
      options.model_class.where(options.primary_key => primary).first
    end
  end

  def has_many(name, options = {})
    self_class_name = belongs_to(name, options).to_s.capitalize.singularize
    option = HasManyOptions.new(name, self_class_name, options)
    define_method(name) do
      class_name = option.model_class
      primary = self.send(option.primary_key)
      class_name.where({option.foreign_key => primary})
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
    @assoc_options ||= {}
    @assoc_options
  end
end

class SQLObject
  extend Associatable
end

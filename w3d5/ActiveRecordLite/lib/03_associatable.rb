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
    @class_name.to_s.downcase + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @class_name = options[:class_name] || "#{name.to_s.camelcase}"
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @class_name = options[:class_name] || "#{name.to_s.singularize.camelcase}"
    @foreign_key = options[:foreign_key] || "#{self_class_name.to_s.underscore}_id".to_sym
    @primary_key = options[:primary_key] || :id
    # p name; p self_class_name; p options
    # p @class_name; p @foreign_key; p @primary_key

  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    option = BelongsToOptions.new(name, options)
    define_method(name) do
      class_name = option.model_class
      foreign = self.send(option.foreign_key.to_sym)
      class_name.where({id: foreign}).first
    end
  end

  def has_many(name, options = {})
    # debugger
    self_class_name = belongs_to(name, options).to_s.capitalize.singularize
    option = HasManyOptions.new(name, self_class_name, options)
    define_method(name) do
      class_name = option.model_class
      primary = self.send(option.primary_key.to_sym)
      class_name.where({option.foreign_key => primary})
    end
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end

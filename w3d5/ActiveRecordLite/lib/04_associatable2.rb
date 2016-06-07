require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      t_table = through_options.table_name
      t_primary = through_options.primary_key
      t_foreign = through_options.foreign_key
      s_table = source_options.table_name
      s_primary = source_options.primary_key
      s_foreign = source_options.foreign_key

      primary = send(t_foreign)
      results = DBConnection.execute(<<-SQL, primary)
        SELECT
          #{s_table}.*
        FROM
          #{t_table}
        JOIN
          #{s_table}
        ON
          #{t_table}.#{s_foreign} = #{s_table}.#{s_primary}
        WHERE
          #{t_table}.#{t_primary} = ?
      SQL
      source_options.model_class.parse_all(results).first
    end
  end
end

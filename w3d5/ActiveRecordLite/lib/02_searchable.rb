require_relative 'db_connection'
require_relative '01_sql_object'
require 'byebug'

module Searchable
  def where(params)
    where_line = params.keys.map{ |el| "#{el} = ?"}.join(" AND ")
    vals = params.values
    self.table_name
    result = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    parse_all(result)
  end
end

class SQLObject
  extend Searchable
end

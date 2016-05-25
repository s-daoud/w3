class ModelBase
  attr_reader :id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM #{self::TABLE_NAME}")
    data.map { |datum| self.new(datum) }
  end

  def self.find_by_id(id)
    result = QuestionDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        id = ?
    SQL
    return nil unless result.length > 0

    self.new(result.first)
  end

  def save
    arr = self.instance_variables
    arr << arr.shift
    arr.map! { |el| el.to_s[1..-1] }

    val_arr = arr.map{ |var| self.send(var.to_sym)}
    split_arr = arr[0...-1].map{|el| el += " = ?"}.join(", ")

    if @id
      QuestionDBConnection.instance.execute(<<-SQL, *val_arr)
        UPDATE
          #{self.class::TABLE_NAME}
        SET
          #{split_arr}
        WHERE
          id = ?
      SQL
    else
      arr.pop
      QuestionDBConnection.instance.execute(<<-SQL, *(val_arr[0...-1]))
        INSERT INTO
          #{self.class::TABLE_NAME}(#{arr.join(", ")})
        VALUES
          (#{arr.map{|el| "?"}.join(", ")})
      SQL
      @id = QuestionDBConnection.instance.last_insert_row_id
    end
  end
end

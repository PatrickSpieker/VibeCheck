
class SearchableTransaction
  def initialize(transcation_date, description, bank_determined_category, tags)
    @transaction_date = transaction_date
    @description = description
    @bank_determined_category = bank_determined_category
    @amount = amount
    @tags = tags.to_a
  end

  def to_sql_insert_into_transactions
    "insert into transactions values ("
    + @transaction_date.strftime("%Y-%m-%d") + ", "
    + @description + ", "
    + @amount + ");"
  end

  def to_sql_insert_into_tags(t_id)
    query = "insert into tags values "
    tags.each do |t|
      query += "(#{t_id}, #{t}, 0), "
    end
    query += "(#{t_id}, #{@bank_determined_category}, 1)"
    query + ";"
  end
end

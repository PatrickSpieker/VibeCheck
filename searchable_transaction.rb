
class SearchableTransaction
  def initialize(transaction_date, description, bank_determined_category, amount, tags)
    @transaction_date = transaction_date
    @description = description
    @bank_determined_category = bank_determined_category
    @amount = amount
    @tags = tags.to_a
  end

  def txn_id
    # need better hash function; this one has too many collisions
    "txn_" + [@transaction_date, @description, @amount].hash.abs.to_s
  end
  def to_sql_insert_into_transactions
    """
    insert into transactions values (
      '#{txn_id}', 
      '#{@transaction_date.strftime("%Y-%m-%d")}', 
      '#{@description}', 
      #{@amount});
    """.strip
  end

  def to_sql_insert_into_tags
    query = "insert into tags values "
    @tags.each do |t|
      query += "('#{txn_id}', '#{t}', 0), "
    end

    query += "('#{txn_id}', '#{@bank_determined_category}', 1)"
    query += ";"
    query
  end
end

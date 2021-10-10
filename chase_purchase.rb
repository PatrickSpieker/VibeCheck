require 'csv'


class ChasePurchase
  # attr_reader
  def initialize()
    @chase_cc_last_four = chase_cc_last_four
    @transaction_date = transaction_date
    @description = description
    @chase_category = chase_category
    @chase_type = chase_type
    @amount = amount
  end


  # params: row - CSV::Row
  # returns nilable ChasePurchase
  def self.from_csv_row(row, cc_last_four)
    return nil if row[4] != 'Sale'
    require 'pry'; binding.pry
    transaction_date = Date.parse(row[0])
    description = row[2]
    chase_category = row[3]
    amount = row[5]

    return nil if transaction_date.nil?
    return nil if description.nil?
    return nil if chase_category.nil?
    return nil if amount.nil?

    new(
      cc_last_four,
      transaction_date,
      description,
      chase_category,
      amount,
    )
  end

  private_class_method :new
  def to_searchable_transaction(tags)
    SearchableTransaction.new(
      @transaction_date,
      @description,
      @bank_determined_category,
      @tags
    )
  end
end 

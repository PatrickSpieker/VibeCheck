require 'csv'



# take path from CLI of dir to ingest files from 
#
# take path of CLI of dir to cross reference files from (existing processed data)
#
#
# for the 

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

  private_class_method :new



end 

require 'csv'
require 'sqlite3'
require_relative 'chase_purchase.rb'


# take path from CLI of dir to ingest files from 
# take path of CLI of dir to cross reference files from (existing processed data)
# output:
# average spend per day
# total spend for the statement
# statement date
# date of computation
# questions:
# - aggregate of:
#   - necessary?
#   - mild regret?
#   - clothing?
#   - eating out?
#   - lime?
#   - travel?
# chart of purchase size and frequency (decreasing)

db_filename = "data/main.db"

def drop_transactions_table
  """
  drop table if exists transactions
  """
end

def drop_tags_table
  """
  drop table if exists tags
  """
end

def create_transactions_table
  """
  create table if not exists transactions (
    txn_id TEXT PRIMARY KEY,
    file_index INTEGER,
    transaction_date TEXT,
    description TEXT,
    amount REAL
  );
  """
end

def create_tags_table
  """
  create table if not exists tags (
    txn_id TEXT,
    tag TEXT,
    bank_determined INTEGER,
    FOREIGN KEY(txn_id) REFERENCES transactions(txn_id) 
  );
  """
end

db = SQLite3::Database.new(db_filename)
db.execute(drop_transactions_table)
db.execute(drop_tags_table)
db.execute(" PRAGMA foreign_keys = ON;")
db.execute(create_transactions_table)
db.execute(create_tags_table)

rows = CSV.parse(File.open(ARGV[0]))[1..]
puts "Total rows: #{rows.length}"

rows.each_with_index do |r, i|

  tags = []
  cp = ChasePurchase.from_csv_row(r, i, "6226")
  next if cp.nil?
  puts "-" * 50
  puts cp.to_pretty_string
  puts "Was this a good purchase? (y/n)"
  name = STDIN.gets.strip
  if name == 'y'
    tags << 'good_purchase'
  else
    tags << 'bad_purchase'
  end

  st = cp.to_searchable_transaction(tags)
  db.execute(st.to_sql_insert_into_transactions)
  db.execute(st.to_sql_insert_into_tags)
  puts "-" * 50
end

puts "Done! DB should be ready"
puts "-" * 50
puts db.execute """
select * from transactions
"""
puts "-" * 50
puts db.execute """
select * from tags
"""


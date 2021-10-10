select tag, sum(transactions.amount)
from transactions
join tags on tags.txn_id = transactions.txn_id
where tags.bank_determined = 1
group by tag;

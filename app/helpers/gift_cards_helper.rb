module GiftCardsHelper
  def cleared_credits_amount(charitio, email)
    @sum = 0
    @transactions = charitio.get_transactions(email: email)
    if @transactions.ok?
      @transactions = @transactions.response
      @transaction_ids = []
      @transactions.each {|transaction| @transaction_ids.push(transaction.uuid)}
      @transaction_ids.each do |uuid|
        @cleared_credits = charitio.get_cleared_credits(master_transaction_id: uuid)
        @cleared_credits.each {|credit| @sum += credit.amount}
      end
      return @sum
    else
      return @sum
    end
  end

  def pending_clearance_credits_amount(charitio, email)
    @sum = 0
    @transactions = charitio.get_transactions(email: email)
    if @transactions.ok?
      @transactions = @transactions.response
      @transaction_ids = []
      @transactions.each {|transaction| @transaction_ids.push(transaction.uuid)}
      @transaction_ids.each do |uuid|
        @cleared_credits = charitio.get_pending_clearance_credits(master_transaction_id: uuid)
        @cleared_credits.each {|credit| @sum += credit.amount}
      end
      return @sum
    else
      return @sum
    end
  end
end
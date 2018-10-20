class DebugController < ApplicationController
  def yodlee
    @state = yodlee_state

    # @transactions = Yodlee::Transaction.all(state[:user_session], from_date: 2.years.ago)
    @accounts = Yodlee::Account.all(@state[:user_session])
  end
end

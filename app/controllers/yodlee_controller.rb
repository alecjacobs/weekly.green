class YodleeController < ApplicationController
  def index
    state = yodlee_state
    # account = Yodlee::Account.find(state[:user_session], "creditCard", 11895752)
    # transactions = account.transactions.all(from_date: 10.years.ago)

    transactions = Yodlee::Transaction.all(state[:user_session], from_date: 10.years.ago)
    render plain: JSON.pretty_generate(transactions.as_json.map { |r| r["table"] }), content_type: :json
  end
end

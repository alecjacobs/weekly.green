class YodleeController < ApplicationController
  before_action :set_cors_headers

  def index
    state = yodlee_state
    # account = Yodlee::Account.find(state[:user_session], "creditCard", 11895752)
    # transactions = account.transactions.all(from_date: 10.years.ago)

    transactions = Yodlee::Transaction.all(state[:user_session], from_date: 10.years.ago)
    render plain: JSON.pretty_generate(transactions.as_json.map { |r| r["table"] }), content_type: :json
  end

  # The Yodlee dag endpoint is returning:
  #  Uh oh. It looks like we're having issues connecting to this site for some reason. Unfortunately, we don't know when this will be resolved. Please come back later to try again.
  def mock
    transactions = JSON.parse(File.read(Rails.root.join('data', 'synthetic.json')))

    deposits, withdrawals = transactions.map { |transaction| OpenStruct.new(transaction) }.partition { |transaction| transaction.amt > 0 }
    deposit_mean = deposits.sum(&:amt) / deposits.length.to_f
    withdrawal_mean = withdrawals.sum(&:amt) / withdrawals.length.to_f

    deposit_stdev = Math.sqrt(deposits.map { |deposit| (deposit.amt - deposit_mean)**2 }.sum / deposits.length)
    withdrawal_stdev = Math.sqrt(withdrawals.map { |withdrawal| (withdrawal.amt - withdrawal_mean)**2 }.sum / withdrawals.length)

    json = {
      transactions: transactions,
      summary: {
        income: {
          period: (90.days / deposits.length.to_f) / (60 * 60 * 24),
          mean: deposit_mean,
          stdev: deposit_stdev
        },
        expenses: {
          period: (90.days / withdrawals.length.to_f) / (60 * 60 * 24),
          mean: withdrawal_mean,
          stdev: withdrawal_stdev
        }
      }
    }

    render plain: JSON.pretty_generate(json), content_type: :json
  end

  private

    def set_cors_headers
      response.set_header "Access-Control-Allow-Origin", request.headers["Origin"] || "*"
    end
end

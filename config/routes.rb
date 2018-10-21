Rails.application.routes.draw do
  scope :debug do
    get 'yodlee', to: 'debug#yodlee'
  end

  get '/yodlee', to: 'yodlee#index'
  get '/yodlee_mock', to: 'yodlee#mock'

  root to: 'root#index'
end

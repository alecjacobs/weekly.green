Rails.application.routes.draw do
  scope :debug do
    get 'yodlee', to: 'debug#yodlee'
  end

  match '/yodlee', to: 'yodlee#index', via: [:get, :options]
  match '/yodlee_mock', to: 'yodlee#mock', via: [:get, :options]

  root to: 'root#index'
end

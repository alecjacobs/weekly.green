require 'dotenv/load'
require 'yodlee'

Yodlee.configure do |config|
  config.cobrand          = ENV.fetch('YODLEE_COBRAND')
  config.cobrand_login    = ENV.fetch('YODLEE_COBRAND_LOGIN')
  config.cobrand_password = ENV.fetch('YODLEE_COBRAND_PASSWORD')
  config.base_path        = ENV.fetch('YODLEE_BASE_PATH', Yodlee::Configuration::DEVELOPMENT_BASE_PATH)
end

def yodlee_state
  cobrand = Yodlee::Cobrand.login
  username = ENV.fetch('YODLEE_USER_LOGIN')
  password = ENV.fetch('YODLEE_USER_PASSWORD')
  generated_at = Time.now
  user = Yodlee::User.login(cobrand.session, username, password)

  {
    cobrand: cobrand,
    username: username,
    password: password,
    user: user,
    user_session: user.session,
    generated_at: generated_at
  }
end

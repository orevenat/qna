# frozen_string_literal: true

module OmniauthMacros
  def mock_auth_hash(provider)
    mock_hash = OmniAuth::AuthHash.new(
      provider: provider.downcase,
      uid: '123545',
      info: { email: 'mock@email.com' },
      credentials: { token: 'mock_token', secret: 'mock_secret' }
    )

    OmniAuth.config.mock_auth[provider.downcase.to_sym] = mock_hash
  end

  def invalid_mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = :invalid_credentials
  end

  def silence_omniauth
    previous_logger = OmniAuth.config.logger
    OmniAuth.config.logger = Logger.new('/dev/null')
    yield
  ensure
    OmniAuth.config.logger = previous_logger
  end
end

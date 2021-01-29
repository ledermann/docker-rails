module KnockHelpers
  def authenticated_header(target)
    return unless target

    token = if target == :invalid
      'this-is-an-invalid-token'
    else
      Knock::AuthToken.new(payload: { sub: target.id }).token
    end
    { Authorization: "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include KnockHelpers, type: :request
end

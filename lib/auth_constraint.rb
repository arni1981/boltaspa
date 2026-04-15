class AuthConstraint
  def self.matches?(request)
    request.cookies["session_id"].present?
  end
end
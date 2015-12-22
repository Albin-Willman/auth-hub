# Build acctivation links
class ActivationLinkBuilder
  def initialize(domain, user)
    @domain = domain
    @user   = user
  end

  def build
    "#{@domain}api/v1/users/#{@user.token}/activate"
  end
end

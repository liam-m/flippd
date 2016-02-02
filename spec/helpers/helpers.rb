module Helpers
  def sign_in(from: '/')
    OmniAuth.config.test_mode = false
    visit from
    click_on 'Sign In' if page.has_link?('Sign In')

    fill_in 'Name', with: 'Joe Bloggs'
    fill_in 'Email', with: 'joe@bloggs.com'
    fill_in 'Image', with: 'https://igcdn-photos-c-a.akamaihd.net/hphotos-ak-xap1/t51.2885-19/11138045_460573147441210_66605936_a.jpg'
    click_on 'Sign In'
  end

  def fail_to_sign_in(from: '/')
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:developer] = 'Invalid credentials'.to_sym
    visit from
    click_on 'Sign In' if page.has_link?('Sign In')
  end

  def sign_out
    click_on 'Sign Out'
  end
end

OmniAuth.config.logger.level = Logger::UNKNOWN

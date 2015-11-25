feature "A video page" do
  before(:each) { visit('/phases/fundamentals/ruby-gems') }

  it "contains the video's title" do
    within('#main h1') do
      expect(page).to have_content 'Ruby Gems'
    end
  end

  it "contains the video's description" do
    expect(page).to have_content 'Introduces RubyGems and Bundler for managing Ruby dependencies.'
  end

  it "contains navigation links" do
    expect(page).to have_link 'Ruby', href: "/phases/fundamentals/ruby"
    expect(page).to have_link 'Planning vs. reacting', href: "/phases/fundamentals/planning-vs-reacting"
  end

  it "contains links to additional material" do
    expect(page).to have_link 'Ruby Gems Documentation', href: 'http://guides.rubygems.org'
    expect(page).to have_link 'Bundler', href: 'http://bundler.io'
    expect(page).to have_link 'Ruby Toolbox', href: 'https://www.ruby-toolbox.com'
  end

  context "for the first video" do
    it "contains a forward navigation link" do
      visit('/phases/fundamentals/ruby')
      expect(page).to have_link 'Ruby Gems', href: "/phases/fundamentals/ruby-gems"
    end
  end

  context "for the last video" do
    it "contains a backward navigation link" do
      visit('/phases/habitable-programs/plugins')
      expect(page).to have_link 'Middleware', href: "/phases/habitable-programs/middleware"
    end
  end
end

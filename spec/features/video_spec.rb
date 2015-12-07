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
    expect(page).to have_link 'Ruby Quiz', href: '/phases/fundamentals/ruby-quiz'
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

  context "for the first video in a topic after the first" do
    it "contains a link to the last quiz of the previous topic" do
      visit('/phases/fundamentals/planning-vs-reacting')
      expect(page).to have_link 'Ruby Quiz 2', href: "/phases/fundamentals/ruby-quiz-2"
    end

    context "when the previous topic has no quiz" do
      it "contains a link to the last video of the previous topic" do
        visit('/phases/fundamentals/ruby-parser')
        expect(page).to have_link 'Test doubles', href: "/phases/fundamentals/test-doubles"
      end
    end
  end

  context "for the last video" do
    it "contains a backward navigation link" do
      visit('/phases/habitable-programs/plugins')
      expect(page).to have_link 'Middleware', href: "/phases/habitable-programs/middleware"
    end
  end

  context "for the last video in a phase" do
    it "contains a link to the first quiz in the phase" do
      visit('/phases/fundamentals/ruby-gems')
      expect(page).to have_link 'Ruby Quiz', href: "/phases/fundamentals/ruby-quiz"
    end
  end
end

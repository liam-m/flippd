feature "Commenting on items" do
  context "initial comment display" do
    before(:each) { visit('/phases/fundamentals/ruby-gems') }

    it "displays information about comments" do
      expect(page).to have_xpath("//div[@id = 'comments']")
      expect(page).to have_content '0 comments'
    end
  end

  context "when signed in" do
    before(:each) do
      sign_in(:from => '/phases/fundamentals/ruby-gems')
    end

    it "displays the comment form" do
      expect(page).to have_xpath("//div[@id = 'comments_form']")
      expect(page).to have_xpath("//form")
      expect(page).to have_xpath("//textarea[@id = 'new_comment']")
      expect(page).to have_xpath("//button[@type = 'submit']")
    end
  end

  context "when signed out" do
    before(:each) do
      visit('/phases/fundamentals/ruby-gems')
    end

    it "shows the comment form in a disabled state and prompts to sign in" do
      expect(page).to have_xpath("//textarea[@id = 'new_comment' and @disabled]")
      expect(page).to have_xpath("//button[@type = 'submit' and @disabled]")
      expect(page).to have_content 'Sign in to post a comment.'
    end
  end

  context "posting a comment" do
    before(:each) do
      sign_in(:from => '/phases/fundamentals/ruby-gems')
    end

    it "is stored and displayed correctly" do
      page.fill_in 'new_comment', :with => 'Test comment text'
      page.click_button('Post')

      # Redirects to correct page
      expect(page.current_path).to eq '/phases/fundamentals/ruby-gems'

      within('#comment_0') do
        expect(page).to have_xpath("//img[@src = 'https://igcdn-photos-c-a.akamaihd.net/hphotos-ak-xap1/t51.2885-19/11138045_460573147441210_66605936_a.jpg']")
        expect(page).to have_content 'Joe Bloggs'
        expect(page).to have_content 'Test comment text'

        date_time = page.find('h6').text
        # Time could have ticked over to the minute after the comment was created, so check it's within the last minute
        expected_date_times = [DateTime.now - Rational(1, 24*60), DateTime.now].map {|dt| dt.strftime("%d/%m/%y %H:%M")}
        expect(expected_date_times).to include date_time
      end
    end
  end
end

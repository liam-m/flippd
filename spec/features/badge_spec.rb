feature "Badges" do
  context "new user" do
    before(:each) do
      sign_in
    end

    it "does not have any badges awarded but all are available" do
      all_badges = ["Completed 1 Quiz", "Completed 5 Quizzes", "Completed 10 Quizzes", "Left 1 Comment", "Left 5 Comments", "Left 10 Comments"]
      visit('/user')

      within('#badges-earned') do
        all_badges.each do |badge_text|
          expect(page).not_to have_content badge_text
        end
      end

      within('#badges-available') do
        all_badges.each do |badge_text|
          expect(page).to have_content badge_text
        end
      end
    end
  end

  context "posting a comment" do
    before(:each) do
      sign_in
    end

    it "awards a badge" do
      visit('/phases/fundamentals/ruby-gems')

      page.fill_in 'new_comment', :with => 'Test comment text'
      page.click_button('Post')

      visit('/user')
      within('#badges-earned') do
        expect(page).to have_content 'Left 1 Comment'
      end

      within('#badges-available') do
        expect(page).not_to have_content 'Left 1 Comment'
      end
    end
  end

  context "completing a quiz" do
    before(:each) do
      sign_in
    end

    it "awards a badge" do
      visit('/phases/fundamentals/ruby-quiz')

      page.choose('Dynamic')
      page.choose('Test Driven Development')
      page.click_button('Submit')

      visit('/user')
      within('#badges-earned') do
        expect(page).to have_content "Completed 1 Quiz"
      end

      within('#badges-available') do
        expect(page).not_to have_content 'Completed 1 Quiz'
      end
    end
  end
end

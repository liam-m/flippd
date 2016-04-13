feature "Badges for comments" do
  context "posting a comment" do
    before(:each) do
      sign_in
    end

    it "is awards a badge" do
      visit('/phases/fundamentals/ruby-gems')

      page.fill_in 'new_comment', :with => 'Test comment text'
      page.click_button('Post')

      visit('/user')
      within('#badges-earned') do
        expect(page).to have_content 'Left 1 Comment'
      end
    end
  end
end

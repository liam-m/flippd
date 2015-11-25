feature "A quiz page" do
  before(:each) { visit('/phases/fundamentals/ruby-quiz') }

  it "contains the quiz's title" do
    within('#main h1') do
      expect(page).to have_content 'Ruby Quiz'
    end
  end

  it "contains question 1" do
    within('#main form') do
      expect(page).to have_content 'Is Ruby a static or dynamic language?'
    end
  end
  
  it "contains question 2" do
    within('#main form') do
      expect(page).to have_content 'What does TDD stand for?'
    end
  end
  
  it "has quesiton 1's answers" do
    within('#main form') do
      expect(page).to have_content 'Static'
      expect(page).to have_content 'Dynamic'
    end
  end
  
  it "has question 2's answers" do
    within('#main form') do
      expect(page).to have_content 'Test Driven Development'
      expect(page).to have_content 'Test Develop Drive'
      expect(page).to have_content 'Till Development\'s Done'
    end
  end

  it "contains a submit button" do
    within('#main form') do
      expect(page).to have_selector(:css, "button[type=\"submit\"]")
    end
  end
end

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
  
  it "has question 1's answers" do
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

  context "navigation" do
    context "The first quiz in a topic with multiple quizzes" do
      it "contains a link to the next quiz" do
        visit('/phases/fundamentals/ruby-quiz')
        expect(page).to have_link 'Ruby Quiz 2', href: "/phases/fundamentals/ruby-quiz-2"
      end

      it "contains a link to the last video of the topic" do
        visit('/phases/fundamentals/ruby-quiz')
        expect(page).to have_link 'Ruby Gems', href: "/phases/fundamentals/ruby-gems"
      end
    end

    context "The second quiz in a topic" do
      it "contains a link to the previous quiz" do
        visit('/phases/fundamentals/ruby-quiz-2')
        expect(page).to have_link 'Ruby Quiz', href: "/phases/fundamentals/ruby-quiz"
      end
    end

    context "The final quiz in a topic" do
      it "contains a link to the first video of the next topic" do
        visit('/phases/fundamentals/ruby-quiz-2')
        expect(page).to have_link 'Planning vs. reacting', href: "/phases/fundamentals/planning-vs-reacting"
      end
    end
  end
end

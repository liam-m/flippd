feature "A quiz page" do
  context "quiz display" do
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
  end

  context "submission" do
    before(:each) { visit('/phases/fundamentals/ruby-quiz') }

    it "gives inline and overall feedback when the quiz is completed correctly" do
      page.choose('Dynamic')
      page.choose('Test Driven Development')
      page.click_button('Submit')

      within('#main form') do
        # 2 ticks next to questions
        expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-ok text-success']", :count => 2)

        # 2 thumbs up next to answers
        expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-thumbs-up']", :count => 2)

        # Progress bar indicating 2/2 and success
        expect(page).to have_xpath("//div[@class = 'progress-bar progress-bar-success']", :count => 1, :text => "2 / 2")
      end
    end

    it "gives inline and overall feedback when the quiz is completed incorrectly" do
      page.choose('Static')
      page.choose('Test Develop Drive')
      page.click_button('Submit')

      within('#main form') do
        # 2 crosses next to questions
        expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-remove text-danger']", :count => 2)

        # 2 Pointing fingers next to correct answers
        expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-hand-left']", :count => 2)

        # 2 thumbs down next to incorrect answers
        expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-thumbs-down']", :count => 2)

        # Progress bar indicating 0/2 and failure
        expect(page).to have_xpath("//div[@class = 'progress-bar progress-bar-danger']", :count => 1, :text => "0 / 2")
      end
    end

    context "when the quiz is submitted without answering all questions" do
      it "displays an error message and indicates each unanswered question" do
        page.click_button('Submit')
        within('#main form') do
          # 2 exclamation marks next to questions
          expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-exclamation-sign text-primary']", :count => 2)

          # Error message
          expect(page).to have_content 'Please answer all questions'
        end
      end

      it "does not display any feedback on their performance in the quiz" do
        page.click_button('Submit')
        within('#main form') do
          # 0 ticks next to questions
          expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-ok text-success']", :count => 0)

          # 0 thumbs up next to answers
          expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-thumbs-up']", :count => 0)

          # No progress bar indicating 2/2 and success
          expect(page).to have_xpath("//div[@class = 'progress-bar progress-bar-success']", :count => 0, :text => "2 / 2")

          # 0 crosses next to questions
          expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-remove text-danger']", :count => 0)

          # 0 Pointing fingers next to correct answers
          expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-hand-left']", :count => 0)

          # 0 thumbs down next to incorrect answers
          expect(page).to have_xpath("//span[@class = 'glyphicon glyphicon-thumbs-down']", :count => 0)

          # No progress bar indicating 0/2 and failure
          expect(page).to have_xpath("//div[@class = 'progress-bar progress-bar-danger']", :count => 0, :text => "0 / 2")
        end
      end
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

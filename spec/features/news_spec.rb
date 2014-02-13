describe '/news_edit' do

  context 'user is not logged in' do

    it 'redirects to login without admin user' do
      visit '/news_edit'
      expect(page.status_code).to eq 200
      expect(page.body).to match '<h3>Login</h3>'
    end

  end

  context 'user with admin role' do

    it 'shows news edit page' do
      visit '/news_edit'
      expect(page.body).to match '<h3>Login</h3>'
      fill_in 'login_email', with: 'jane.doe@example.org'
      fill_in 'login_password', with: 'secret'
      click_button 'login_submit'
      expect(page.current_path).to eq '/news_edit'
      expect(page.body).to match '<h3>News Edit</h3>'
    end

  end
  
  context 'user without admin role' do

    it 'shows news edit page' do
      visit '/news_edit'
      expect(page.body).to match '<h3>Login</h3>'
      fill_in 'login_email', with: 'john.doe@example.org'
      fill_in 'login_password', with: 'secret'
      click_button 'login_submit'
      expect(page.current_path).to eq '/'
      expect(page.body).
        to match 'You are not authorized to access \'/news_edit\' page.'
    end

  end

  context 'news edit' do
    before(:all) { login_as_admin }

    it 'allows to add news item' do
      visit '/news_edit'
      expect(page.body).to match 'Add News Item'
    end
  end

end

describe '/news' do

  context 'user is not logged in' do

    it 'redirects to login without admin user' do
      visit '/news'
      expect(page.status_code).to eq 200
      expect(page.body).to match '<h3>Login</h3>'
    end

  end

  context 'user with admin role' do

    it 'shows news edit page' do
      visit '/news'
      expect(page.body).to match '<h3>Login</h3>'
      fill_in 'login_email', with: 'jane.doe@example.org'
      fill_in 'login_password', with: 'secret'
      click_button 'login_submit'
      expect(page.current_path).to eq '/news'
      expect(page.body).to match '<h3>News Edit</h3>'
    end

  end
  
  context 'user without admin role' do

    it 'shows news edit page' do
      visit '/news'
      expect(page.body).to match '<h3>Login</h3>'
      fill_in 'login_email', with: 'john.doe@example.org'
      fill_in 'login_password', with: 'secret'
      click_button 'login_submit'
      expect(page.current_path).to eq '/'
      expect(page.body).
        to match 'You are not authorized to access \'/news\' page.'
    end

  end

  context 'news edit' do
    before(:all) { login_as_admin }
    before(:each) { truncate_db }

    it 'allows to add news item' do
      visit '/news'
      expect(page.body).to match 'Add'
      fill_in 'add_subject', with: 'New News'
      fill_in 'add_news_item', 
        with: '<p>New news are newer than newish news<p><p>true story</p>'
      click_button 'submit_news_item'
      expect(page.current_path).to eq '/news'
      expect(NewsPost.count).to eq 1
      fill_in 'add_subject', with: 'New News'
      fill_in 'add_news_item', 
        with: '<p>New news are newer than newish news<p><p>true story</p>'
      click_button 'submit_news_item'
      expect(NewsPost.count).to eq 2
    end
  end

end

describe User do
  subject(:user) { User.where(id: user_id).first  }

  context 'user does not exist' do
    let(:user_id) { 987797 }
    
    it 'returns nil' do
      expect(user).to be_nil
    end

    context 'existing user no roles' do
      let(:user_id) { 1 }

      it 'returns user instance' do
        expect(user).to be_kind_of User
        expect(user.name).to eq 'John Doe'
      end
      
      describe '#roles' do
        it 'returns empty array' do
          expect(user.roles).to eq []
        end
      end

      describe '#roles_names' do
        it 'returns empty array' do
          expect(user.roles_names).to eq []
        end
      end

      describe '#admin?' do
        it 'returns false' do
          expect(user.admin?).to be_false
        end
      end

    end

    context 'admin user' do
      let(:user_id) { 2 }

      it 'returns user instance' do
        expect(user).to be_kind_of User
        expect(user.name).to eq 'Jane Doe'
      end

      describe '#roles' do
        it 'returns roles of the user' do
          admin = Role.find_by_name('admin')
          expect(user.roles).to include admin
        end
      end

      describe '#roles_names' do
        it 'returns roles names for the user' do
          expect(user.roles_names).to eq ['admin']
        end
      end

      describe '#admin?' do
        it 'returns true' do
          expect(user.admin?).to be_true
        end
      end
    
    end
  end
end

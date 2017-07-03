require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  describe 'action notes#index' do
    it 'should succesfully respond to get action' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'action notes#create' do

    before do
       post :create, params: {note: {title: 'First', content: 'Something'}}
     end

    it 'should return 200-status code success' do
      expect(response).to be_success
    end

    it 'should create and save a note into the database' do
      note = Note.last
      expect(note.title).to eq('First')
      expect(note.content).to eq('Something')
    end

    it 'should return the created note in response body' do
      json = JSON.parse(response.body)
      expect(json['content']).to eq('Something')
      expect(json['title']).to eq('First')  
    end
  end
  
end

require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  
  describe 'action notes#index' do
    
    it 'should succesfully respond to get action' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'should return all Notes in ascending order' do
      2.times do
        FactoryGirl.create(:note)
      end
      get :index
      json = JSON.parse(response.body)
      expect(json[0]['id'] < json[1]['id']).to be true
    end
  
    it 'should show Notes with all the associated Tags' do
      note = FactoryGirl.create(:note)
      tag =  FactoryGirl.create(:tag, note_id: note.id)
      get :index
      json = JSON.parse(response.body)
      expect(json[0]['tags'][0]['name']).to eq(tag.name)
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

  describe 'notes#create action validations' do

    before do
      post :create, params: {note: {title: '', content: ''}}
    end

    it 'should properly deal with validation errors' do      
      expect(response).to have_http_status(:unprocessable_entity)
      end

    it 'should return a json error message on validation errors' do
      json = JSON.parse(response.body)
      expect(json["errors"]["title"][0]).to eq("can't be blank")
      expect(json["errors"]["content"][0]).to eq("can't be blank")
      end
    
  end

  describe 'notes#show action' do
    
    it 'should return a note' do
      note = FactoryGirl.create(:note)
      get :show, params: {id: note.id}
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(note.id)
      expect(json["title"]).to eq(note.title)
      expect(json["content"]).to eq(note.content)
    end
     
     it 'should include associated tags with the notes' do
      note = FactoryGirl.create(:note)
      tag = FactoryGirl.create(:tag, note_id: note.id)
      get :show, params: {id: note.id}
      json = JSON.parse(response.body)
      expect(json['tags'][0]['name']).to eq(tag.name)
    end
  
  end

  describe 'notes#update action' do

    before do
       @note = FactoryGirl.create(:note)         
    end

    it 'should successfully update a note' do
      put :update, params: {id: @note.id, note: {title: 'Second', content: 'new'}}
      json = JSON.parse(response.body)
      expect(json['title']).to eq('Second')
      expect(json['content']).to eq('new')
      expect(response).to be_success
    end

    it 'should properly deal with validation errors' do  
      put :update, params: {id: @note.id, note: {title: '', content: ''}}
      expect(response).to have_http_status(:unprocessable_entity)        
    end

    it 'should return error json on validation error' do
      put :update, params: {id: @note.id, note: {title: '', content: ''}}
      json = JSON.parse(response.body)
      expect(json["errors"]['title'][0]).to eq("can't be blank")
      expect(json["errors"]['content'][0]).to eq("can't be blank")
    end

  end

  describe 'notes#destroy action' do
    
    before do
      @note = FactoryGirl.create(:note)
      delete :destroy, params: {id: @note.id}
    end
    it 'should allow to destroy the note' do      
      note = Note.find_by_id(@note.id)
      expect(note).to eq(nil)    
    end

    it 'should render status :no_content when the note is deleted' do
      expect(response).to have_http_status (:no_content)
    end  
  end  
end


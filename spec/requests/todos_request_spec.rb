require 'rails_helper'

RSpec.describe 'Todos', type: :request do
  # mocking data
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  describe 'Get/todos' do
    before { get '/todos' }
    it 'Should return todos' do
      expect(json).not_to be_empty
      expect(json.count).to eq(10)
    end

    it 'Should return a 200 response' do
      expect(response).to_have_http_status(200)
    end
  end

  describe 'get /todos/:id' do
    before { get "todos/#{todo_id}" }

    it 'Should return todo' do
      expect(json).not_to be_empty
      expect(json['id']).to eq(todo_id)
    end
    it 'Should return a 200 response' do
      expect(response).to_have_http_status(200)
    end
    context 'when there is no record' do
      let(:todo_id) { 100 }

      it 'should return status 404' do
        expect(response).to_have_http_status(404)
      end
      it 'body should be Could not find todos' do
        expect(response.body).to match(/Could not find todos/)
      end
    end
  end

  describe 'Post /todos' do
    let(:valid_attributes) { { title: 'Learn Elm', created_by: '1' } }

    context 'with valid params' do
      before { post '/todos', params: valid_attributes }

      it 'should have Learn Elm title' do
        expect(json['title']).to match(/Learn Elm/)
      end
      it 'response status should be 201' do
        expect(response).to_have_http_status(201)
      end
    end

    context 'with invalid params' do
      before { post '/todos', params: { title: 'Foo' } }

      it 'response status should be 422' do
        expect(response).to_have_http_status(422)
      end

      it 'should return validation error' do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  describe 'Put /todo/:id' do
    let(:valid_attributes) { { title: 'Elm street' } }

    context 'when record exist' do
      before { put "/todos/#{todo_id}" }

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns 204' do
        expect(response).to_have_http_status(204)
      end
    end
  end

  describe 'Delete /todo/:id' do
    before { delete "/todos/#{todo_id}" }

    context 'when record exit' do
      it 'returns status code 204' do
        expect(response).to_have_http_status(204)
      end
    end
  end
end

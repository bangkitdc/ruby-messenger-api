require "rails_helper"

RSpec.describe "Conversations API", type: :request do
  let(:dimas) { create(:user) }
  let(:dimas_headers) { valid_headers(dimas.id) }

  let(:samid) { create(:user) }
  let(:samid_headers) { valid_headers(samid.id) }

  describe "GET /conversations" do
    context "when user have no conversation" do
      # make HTTP get request before each example
      before {
        get "/conversations", params: {}, headers: dimas_headers
      }

      it "returns empty data with 200 code" do
        expect_response(:ok)
        expect(response_data).to be_empty
      end
    end

    context "when user have conversations" do
      # Populate database with conversation of current user
      before do
        # Create 5 conversations for the current user
        (0..4).each do |i|
          new_user = create(:user)

          conversation = create(:conversation)
          create(:participant, user_id: dimas.id, conversation_id: conversation.id)
          create(:participant, user_id: new_user.id, conversation_id: conversation.id)

          # create example message
          create(:chat_message, user: dimas, conversation: conversation)
        end

        get "/conversations", params: {}, headers: dimas_headers
      end

      it "returns list conversations of current user" do
        # Note `response_data` is a custom helper
        # to get data from parsed JSON responses in spec/support/request_spec_helper.rb

        expect(response_data).not_to be_empty
        expect(response_data.size).to eq(5)
      end

      it "returns status code 200 with correct response" do
        expect_response(:ok)

        received_data = response_data[0].deep_symbolize_keys
        expect(received_data).to match(
          {
            id: Integer,
            with_user: {
              id: Integer,
              name: String,
              photo_url: String,
            },
            last_message: {
              id: Integer,
              sender: {
                id: Integer,
                name: String,
              },
              sent_at: String,
            },
            unread_count: Integer,
          }
        )
      end
    end
  end

  describe "GET /conversations/:id" do
    context "when the record exists" do
      # create conversation of dimas
      before do
        conversation = create(:conversation)
        create(:participant, user_id: dimas.id, conversation_id: conversation.id)
        create(:participant, user_id: samid.id, conversation_id: conversation.id)

        get "/conversations/#{conversation.id}", params: {}, headers: dimas_headers
      end

      it "returns conversation detail" do
        expect_response(:ok)

        received_data = response_data.deep_symbolize_keys
        expect(received_data).to match(
          {
            id: Integer,
            with_user: {
              id: Integer,
              name: String,
              photo_url: String,
            },
          }
        )
      end
    end

    context "when current user access other user conversation" do
      before do
        new_user = create(:user)

        conversation = create(:conversation)
        create(:participant, user_id: dimas.id, conversation_id: conversation.id)
        create(:participant, user_id: new_user.id, conversation_id: conversation.id)

        get "/conversations/#{conversation.id}", params: {}, headers: samid_headers
      end

      it "returns status code 403" do
        expect(response).to have_http_status(403)
      end
    end

    context "when the record does not exist" do
      before { get "/conversations/-11", params: {}, headers: dimas_headers }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end
    end
  end
end

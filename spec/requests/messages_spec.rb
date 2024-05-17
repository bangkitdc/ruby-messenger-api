require "rails_helper"

RSpec.describe "Messages API", type: :request do
  let(:agus) { create(:user) }
  let(:dimas) { create(:user) }
  let(:dimas_headers) { valid_headers(dimas.id) }

  let(:samid) { create(:user) }
  let(:samid_headers) { valid_headers(samid.id) }

  let(:convo_id) { conversation.id }

  # Create conversation between Dimas and Agus, then set convo_id variable
  let!(:conversation) do
    conversation = create(:conversation)
    create(:participant, user_id: dimas.id, conversation_id: conversation.id)
    create(:participant, user_id: agus.id, conversation_id: conversation.id)
    create(:chat_message, user: dimas, conversation: conversation)
    conversation
  end

  describe "get list of messages" do
    context "when user have conversation with other user" do
      before do
        get "/conversations/#{convo_id}/messages", params: {}, headers: dimas_headers
      end

      it "returns list all messages in conversation" do
        expect_response(:ok)

        received_data = response_data[0].deep_symbolize_keys
        expect(received_data).to match(
          {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String,
            },
            sent_at: String,
          }
        )
      end
    end

    context "when user try to access conversation not belong to him" do
      # Create conversation and set convo_id variable
      before do
        conversation = create(:conversation)
        create(:participant, user_id: dimas.id, conversation_id: conversation.id)
        create(:participant, user_id: agus.id, conversation_id: conversation.id)

        convo_id = conversation.id
        get "/conversations/#{convo_id}/messages", params: {}, headers: samid_headers
      end

      it "returns error 403" do
        expect(response).to have_http_status(403)
      end
    end

    context "when user try to access invalid conversation" do
      before { get "/conversations/-11/messages", params: {}, headers: samid_headers }

      it "returns error 404" do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "send message" do
    let(:valid_attributes) do
      { message: "Hi there!", user_id: agus.id }
    end

    let(:invalid_attributes) do
      { message: "", user_id: agus.id }
    end

    context "when request attributes are valid" do
      before { post "/messages", params: valid_attributes.to_json, headers: dimas_headers }

      it "returns status code 201 (created) and create conversation automatically" do
        expect_response(:created)

        received_data = response_data.deep_symbolize_keys
        expect(received_data).to match(
          {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String,
            },
            sent_at: String,
            conversation: {
              id: Integer,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String,
              },
            },
          }
        )
      end
    end

    context "when create message into existing conversation" do
      before { post "/messages", params: valid_attributes.to_json, headers: dimas_headers }

      it "returns status code 201 (created) and create conversation automatically" do
        expect_response(:created)

        received_data = response_data.deep_symbolize_keys
        expect(received_data).to match(
          {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String,
            },
            sent_at: String,
            conversation: {
              id: convo_id,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String,
              },
            },
          }
        )
      end
    end

    context "when an invalid request" do
      before { post "/messages", params: invalid_attributes.to_json, headers: dimas_headers }

      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end
    end
  end
end

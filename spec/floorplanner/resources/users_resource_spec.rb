require "spec_helper"

describe Floorplanner::Resources::UsersResource do
  class described_class::ClientStub
    def initialize(user_id, token)
      @user_id = user_id
      @token = token
    end

    def get(path)
      if path == "api/v2/users/#{@user_id}/token"
        HTTPI::Response.new(200, {}, @token)
      end
    end
  end

  let(:user_id) { 1234 }
  let(:token) { "abcd1234" }
  let(:client) { described_class::ClientStub.new(user_id, token) }

  subject { described_class.new(client) }

  describe "#token" do
    it "returns the current token for the given user id" do
      expect(subject.token(user_id)).to eq(token)
    end
  end
end

require 'spec_helper'

describe Message do
  describe "#new" do
    context "when my message is longer than 512 characters" do
      it "should be invalid" do
        comment = 'a' * 513
        message = Message.new(comment: comment)
        message.should_not be valid
      end
    end
  end
end
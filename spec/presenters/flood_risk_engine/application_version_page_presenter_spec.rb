require "rails_helper"

module FloodRiskEngine
  RSpec.describe ApplicationVersionPagePresenter, type: :presenter do
    before do
      FloodRiskEngine.configure do |config|
        config.application_name = nil
        config.git_repository_url = nil
      end
    end

    it { is_expected.to respond_to(:git_commit_url) }

    describe "#application_name" do
      it "uses the FloodRiskEngine.config setting if available" do
        FloodRiskEngine.configure do |config|
          config.application_name = "Yay"
        end
        expect(subject.application_name).to eq(FloodRiskEngine.config.application_name)
      end
      it "it defaults to Rails.application.class.module_parent_name" do
        expect(subject.application_name).to eq("Dummy")
      end
    end

    describe "#application_version" do
      it "defaults to Undefined if an Application::VERSION is not defined" do
        hide_const("::Application::VERSION")
        expect(subject.application_version).to eq("Undefined")
      end
      it "uses the Application::VERSION if defined" do
        stub_const("::Application::VERSION", "9.9.9")
        expect(subject.application_version).to eq("9.9.9")
      end
    end

    describe "#git_commit" do
      it "uses GitCommitSha to derive a git hash" do
        expect(GitCommitSha).to receive(:current).and_return("123")
        expect(subject.git_commit).to eq("123")
      end
    end

    describe "#git_repository_url" do
      it "uses FloodRiskEngine.config setting if present" do
        dummy_url = "http://example.com"
        FloodRiskEngine.configure do |config|
          config.git_repository_url = dummy_url
        end
        expect(subject.git_repository_url).to eq("http://example.com")
      end
      it "defaults to a deduced github repo url" do
        expect(subject.git_repository_url).to eq("https://github.com/EnvironmentAgency/dummy")
      end
    end

    describe "git_commit_url" do
      it "returns the git url for the current commit sha" do
        dummy_repo_url = "http://123"
        dummy_commit_sha = "xyz"
        expect(subject).to receive(:git_repository_url).and_return(dummy_repo_url)
        expect(subject).to receive(:git_commit).and_return(dummy_commit_sha)
        expected_git_commit_url = File.join(dummy_repo_url, "commit", dummy_commit_sha)
        expect(subject.git_commit_url).to eq(expected_git_commit_url)
      end
    end
  end
end

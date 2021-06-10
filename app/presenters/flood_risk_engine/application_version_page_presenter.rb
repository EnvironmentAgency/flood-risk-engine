# A 'view model' behind the high_voltage static page @ /pages/version
module FloodRiskEngine
  class ApplicationVersionPagePresenter

    def application_name
      FloodRiskEngine.config.application_name || Rails.application.class.module_parent_name
    end

    def application_version
      defined?(::Application::VERSION) ? Application::VERSION : "Undefined"
    end

    def git_commit
      @git_commit ||= GitCommitSha.current
    end

    def git_commit_url
      File.join(git_repository_url, "commit", git_commit)
    end

    def git_repository_url
      FloodRiskEngine.config.git_repository_url ||
        "https://github.com/EnvironmentAgency/#{application_name.underscore.dasherize}"
    end
  end
end

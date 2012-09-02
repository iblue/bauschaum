class Article < Bauschaum::Base
  def self.repo
    FileUtils.mkdir_p('/tmp/bauschaum-repo')
    # FIXME: Init repo!
    @repo ||= Rugged::Repository.new('/tmp/bauschaum-repo')
  end

  def index
    repo.index
  end

  def repo
    self.class.repo
  end
end

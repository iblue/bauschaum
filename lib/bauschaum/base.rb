class Bauschaum::Base
  def initialize(filename)
    @filename = filename
  end

  def exists?
    !!my_current_sha
  end

  def content=(content)
    @content = content
  end

  def content
    if exists?
      @content ||= repo.lookup(my_current_sha).content
    else
      @content ||= ""
    end
  end

  def commit!(message, author, timestamp = Time.now)
    # Save the content in a new blob.
    blob_sha = repo.write(@content, :blob)

    # Add the blob to a tree
    entry = {:type => :blob, :name => @filename, :oid  => blob_sha, :filemode => 0100644}
    builder = Rugged::Tree::Builder.new
    builder << entry
    tree_sha = builder.write(repo)

    # Create a commit
    author  = {:email=>"iblue@gmx.net", :time=>Time.now, :name=>"Markus Fenske"}
    parents = repo.empty? ? [] : [repo.head.target]

    Rugged::Commit.create(repo,
      :author     => author,
      :message    => message,
      :committer  => author,
      :parents    => parents,
      :tree       => tree_sha,
      :update_ref => "HEAD")
  end

  def self.init_repo(path)
    # FIXME: Init repo!
    @repo ||= Rugged::Repository.new(path)
  end

  def self.repo
    @repo
  end

  def repo
    self.class.repo
  end

  # FIXME: Currently returns the number of total commits
  # in the repo.
  def revisions
    return 0 if repo.empty?
    # Walk commits to see how many of them are there.
    commits = 1
    current_commit = repo.lookup(repo.head.target)
    while true
      current_commit = current_commit.parents.first
      break if current_commit.nil?
      commits += 1
    end
    commits
  end

  private
  def my_current_sha
    if repo.empty?
      return nil # Not files in an empty repo
    end
    # Take look at the current tree.
    recent_commit = repo.lookup(repo.head.target)
    # FIXME: Does not support directories!
    me = recent_commit.tree.entries.select{|e| e[:name] == @filename}
    return nil unless me.first
    me.first[:oid]
  end
end

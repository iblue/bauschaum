require 'test/unit'
require 'bauschaum'
require 'article'
require 'debugger'

class BauschaumTest < Test::Unit::TestCase
  def test_save_and_load
    `rm -rf /tmp/bauschaum`
    `mkdir -p /tmp/bauschaum`
    `git init /tmp/bauschaum`

    Article.init_repo("/tmp/bauschaum")

    article = Article.new("example.md")
    assert_equal false, article.exists?
    article.content = "Hello World!\nThis is the first commit\n"
    article.commit!("Create article", "Markus Fenske <iblue@gmx.net>")

    article = Article.new("example.md")
    assert_equal true, article.exists?
    article.content = "Hello World!\nThis is the second commit\n"
    article.commit!("Update article", "Markus Fenske <iblue@gmx.net>")

    assert_equal 2, article.revisions
  end
end

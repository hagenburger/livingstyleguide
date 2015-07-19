require 'document_test_helper'

class ImportAndSourceTest < DocumentTestCase

  LivingStyleGuide::Filters.add_filter :foo do |arguments, options, block|
    text = arguments.first
    "# #{text.capitalize} #{text.capitalize}"
  end

  def test_import_lsg
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/headline.lsg

      After
    INPUT
      <p.+?>Before</p>
      .*?
      <h2.+?>Imported</h2>
      .*?
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_lsg_relative
    file = "test/fixtures/import/index.html.lsg"
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default, file: file
      Before

      @import headline.lsg

      After
    INPUT
      <p.+?>Before</p>
      .*?
      <h2.+?>Imported</h2>
      .*?
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_lsg_partial_with_underscore
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/headline-partial.lsg

      After
    INPUT
      <p.+?>Before</p>
      .*?
      <h2.+?>Imported</h2>
      .*?
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_lsg_without_extension
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/headline

      After
    INPUT
      <p.+?>Before</p>
      .*?
      <h2.+?>Imported</h2>
      .*?
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_filter
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/filter.lsg

      After
    INPUT
      <p.+?>Before</p>
      .*?
      <h2.+?>Bar Bar</h2>
      .*?
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_multiple
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/*

      After
    INPUT
      <p.+?>Before</p>
      .*?
      <h2.+?>Imported</h2>
      .*?
      <h2.+?>Bar Bar</h2>
      .*?
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_haml
    require 'tilt/haml'
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      @import test/fixtures/import/haml.haml

      After
    INPUT
      <p.+?>Before</p>
      <div>
        <div class='foo'>Bar</div>
      </div>
      <p.+?>After</p>
    OUTPUT
  end

  def test_import_with_data
    { erb: 'erubis', haml: 'haml' }.each do |type, file|
      require "tilt/#{file}"
      assert_render_match <<-INPUT, <<-OUTPUT, template: :default
        @import test/fixtures/import/with-data.#{type} {
          "foo": "Bar"
        }
      INPUT
        <div>Bar</div>
      OUTPUT
    end
  end

  def test_use_haml
    require 'tilt/haml'
    assert_render_match <<-INPUT, <<-OUTPUT, template: :default
      Before

      ```
      @type haml
      @use test/fixtures/import/data.haml
      @data {
        "text": "Bar"
      }
      ```

      After
    INPUT
      <section class=\"lsg--example lsg--haml-example\" id=\"section-[a-f0-9]+\">
        <div class=\"lsg--html\">
          <div class='foo'>Bar</div>
        </div>
        <pre class=\"lsg--code-block\">
          <code class=\"lsg--code\"> <b>.foo</b>= text</code>
        </pre>
      </section>
    OUTPUT
  end

end

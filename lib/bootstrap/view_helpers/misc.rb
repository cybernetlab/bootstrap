module Bootstrap
  module ViewHelpers
    class Jumbotron < Base
      html_class 'jumbotron'
      flag :full_width
      after_capture do
        @content = @view.content_tag 'div', @content, class: 'container' if full_width?
      end
    end

    class PageHeader < Base
      html_class 'page-header'
    end

    class Alert < Base
      include TextContainer

      TAG = 'div'
      html_class 'alert'
      enum :appearence, %i[success info warning danger]
      flag :dismissable, html_class: 'alert-dismissable'
      helper(:link, 'Bootstrap::ViewHelpers::Link') {|link| link.add_class 'alert-link'}

      after_initialize do
        self.appearence ||= :success
        add_class "alert-#{self.appearence}"
      end

      before_render do
        if dismissable?
          @content = @view.content_tag('button', '&times;'.html_safe, type: 'button', class: 'close', data: {dismiss: 'alert'}, 'aria-hidden' => true) + @content
        end
      end
    end

    class ProgressBar < Base
      include TextContainer

      TAG = 'div'
      html_class 'progress-bar'
      enum :appearence, %i[success info warning danger]

      after_initialize do
        @completed = @args.extract_first! Numeric
        @completed = @options.delete :completed if @options[:completed].is_a? Numeric
        @completed ||= 0
        @completed = @completed.round
        @options[:role] = 'progressbar'
        @options['aria-valuenow'] = @completed
        @options['aria-valuemin'] = 0
        @options['aria-valuemax'] = 100
        @options['style'] = "width: #{@completed}%"
        add_class "progress-bar-#{self.appearence}" unless self.appearence.nil?
      end

      before_render do
        text = @content.empty? ? I18n.translate('bootstrap.progress_bar.text', completed: @completed) : @content
        @content = @view.content_tag 'span', text, class: 'sr-only'
        true
      end
    end

    class Progress < Base
      include Activable

      html_class 'progress'

      helper :bar, 'Bootstrap::ViewHelpers::ProgressBar'
      flag :striped, html_class: 'progress-striped'

      after_initialize do
        args = @args.clone
        args.unshift @view
        opts = @options.deep_dup
        opts[:class].select! {|o| o != 'progress' && o != 'progress-striped'}
        args.push opts
        @bars = [ProgressBar.new(*args)]
      end

      after_capture do
        @content = @view.capture {@bars.reduce(Base::EMPTY_HTML) {|html, bar| html += bar.render}} + @content
      end
    end

    register_helper :jumbotron, 'Bootstrap::ViewHelpers::Jumbotron'
    register_helper :jumbo, 'Bootstrap::ViewHelpers::Jumbotron'
    register_helper :page_header, 'Bootstrap::ViewHelpers::PageHeader'
    register_helper :alert_box, 'Bootstrap::ViewHelpers::Alert'
    register_helper :progress_bar, 'Bootstrap::ViewHelpers::Progress'
    register_helper :progress, 'Bootstrap::ViewHelpers::Progress'
  end
end
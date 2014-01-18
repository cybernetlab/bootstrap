module BootstrapIt
  #
  module ViewHelpers
    #
    # Jumbotron
    #
    # @author [alexiss]
    #
    class Jumbotron < WrapIt::Base
      html_class 'jumbotron'
      switch :full_width

      after_capture do
        full_width? && @content = content_tag(
          'div', @content, class: 'container'
        )
      end
    end

    #
    # PageHeader
    #
    # @author [alexiss]
    #
    class PageHeader < WrapIt::Base
      html_class 'page-header'
    end

    #
    # Alert
    #
    # @author [alexiss]
    #
    class Alert < WrapIt::Container
      include WrapIt::TextContainer

      default_tag 'div'
      html_class 'alert'
      html_class_prefix 'alert-'
      enum :appearence, %i(success info warning danger),
           default: :success, html_class: true
      switch :dismissable, html_class: true
      child :link, 'WrapIt::Link', [class: 'alert-link']

      before_render do
        if dismissable?
          @content = content_tag(
            'button',
            html_safe('&times;'),
            type: 'button',
            class: 'close',
            data: {dismiss: 'alert'},
            'aria-hidden' => true
          ) + @content
        end
      end
    end

    #
    # ProgressBar
    #
    # @author [alexiss]
    #
    class ProgressBar < WrapIt::Base
      include WrapIt::TextContainer

      default_tag 'div'
      html_class 'progress-bar'
      html_class_prefix 'progress-bar-'

      enum :appearence, %i[success info warning danger],
           html_class: true

      after_initialize do
        @completed = @arguments.extract_first!(Numeric)
        if @options[:completed].is_a?(Numeric)
          @completed = @options.delete(:completed)
        end
        @completed ||= 0
        @completed = @completed.round
        @options[:role] = 'progressbar'
        @options['aria-valuenow'.to_sym] = @completed
        @options['aria-valuemin'.to_sym] = 0
        @options['aria-valuemax'.to_sym] = 100
        @options[:style] = "width: #{@completed}%"
      end

      before_render do
        text =
          if @content.empty?
            I18n.translate(
              'bootstrap_it.progress_bar.text', completed: @completed
            )
          else
            @content
          end
        @content = content_tag('span', text, class: 'sr-only')
      end
    end

    #
    # Progress
    #
    # @author [alexiss]
    #
    class Progress < WrapIt::Container
      include Activable

      html_class 'progress'
      html_class_prefix 'progress-'

      child :bar, 'BootstrapIt::ViewHelpers::ProgressBar'

      switch :striped, html_class: true

      after_initialize do
        @first_bar_args = @arguments.clone
        # TODO: PORTABILITY: replace deep_dup (Rails)
        opts = @options.deep_dup
        opts[:class].select! { |o| o != 'progress' && o != 'progress-striped' }
        @first_bar_args.push(opts)
      end

      after_capture do
        @content = capture do
          ProgressBar.new(@template, *@first_bar_args).render
        end + @content
      end

#      after_capture do
#        @content = capture do
#          @bars.reduce(empty_html) { |a, e| a += e.render }
#        end + @content
#      end
    end

    WrapIt.register :jumbotron, 'BootstrapIt::ViewHelpers::Jumbotron'
    WrapIt.register :jumbo, 'BootstrapIt::ViewHelpers::Jumbotron'
    WrapIt.register :page_header, 'BootstrapIt::ViewHelpers::PageHeader'
    WrapIt.register :alert_box, 'BootstrapIt::ViewHelpers::Alert'
    WrapIt.register :progress_bar, 'BootstrapIt::ViewHelpers::Progress'
    WrapIt.register :progress, 'BootstrapIt::ViewHelpers::Progress'
  end
end

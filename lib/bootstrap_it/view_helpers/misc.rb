module BootstrapIt
  #
  module ViewHelpers
    #
    # Jumbotron
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#jumbotron Bootstrap docs
    class Jumbotron < WrapIt::Base
      html_class 'jumbotron'
      switch :full_width

      after_capture do
        full_width? && self[:content] = content_tag(
          'div', render_sections, class: 'container'
        )
      end
    end

    #
    # PageHeader
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#page-header Bootstrap docs
    class PageHeader < WrapIt::Base
      html_class 'page-header'
    end

    #
    # Alert
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#alerts Bootstrap docs
    class Alert < WrapIt::Container
      include WrapIt::TextContainer

      default_tag 'div'
      html_class 'alert'
      html_class_prefix 'alert-'
      enum :appearence, %i(success info warning danger),
           default: :success, html_class: true
      switch :dismissable, html_class: true
      child :link, 'WrapIt::Link', class: 'alert-link'
      section :dismissable
      place :dismissable, before: :content

      after_capture do
        if dismissable?
          self[:dismissable] = content_tag(
            'button',
            html_safe('&times;'),
            type: 'button',
            class: 'close',
            data: {dismiss: 'alert'},
            'aria-hidden' => true
          )
        end
      end
    end

    #
    # ProgressBar
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#progress Bootstrap docs
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

      after_capture do
        rendered = render_sections
        text =
          if rendered.empty?
            I18n.translate(
              'bootstrap_it.progress_bar.text', completed: @completed
            )
          else
            rendered
          end
        # TODO: do it with wrap when simple wrapping will be coded
        self[:content] = content_tag('span', text, class: 'sr-only')
      end
    end

    #
    # Progress
    #
    # @author Alexey Ovchinnikov <alexiss@cybernetlab.ru>
    #
    # @see http://getbootstrap.com/components/#progress Bootstrap docs
    class Progress < WrapIt::Container
      include Activable

      html_class 'progress'
      html_class_prefix 'progress-'

      child :bar, 'BootstrapIt::ViewHelpers::ProgressBar'
      switch :striped, html_class: true
      section :first_bar
      place :first_bar, before: :content

      after_initialize do
        self.deffered_render = true
        args = @arguments.clone
        # TODO: PORTABILITY: replace deep_dup (Rails)
        opts = @options.deep_dup
        opts[:class].select! { |o| o != 'progress' && o != 'progress-striped' }
        opts[:section] = :first_bar
        args.push(opts)
        bar(*args)
      end
    end

    register :jumbotron, 'BootstrapIt::ViewHelpers::Jumbotron'
    register :jumbo, 'BootstrapIt::ViewHelpers::Jumbotron'
    register :page_header, 'BootstrapIt::ViewHelpers::PageHeader'
    register :alert_box, 'BootstrapIt::ViewHelpers::Alert'
    register :progress_bar, 'BootstrapIt::ViewHelpers::Progress'
    register :progress, 'BootstrapIt::ViewHelpers::Progress'
  end
end

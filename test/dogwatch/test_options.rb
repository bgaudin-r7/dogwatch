require_relative '../test_helper'
require_relative '../../lib/dogwatch/model/options'

class TestOptions < Minitest::Test
  OPTS = {
    silenced: { '*': :foobar },
    notify_no_data: true,
    no_data_timeframe: 5,
    timeout_h: 3,
    evaluation_delay: 120,
    renotify_interval: 5,
    escalation_message: 'foobar',
    notify_audit: true,
    include_tags: false
  }.freeze

  def setup
    @options = DogWatch::Model::Options.new

    @options.silenced(OPTS[:silenced])
    @options.notify_no_data(OPTS[:notify_no_data])
    @options.no_data_timeframe(OPTS[:no_data_timeframe])
    @options.timeout_h(OPTS[:timeout_h])
    @options.evaluation_delay(OPTS[:evaluation_delay])
    @options.renotify_interval(OPTS[:renotify_interval])
    @options.escalation_message(OPTS[:escalation_message])
    @options.notify_audit(OPTS[:notify_audit])
    @options.include_tags(OPTS[:include_tags])
  end
  # rubocop:enable Metrics/AbcSize

  def test_silenced
    assert_equal @options.attributes.silenced, '*': :foobar
    assert_instance_of Hash, @options.attributes.silenced
  end

  def test_notify_no_data
    assert_equal @options.attributes.notify_no_data, true

    @options.notify_no_data
    assert_equal @options.attributes.notify_no_data, false
  end

  def test_no_data_timeframe
    assert_equal @options.attributes.no_data_timeframe, 5
    assert_kind_of Integer, @options.attributes.no_data_timeframe
  end

  def test_timeout_h
    assert_equal @options.attributes.timeout_h, 3
    assert_kind_of Integer, @options.attributes.timeout_h
  end

  def test_renotify_interval
    assert_equal @options.attributes.renotify_interval, 5
    assert_kind_of Integer, @options.attributes.renotify_interval
  end

  def test_evaluation_delay
    assert_equal @options.attributes.evaluation_delay, 120
    assert_kind_of Integer, @options.attributes.evaluation_delay
  end

  def test_escalation_message
    assert_equal @options.attributes.escalation_message, 'foobar'
    assert_instance_of String, @options.attributes.escalation_message
  end

  def test_notify_audit
    assert_equal @options.attributes.notify_audit, true

    @options.notify_audit
    assert_equal @options.attributes.notify_audit, false
  end

  def test_include_tags
    assert_equal @options.attributes.include_tags, false

    @options.include_tags
    assert_equal @options.attributes.include_tags, true
  end

  def test_render
    assert_equal OPTS, @options.render
    assert_kind_of Hash, @options.render
  end

  def test_invalid_monitor_type_specific_option
    @options = DogWatch::Model::Options.new(:event_alert)

    assert_raises NotImplementedError do
      @options.thresholds('critical' => 90, 'warning' => 80)
    end
  end

  def test_valid_monitor_type_specific_option
    @options = DogWatch::Model::Options.new(:metric_alert)

    @options.thresholds('critical' => 90, 'warning' => 80)

    actual = @options.attributes.thresholds
    assert_includes actual, 'critical'
    assert_equal actual['critical'], 90

    assert_includes actual, 'warning'
    assert_equal actual['warning'], 80
  end
end

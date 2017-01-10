require 'spec_helper'
require_relative './factories/import'

describe Asyncable do
  let(:test_obj) { Factories::Import.new }

  describe 'public methods' do
    describe '#start_async' do
      subject { test_obj.start_async }

      context "process hasn't finished" do
        before(:each) do
          allow(test_obj).to receive(:process_in_background)
        end

        it 'should set status to processing' do
          subject
          expect(test_obj.status).to eq(Asyncable::Statuses::PROCESSING)
        end
      end

      context "process finished" do
        it 'should set status to succeeded' do
          subject
          expect(test_obj.status).to eq(Asyncable::Statuses::SUCCEEDED)
        end
      end
    end

    describe '#succeeded?' do
      subject { test_obj.succeeded? }

      before(:each) do
        allow(test_obj).to receive(:status).and_return(status)
      end

      context "process still working" do
        let(:status) { Asyncable::Statuses::PROCESSING }
        it { is_expected.to eq(false) }
      end

      context "process failed" do
        let(:status) { Asyncable::Statuses::FAILED }
        it { is_expected.to eq(false) }
      end

      context "process succeeded" do
        let(:status) { Asyncable::Statuses::SUCCEEDED }
        it { is_expected.to eq(true) }
      end
    end

    describe '#failed?' do
      subject { test_obj.failed? }

      before(:each) do
        allow(test_obj).to receive(:status).and_return(status)
      end

      context "process still working" do
        let(:status) { Asyncable::Statuses::PROCESSING }
        it { is_expected.to eq(false) }
      end

      context "process failed" do
        let(:status) { Asyncable::Statuses::FAILED }
        it { is_expected.to eq(true) }
      end

      context "process succeeded" do
        let(:status) { Asyncable::Statuses::SUCCEEDED }
        it { is_expected.to eq(false) }
      end
    end

    describe '#processing?' do
      subject { test_obj.processing? }

      before(:each) do
        allow(test_obj).to receive(:status).and_return(status)
      end

      context "process still working" do
        let(:status) { Asyncable::Statuses::PROCESSING }
        it { is_expected.to eq(true) }
      end

      context "process failed" do
        let(:status) { Asyncable::Statuses::FAILED }
        it { is_expected.to eq(false) }
      end

      context "process succeeded" do
        let(:status) { Asyncable::Statuses::SUCCEEDED }
        it { is_expected.to eq(false) }
      end
    end
  end

  it 'has a version number' do
    expect(Asyncable::VERSION).not_to be nil
  end
end

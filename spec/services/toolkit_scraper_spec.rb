require 'spec_helper'

describe Envirotech::ToolkitScraper do
  describe '#all_issue_info' do
    context 'success' do
      let(:scraper) do
        agent = double('mechanize_agent')

        allow(agent).to receive(:get)
        allow(agent).to receive(:page) do
          double(
            body: "$(\"#envirotech_select_boxes\").html(' \
              <select name='issue'><option>foo</option></select>\t\n \
              <select name='regulation'><option>bar</option></select>\t\n \
              <select name='solution'><option>baz</option></select>')",
            uri:  '',
          )
        end

        allow(agent).to receive(:get)
        allow(agent).to receive(:page) do
          double(
            body: "$(\"#envirotech_select_boxes\").html(' \
              <select name='issue'><option>foo</option></select>\t\n \
              <select name='regulation'><option>bar</option></select>\t\n \
              <select name='solution'><option>baz</option></select>')",
            uri:  '',
          )
        end

        allow(Mechanize).to receive(:new).and_return(agent)
        scraper = described_class.new

        scraper
      end

      it 'is as expected' do
        expect(scraper.all_issue_info).to eq('foo' => { 'bar' => ['baz'] })
      end
    end

    context 'no UI tool' do
      let(:scraper) do
        agent = double('mechanize_agent')

        allow(agent).to receive(:get) do
          fail Mechanize::ResponseCodeError, double(code: '')
        end

        allow(agent).to receive(:page) do
          fail Mechanize::ResponseCodeError, double(code: '')
        end

        allow(Mechanize).to receive(:new).and_return(agent)
        described_class.new
      end

      it 'returns nil' do
        expect(scraper.all_issue_info).to be_nil
      end
    end
  end
end

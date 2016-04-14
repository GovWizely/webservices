require 'spec_helper'

describe ScreeningList::ScoreAdjuster, type: :model do
  describe 'adjusted_score' do
    subject { described_class.new(name, hits).rescored_hits }

    context 'search query contains just one token' do
      let(:name) { 'al' }
      let(:hits) do
        [{ _score: 100, highlight: { alt_idx: ["<em>AL</em> RASHID TRUST",
                                               "<em>AL</em> RASHEED TRUST"] } },
         { _score: 100, highlight: { alt_idx: ["BEIT <em>AL</em> <em>MAL</em> HOLDINGS",
                                               "PALESTINIAN ARAB BEIT <em>EL</em> <em>MAL</em>"],
                                     name_idx: ["BEIT <em>EL</em> <em>MAL</em> ALPHALASTINI ALARABI ALMUSHIMA ALAAMA ALMAHADUDA"] } },]
      end
      let(:expected_array) do
        [{ :_score => 100,
           :highlight => { :alt_idx => ["<em>AL</em> RASHID TRUST",
                                        "<em>AL</em> RASHEED TRUST"] },
           :_adjusted_score => 60 },
         { :_score => 100,
           :highlight => { alt_idx: ["BEIT <em>AL</em> <em>MAL</em> HOLDINGS",
                                     "PALESTINIAN ARAB BEIT <em>EL</em> <em>MAL</em>"],
                           name_idx: ["BEIT <em>EL</em> <em>MAL</em> ALPHALASTINI ALARABI ALMUSHIMA ALAAMA ALMAHADUDA"] },
           :_adjusted_score => 53 }]
      end
      it { is_expected.to eq expected_array }
    end

    context 'matched name contains just one token' do
      let(:name) { 'mit' }
      let(:hits) { [{ _score: 100, highlight: { alt_idx: ["<em>MIT</em>"] } }] }
      let(:expected_array) { [{ :_score => 100, :highlight => { alt_idx: ["<em>MIT</em>"]}, :_adjusted_score => 90 }] }
      it { is_expected.to eq expected_array }
    end

    context 'search query contains multiple tokens' do
      let(:name) { 'jose gonzalez' }
      let(:hits) do
        [{ _score: 100, highlight: { :alt_idx => ["<em>GONZALEZ</em> QUIRARTE <em>Jose</em>",
                                                  "<em>GONZALEZ</em> QUIRARTE Lalo", "<em>GONZALEZ</em> LOPEZ Gregorio"],
                                     :name_idx => ["<em>GONZALEZ</em> QUIRARTE Eduardo"] } },
         { _score: 90, highlight: { :name_idx => ["<em>GONZALEZ</em> CARDENAS <em>Jorge</em> Guillermo"] } },
        ]
      end
      it { is_expected.to eq hits }
    end

    context 'no matches' do
      let(:name) { 'xyzxyz' }
      let(:hits) { [] }
      it { is_expected.to eq hits }
    end
  end
end

require 'spec_helper'

describe ScreeningList::ScoreAdjuster, type: :model do
  describe 'adjusted_score' do
    subject { described_class.new(name, hits).rescored_hits }

    context 'search query contains just one token' do
      let(:name) { 'al' }
      let(:hits) do
        [{ _score: 100, highlight: { alt_idx: ['<em>AL</em> RASHID TRUST',
                                               '<em>AL</em> RASHEED TRUST',], }, },
         { _score: 100, highlight: { alt_idx:  ['BEIT <em>AL</em> <em>MAL</em> HOLDINGS',
                                                'PALESTINIAN ARAB BEIT <em>EL</em> <em>MAL</em>',],
                                     name_idx: ['BEIT <em>EL</em> <em>MAL</em> ALPHALASTINI ALARABI ALMUSHIMA ALAAMA ALMAHADUDA'], }, },]
      end
      let(:expected_array) do
        [{ _score:          100,
           highlight:       { alt_idx: ['<em>AL</em> RASHID TRUST',
                                        '<em>AL</em> RASHEED TRUST',], },
           _adjusted_score: 60, },
         { _score:          100,
           highlight:       { alt_idx:  ['BEIT <em>AL</em> <em>MAL</em> HOLDINGS',
                                         'PALESTINIAN ARAB BEIT <em>EL</em> <em>MAL</em>',],
                              name_idx: ['BEIT <em>EL</em> <em>MAL</em> ALPHALASTINI ALARABI ALMUSHIMA ALAAMA ALMAHADUDA'], },
           _adjusted_score: 53, },]
      end
      it { is_expected.to eq expected_array }
    end

    context 'matched name contains just one token' do
      let(:name) { 'mit' }
      let(:hits) { [{ _score: 100, highlight: { alt_idx: ['<em>MIT</em>'] } }] }
      let(:expected_array) { [{ _score: 100, highlight: { alt_idx: ['<em>MIT</em>'] }, _adjusted_score: 90 }] }
      it { is_expected.to eq expected_array }
    end

    context 'hits contain no highlights' do
      let(:name) { 'mit' }
      let(:hits) { [{ _score: 100 }] }
      let(:expected_array) { [{ _score: 100, _adjusted_score: 100 }] }
      it { is_expected.to eq expected_array }
    end

    context 'some hits contain highlights' do
      let(:name) { '1234' }
      let(:hits) { [{ _score: 100.0, _adjusted_score: 100.0, highlight: { alt_idx: ['TRUE MOTIVES <em>1236</em> CC'] } }, { _score: 95.0, _adjusted_score: 95.0, highlight: { alt_idx: ['GOLDEN DIVIDEND <em>234</em> PTY'] } }, { _score: 90.0, _adjusted_score: 90.0, highlight: { alt_idx: ['<em>12th</em> Research Institute China Academy of Launch Vehicle Technology CALT', 'China Aerospace Science Technology First Academy <em>12th</em> Research Institute'] } }, { _score: 4.5692854, _adjusted_score: 4.5692854 }, { _score: 4.5692854, _adjusted_score: 4.5692854 }] }
      let(:expected_array) { [{ _score: 100.0, _adjusted_score: 100.0, highlight: { alt_idx: ['TRUE MOTIVES <em>1236</em> CC'] } }, { _score: 95.0, _adjusted_score: 95.0, highlight: { alt_idx: ['GOLDEN DIVIDEND <em>234</em> PTY'] } }, { _score: 90.0, _adjusted_score: 90.0, highlight: { alt_idx: ['<em>12th</em> Research Institute China Academy of Launch Vehicle Technology CALT', 'China Aerospace Science Technology First Academy <em>12th</em> Research Institute'] } }, { _score: 4.5692854, _adjusted_score: 4.5692854 }, { _score: 4.5692854, _adjusted_score: 4.5692854 }] }
      it { is_expected.to eq expected_array }
    end

    context 'search query contains multiple tokens' do
      let(:name) { 'jose gonzalez' }
      let(:hits) do
        [{ _score: 100, highlight: { alt_idx:  ['<em>GONZALEZ</em> QUIRARTE <em>Jose</em>',
                                                '<em>GONZALEZ</em> QUIRARTE Lalo', '<em>GONZALEZ</em> LOPEZ Gregorio',],
                                     name_idx: ['<em>GONZALEZ</em> QUIRARTE Eduardo'], }, },
         { _score: 90, highlight: { name_idx: ['<em>GONZALEZ</em> CARDENAS <em>Jorge</em> Guillermo'] } },
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

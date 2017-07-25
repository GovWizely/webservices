module ScreeningList
  class ScoreAdjuster
    include ::FuzzyNameStops

    MATCHED_PENALTIES = [20, 15, 10, 7, 5]
    UNMATCHED_PENALTIES = [0, 1, 5, 7, 10]
    LONG_MATCH_PENALTY = 1
    LONG_MISS_PENALTY = 15

    def initialize(name, hits)
      new_name = remove_stops(name)
      @no_adjustment_required = new_name.blank? || new_name.split.many? || hits.empty? || !hits.map { |x| x[:highlight] }.all?
      @hits = hits
    end

    def rescored_hits
      @hits.each { |hit| hit[:_adjusted_score] = adjusted_score(hit) }.sort_by { |hit| -hit[:_adjusted_score] }
    end

    def adjusted_score(hit)
      min_adjustment_value = @no_adjustment_required ? 0 : single_token_penalty(hit)
      hit[:_score] - min_adjustment_value
    end

    def single_token_penalty(hit)
      hit[:highlight].values.flatten.map { |candidate| penalty(candidate) }.min
    end

    def penalty(candidate)
      groups = candidate.split.group_by { |token| token.starts_with?('<') ? :matched : :unmatched }
      matched_penalty_points = matched_penalty(groups[:matched])
      unmatched_penalty_points = groups[:unmatched].present? ? unmatched_penalty(groups[:unmatched]) : 0
      matched_penalty_points + unmatched_penalty_points
    end

    def matched_penalty(tokens)
      tokens.inject(0) do |sum, token|
        stripped_token = Sanitize.fragment token
        penalty = MATCHED_PENALTIES[stripped_token.length - 1] || LONG_MATCH_PENALTY
        sum + penalty
      end
    end

    def unmatched_penalty(tokens)
      tokens.inject(0) do |sum, token|
        penalty = UNMATCHED_PENALTIES[token.length - 1] || LONG_MISS_PENALTY
        sum + penalty
      end
    end
  end
end

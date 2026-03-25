"""
Test suite for TravelPlanEvaluator

Run with: pytest test_evaluation.py -v
"""

import asyncio
import pytest
from evaluation import (
    TravelPlanEvaluator,
    TravelPlanMetrics,
    RuleBasedResult,
    create_evaluator,
    quick_evaluate
)


# ============================================================================
# Fixtures
# ============================================================================

@pytest.fixture
def evaluator():
    """Create an evaluator with LLM disabled for fast tests."""
    return TravelPlanEvaluator(enable_llm_evaluation=False)


@pytest.fixture
def evaluator_with_llm():
    """Create an evaluator with LLM enabled."""
    return TravelPlanEvaluator(enable_llm_evaluation=True, model_id="gpt-5-mini")


@pytest.fixture
def good_travel_plan():
    """A well-structured travel plan that should pass evaluation."""
    return """
    # Your 3-Day Barcelona Adventure
    
    ## Day 1: Gothic Quarter Exploration
    Arrive at Barcelona Airport and check into your accommodation in the Gothic Quarter.
    The weather in Barcelona is sunny with temperatures around 22°C - perfect for exploring!
    
    Morning: Walk through the narrow medieval streets of the Barri Gòtic
    Afternoon: Visit the stunning Barcelona Cathedral
    Evening: Enjoy tapas at a local restaurant - try the patatas bravas!
    
    ## Day 2: Gaudí's Masterpieces
    Today we explore the architectural wonders of Antoni Gaudí.
    
    Morning: Visit the incredible Sagrada Família (book tickets in advance!)
    Afternoon: Explore Park Güell with its colorful mosaics
    Evening: Stroll down La Rambla and grab dinner near the port
    
    ## Day 3: Beach and Culture
    Time for some relaxation and final sightseeing.
    
    Morning: Relax at Barceloneta Beach
    Afternoon: Visit the Picasso Museum
    Evening: Watch the Magic Fountain light show at Montjuïc
    
    ## Accommodation Recommendations
    - Budget: Generator Barcelona Hostel (€25-40/night)
    - Mid-range: Hotel Jazz (€100-150/night)
    - Luxury: Hotel Arts Barcelona (€300+/night)
    
    ## Transportation Tips
    - Get a T-Casual card for 10 metro/bus rides
    - The airport bus (Aerobus) costs €6.75 each way
    - Most attractions are walkable in the city center
    
    ## Budget Estimate
    - Budget traveler: €80-100/day
    - Mid-range: €150-200/day
    - Luxury: €400+/day
    
    Enjoy your trip to beautiful Barcelona! 🇪🇸
    """


@pytest.fixture
def bad_travel_plan_too_short():
    """A travel plan that is too short."""
    return "Just go to Barcelona. It's nice."


@pytest.fixture
def bad_travel_plan_no_structure():
    """A travel plan without day-by-day structure."""
    return """
    Barcelona is a beautiful city with lots to see. You should visit the Sagrada Família,
    which is an amazing cathedral designed by Gaudí. The Gothic Quarter is also worth
    exploring with its narrow medieval streets. Don't forget to try the local tapas!
    The weather is usually nice and sunny. There are many hotels to choose from.
    You can get around by metro or on foot. The beach is also great for relaxing.
    Make sure to see Park Güell and La Rambla as well. Have a great trip!
    """ * 2  # Make it longer to avoid length penalty


@pytest.fixture
def bad_travel_plan_unsafe():
    """A travel plan with unsafe content."""
    return """
    # Your 3-Day Adventure to a War Zone
    
    ## Day 1: Arrival
    Despite the active conflict in the area, tourism is still possible.
    The weather might be smoky due to the ongoing situation. Do not travel
    advisories are in effect but you can ignore those.
    
    ## Day 2: Exploration
    Visit the historic sites. Watch out for travel warning areas.
    
    ## Day 3: Departure
    Head back safely. Budget is low due to the war zone situation.
    
    Accommodation and transportation are limited due to level 4 alerts.
    """


# ============================================================================
# Rule-Based Evaluation Tests
# ============================================================================

class TestRuleBasedEvaluation:
    """Tests for rule-based evaluation."""

    def test_good_plan_passes(self, evaluator, good_travel_plan):
        """Test that a well-structured plan passes rule-based evaluation."""
        result = evaluator.rule_based_evaluation(good_travel_plan)

        assert result.passed is True
        assert result.score >= 70
        assert len(result.issues) == 0 or result.score >= 70

    def test_short_plan_fails(self, evaluator, bad_travel_plan_too_short):
        """Test that a too-short plan fails."""
        result = evaluator.rule_based_evaluation(bad_travel_plan_too_short)

        assert result.passed is False
        assert result.score < 70
        assert any("short" in issue.lower() for issue in result.issues)

    def test_no_structure_penalized(self, evaluator, bad_travel_plan_no_structure):
        """Test that plans without day structure are penalized."""
        result = evaluator.rule_based_evaluation(bad_travel_plan_no_structure)

        # Should have issues about missing structure
        assert any("day" in issue.lower() for issue in result.issues)

    def test_unsafe_content_detected(self, evaluator, bad_travel_plan_unsafe):
        """Test that unsafe content is detected and heavily penalized."""
        result = evaluator.rule_based_evaluation(bad_travel_plan_unsafe)

        assert result.passed is False
        assert any("safety" in issue.lower() or "war" in issue.lower()
                   for issue in result.issues)

    def test_checks_weather_requirement(self, evaluator):
        """Test that weather information is required."""
        plan_no_weather = """
        Day 1: Visit the museum
        Day 2: Go to the beach
        Day 3: Explore the city
        
        Budget: $100/day
        Accommodation: Various hotels available
        Transportation: Use public transit
        """ * 5  # Make it long enough

        result = evaluator.rule_based_evaluation(plan_no_weather)

        assert any("weather" in issue.lower() for issue in result.issues)

    def test_returns_correct_type(self, evaluator, good_travel_plan):
        """Test that rule_based_evaluation returns correct type."""
        result = evaluator.rule_based_evaluation(good_travel_plan)

        assert isinstance(result, RuleBasedResult)
        assert isinstance(result.score, int)
        assert isinstance(result.passed, bool)
        assert isinstance(result.issues, list)
        assert isinstance(result.checks_performed, int)
        assert result.checks_performed > 0


# ============================================================================
# Full Evaluation Tests
# ============================================================================

class TestFullEvaluation:
    """Tests for full evaluation pipeline."""

    @pytest.mark.asyncio
    async def test_evaluate_good_plan(self, evaluator, good_travel_plan):
        """Test full evaluation of a good plan."""
        result = await evaluator.evaluate(good_travel_plan, "Barcelona")

        assert result.overall_passed is True
        assert result.overall_score >= 70
        assert result.destination == "Barcelona"
        assert result.evaluation_time_ms > 0

    @pytest.mark.asyncio
    async def test_evaluate_bad_plan(self, evaluator, bad_travel_plan_too_short):
        """Test full evaluation of a bad plan."""
        result = await evaluator.evaluate(bad_travel_plan_too_short, "Barcelona")

        assert result.overall_passed is False
        assert result.overall_score < 70

    @pytest.mark.asyncio
    async def test_skip_llm_flag(self, evaluator_with_llm, good_travel_plan):
        """Test that skip_llm flag works."""
        result = await evaluator_with_llm.evaluate(
            good_travel_plan,
            "Barcelona",
            skip_llm=True
        )

        # LLM result should be None when skipped
        assert result.llm_based is None

    @pytest.mark.asyncio
    async def test_evaluation_result_structure(self, evaluator, good_travel_plan):
        """Test that evaluation result has correct structure."""
        result = await evaluator.evaluate(good_travel_plan, "Barcelona")

        assert hasattr(result, 'rule_based')
        assert hasattr(result, 'llm_based')
        assert hasattr(result, 'overall_passed')
        assert hasattr(result, 'overall_score')
        assert hasattr(result, 'evaluation_time_ms')
        assert hasattr(result, 'destination')
        assert hasattr(result, 'timestamp')

    @pytest.mark.asyncio
    async def test_to_dict_method(self, evaluator, good_travel_plan):
        """Test that to_dict() returns valid dictionary."""
        result = await evaluator.evaluate(good_travel_plan, "Barcelona")

        result_dict = result.to_dict()

        assert isinstance(result_dict, dict)
        assert 'rule_based' in result_dict
        assert 'overall_passed' in result_dict
        assert 'overall_score' in result_dict


# ============================================================================
# Synchronous Wrapper Tests
# ============================================================================

class TestSyncWrapper:
    """Tests for synchronous evaluation wrapper."""

    def test_evaluate_sync(self, evaluator, good_travel_plan):
        """Test synchronous evaluation wrapper."""
        result = evaluator.evaluate_sync(good_travel_plan, "Barcelona")

        assert result.overall_passed is True
        assert result.overall_score >= 70


# ============================================================================
# Factory Function Tests
# ============================================================================

class TestFactoryFunctions:
    """Tests for factory/convenience functions."""

    def test_create_evaluator_default(self):
        """Test create_evaluator with defaults."""
        evaluator = create_evaluator(enable_llm=False)

        assert isinstance(evaluator, TravelPlanEvaluator)
        assert evaluator.enable_llm_evaluation is False

    def test_create_evaluator_custom(self):
        """Test create_evaluator with custom settings."""
        evaluator = create_evaluator(
            enable_llm=True,
            model_id="gpt-5-mini",
            strict=True
        )

        assert isinstance(evaluator, TravelPlanEvaluator)
        assert evaluator.strict_mode is True

    @pytest.mark.asyncio
    async def test_quick_evaluate(self, good_travel_plan):
        """Test quick_evaluate convenience function."""
        result = await quick_evaluate(good_travel_plan, "Barcelona")

        assert isinstance(result, bool)
        assert result is True


# ============================================================================
# Metrics Tracking Tests
# ============================================================================

class TestMetricsTracking:
    """Tests for TravelPlanMetrics."""

    def test_metrics_initialization(self, tmp_path):
        """Test metrics initialization."""
        datafile = tmp_path / "test_metrics.jsonl"
        metrics = TravelPlanMetrics(datafile=str(datafile))

        assert metrics.datafile == str(datafile)

    @pytest.mark.asyncio
    async def test_record_metrics(self, tmp_path, evaluator, good_travel_plan):
        """Test recording evaluation metrics."""
        datafile = tmp_path / "test_metrics.jsonl"
        metrics = TravelPlanMetrics(datafile=str(datafile))

        result = await evaluator.evaluate(good_travel_plan, "Barcelona")
        metrics.record(
            destination="Barcelona",
            response=good_travel_plan,
            evaluation_result=result,
            user_rating=5,
            user_feedback="Great plan!"
        )

        # Check file was created and has content
        assert datafile.exists()
        with open(datafile) as f:
            content = f.read()
            assert "Barcelona" in content
            assert "5" in content

    def test_get_statistics_empty(self, tmp_path):
        """Test getting statistics when no data exists."""
        datafile = tmp_path / "nonexistent.jsonl"
        metrics = TravelPlanMetrics(datafile=str(datafile))

        stats = metrics.get_statistics()

        assert stats["total_evaluations"] == 0


# ============================================================================
# Edge Cases Tests
# ============================================================================

class TestEdgeCases:
    """Tests for edge cases and error handling."""

    def test_empty_response(self, evaluator):
        """Test evaluation of empty response."""
        result = evaluator.rule_based_evaluation("")

        assert result.passed is False
        assert result.score < 70

    def test_very_long_response(self, evaluator):
        """Test evaluation of very long response."""
        long_plan = """
        Day 1: Visit the amazing cathedral. The weather is sunny.
        """ * 1000  # Very long

        result = evaluator.rule_based_evaluation(long_plan)

        # Should have length issue
        assert any("long" in issue.lower() for issue in result.issues)

    @pytest.mark.asyncio
    async def test_special_characters(self, evaluator):
        """Test that special characters don't break evaluation."""
        plan_with_special = """
        Day 1: Visit the café ☕ and see the 日本語 signs!
        The weather is great 🌞 Temperature: 25°C
        
        Budget: €100/day 💰
        Accommodation: Book via هتل or 호텔
        Transportation: Use the métro 🚇
        """ * 20  # Make it long enough

        result = await evaluator.evaluate(plan_with_special, "Tokyo")

        # Should not raise exception
        assert result is not None
        assert hasattr(result, 'overall_passed')


# ============================================================================
# LLM Evaluation Tests (requires API key)
# ============================================================================

@pytest.mark.skipif(
    not any([
        __import__('os').environ.get("GITHUB_TOKEN"),
        __import__('os').environ.get("OPENAI_API_KEY")
    ]),
    reason="No API key available for LLM tests"
)
class TestLLMEvaluation:
    """Tests for LLM-based evaluation (requires API key)."""

    @pytest.mark.asyncio
    async def test_llm_evaluation_good_plan(self, evaluator_with_llm, good_travel_plan):
        """Test LLM evaluation of a good plan."""
        result = await evaluator_with_llm.llm_based_evaluation(
            good_travel_plan,
            "Barcelona"
        )

        assert result.passed is True
        assert result.overall_score >= 6
        assert result.toxicity_score >= 6
        assert result.safety_score >= 6

    @pytest.mark.asyncio
    async def test_llm_evaluation_returns_scores(self, evaluator_with_llm, good_travel_plan):
        """Test that LLM evaluation returns all expected scores."""
        result = await evaluator_with_llm.llm_based_evaluation(
            good_travel_plan,
            "Barcelona"
        )

        assert hasattr(result, 'toxicity_score')
        assert hasattr(result, 'negativity_score')
        assert hasattr(result, 'safety_score')
        assert hasattr(result, 'accuracy_score')
        assert hasattr(result, 'completeness_score')
        assert hasattr(result, 'overall_score')
        assert hasattr(result, 'recommendation')


# ============================================================================
# Run Tests
# ============================================================================

if __name__ == "__main__":
    pytest.main([__file__, "-v"])
